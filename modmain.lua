-- 主菜单视频壁纸 + 自定义主菜单音乐
-- 代码来源标注：整体结构、以及"循环衔接处用首帧图盖在视频上层"的做法，参考创意工坊 mod
-- 「温蒂动态壁纸」（作者 zzzzzzzs、临夏听舟，published file id 3547896422）；
-- 多槽位壁纸扫描、首帧贴图与图集生成、音频包接入、配置项为本 mod 自行实现。

GLOBAL.setmetatable(env, {
    __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end
})

local MOVIE_SLOTS = 8
-- 画面比例只能靠这个常数：游戏里实测 Video 部件的 GetSize 在 Load 之后一律返回 (0, 0)，
-- 拿不到片子原生尺寸。1.ogv 的 Theora 头实测 1920x1020（不是 16:9），换成别的支持比例的素材时
-- 用配置项"视频比例"手动指定档位
local VIDEO_ASPECT = 1920 / 1020
-- 第一轮播完之前没法测出循环周期，所以自带素材直接写死游戏内实测到的时长（14.52s）。
-- 用户把 movies/N.ogv 换成别的片子时，这条种子会在"到点还没播完"之后自动作废，不会一直把画面冻住
local DURATION_HINTS = { [1] = 14.52 }
-- 配置项里的时长/比例档位：0 走各自默认（时长=实测循环周期，比例=上面的 VIDEO_ASPECT 常数）
local duration_cfg = GetModConfigData("video_duration")
local aspect_cfg = GetModConfigData("video_aspect")
local forced_duration = type(duration_cfg) == "number" and duration_cfg > 0 and duration_cfg or nil
-- 比例存成整数档，避开浮点 data 经存档序列化后回读不等的坑
local ASPECT_TIERS = { [1] = 16 / 9, [2] = 16 / 10, [3] = 1920 / 1020, [4] = 4 / 3, [5] = 21 / 9, [6] = 1 }
local forced_aspect = type(aspect_cfg) == "number" and ASPECT_TIERS[aspect_cfg] or nil
-- 音频包：音色库名 mymusic 决定 .fsb 文件名，工程名 mymusic.fbp 决定 .fev 文件名与事件路径前缀
local SOUND_BANK = "sound/mymusic"
local SOUND_FEV = "sound/mymusic.fbp"
local SOUND_EVENT_ROOT = "mymusic.fbp/untitled/"

PrefabFiles = {}

local function modfile(relpath)
    local ok, path = pcall(softresolvefilepath, (MODROOT or "") .. relpath)
    return ok and path or nil
end

-- 每槽位一个旁路配置 movies/<槽位>.cfg（纯文本，一行一项）：
--   duration=20.5      片子实际长度（秒），用来在第一圈就盖住接缝
--   aspect=16:9        画面比例，也接受 1920x1080 这种写法或直接写比值
-- 槽位多起来之后，全局档位就管不过来了（A 素材 20s、B 素材 60s 没法同时正确），
-- 所以让每个素材自带自己的参数；没这个文件时仍旧回落到配置项和内置种子。
local function read_cfg(relpath)
    local path = modfile(relpath)
    if path == nil then return nil end
    -- 沙盒里 io 不一定在，整段都包进 pcall，读不到就当作没有这个文件
    local ok, text = pcall(function()
        local f = io.open(path, "r")
        if f == nil then return nil end
        local data = f:read("*a")
        f:close()
        return data
    end)
    return ok and text or nil
end

local function parse_cfg(text)
    local out = {}
    if type(text) ~= "string" then return out end
    for line in text:gmatch("[^\r\n]+") do
        local key, value = line:match("^%s*(%a[%w_]*)%s*=%s*(.-)%s*$")
        if key and value ~= "" then
            local low = key:lower()
            if low == "duration" then
                local num = tonumber(value)
                if num and num > 0 and num < 3600 then out.duration = num end
            elseif low == "aspect" then
                local w, h = value:match("^(%d+)%s*[x:/%-,]%s*(%d+)$")
                local ratio = tonumber(value)
                if w and h and tonumber(h) > 0 then
                    ratio = tonumber(w) / tonumber(h)
                end
                if ratio and ratio > 0.2 and ratio < 8 then out.aspect = ratio end
            end
        end
    end
    return out
end

--------------------------------------------------------------------------
-- 资源注册：只登记实际存在的壁纸文件，空槽位自动跳过

local wallpapers = {}
Assets = {}

for slot = 1, MOVIE_SLOTS do
    local movie = "movies/" .. slot .. ".ogv"
    if modfile(movie) then
        Assets[#Assets + 1] = Asset("PKGREF", movie)
        local cfgtext = read_cfg("movies/" .. slot .. ".cfg")
        local cfg = parse_cfg(cfgtext)
        local entry = {
            movie = movie,
            duration_hint = cfg.duration or forced_duration or DURATION_HINTS[slot],
            aspect = cfg.aspect,
        }
        -- 可选：images/<槽位>.tex 首帧垫底图，配套的 xml 由本 mod 自己写，元素名固定为 "<槽位>.tex"
        local atlas = "images/" .. slot .. ".xml"
        local tex = "images/" .. slot .. ".tex"
        if modfile(atlas) and modfile(tex) then
            entry.atlas = atlas
            entry.element = slot .. ".tex"
            -- 主菜单用的是预加载列表，不登记的话运行时 Atlas 表里查不到这张图
            Assets[#Assets + 1] = Asset("IMAGE", tex)
            Assets[#Assets + 1] = Asset("ATLAS", atlas)
        end
        wallpapers[slot] = entry
        -- 只有中文的话这行会被日志剥掉，参数排错要靠它，保持 ASCII
        print("[p3r] wallpaper " .. slot .. " cfg=" .. tostring(cfgtext ~= nil) ..
              " duration=" .. tostring(entry.duration_hint) .. " aspect=" .. tostring(entry.aspect))
    end
end

Assets[#Assets + 1] = Asset("FILE", SOUND_BANK .. ".fsb")
Assets[#Assets + 1] = Asset("SOUNDPACKAGE", SOUND_FEV .. ".fev")

local function selected_wallpaper()
    local wanted = GetModConfigData("wallpaper")
    -- 关掉壁纸时不能回落到槽位 1，否则"关闭"这一档等于没生效
    if wanted == 0 then return nil end
    if wallpapers[wanted] then
        return wallpapers[wanted]
    end
    for slot = 1, MOVIE_SLOTS do
        if wallpapers[slot] then return wallpapers[slot] end
    end
end

--------------------------------------------------------------------------
-- 主菜单音乐

local MUSIC_TRACK_COUNT = 4
-- music 配置项里"随机播放"那一档的值；1~4 是定向曲目，0 是原版
local MUSIC_SHUFFLE = MUSIC_TRACK_COUNT + 1

local music_enabled = false
local music_shuffle = false
local music_track = nil

-- 洗牌时不让同一首连着放两次
local function pick_track()
    if MUSIC_TRACK_COUNT <= 1 then return 1 end
    local picked
    repeat
        picked = math.random(MUSIC_TRACK_COUNT)
    until picked ~= music_track
    return picked
end

local song = GetModConfigData("music")
if song == MUSIC_SHUFFLE then
    music_enabled, music_shuffle = true, true
    math.randomseed(os.time())
    music_track = pick_track()
elseif type(song) == "number" and song > 0 and song <= MUSIC_TRACK_COUNT then
    music_enabled = true
    music_track = song
end

if music_enabled then
    GLOBAL.FE_MUSIC = SOUND_EVENT_ROOT .. music_track
    TheSim:PreloadFile(SOUND_BANK .. ".fsb")
end

--------------------------------------------------------------------------
-- 壁纸部件：视频循环播放

local Video = require "widgets/video"
local Widget = require "widgets/widget"
local Image = require "widgets/image"

-- IsDone 翻回 false 只代表引擎接下了新一轮播放，第一帧还要一点时间才真的画出来，
-- 所以重开之后再垫一会儿才揭盖
local SEAM_REVEAL_DELAY = 0.35
-- 实测循环周期倒数这么多秒就先把首帧图盖上去：片子结尾自己有一段淡出的黑，
-- 等 IsDone 才盖就漏黑了，必须提前盖住尾巴
local SEAM_PRE_COVER = 0.7
-- IsDone 一直为真说明重开没生效，到这个点就再试一次 Play
local SEAM_MAX_COVER = 3
-- 时长种子比"到点了还没播完"再多等这么多秒就判定种子无效
local SEAM_GUESS_TOLERANCE = 1
-- 音乐停了多久之后重新触发。留出一点余量，避免起播/切场景那一瞬的假"没在响"造成重复叠播
local MUSIC_RESTART_DELAY = 1

local Wallpaper = Class(Widget, function(self, wallpaper)
    Widget._ctor(self, "Wallpaper")
    -- 槽位自带的比例优先（movies/N.cfg），其次才用配置项的档位
    self.aspect = wallpaper.aspect

    -- 黑底铺满整个视口，保证任何情况下都不会透出游戏场景
    self.backdrop = self:AddChild(Image("images/global.xml", "square.tex"))
    self.backdrop:SetHRegPoint(ANCHOR_MIDDLE)
    self.backdrop:SetVRegPoint(ANCHOR_MIDDLE)
    self.backdrop:SetTint(0, 0, 0, 1)

    -- 视频部件。全程从不 Hide，衔接靠首帧图浮在最上层顶住
    self.video = self:AddChild(Video("video"))
    self.video:Load(resolvefilepath(wallpaper.movie))
    self.video:SetHRegPoint(ANCHOR_MIDDLE)
    self.video:SetVRegPoint(ANCHOR_MIDDLE)

    if wallpaper.atlas then
        self.still = self:AddChild(Image(wallpaper.atlas, wallpaper.element))
        self.still:SetHRegPoint(ANCHOR_MIDDLE)
        self.still:SetVRegPoint(ANCHOR_MIDDLE)
        self.still:MoveToFront()
        self.still:Hide()
    end

    self.playing = false
    self.restarting = false
    self.cover_time = 0
    self.uptime = 0
    self.covered = false
    -- 周期先用素材自带的时长种子顶上，第一次 IsDone 之后换成实测值
    self.period = wallpaper.duration_hint
    self.period_guess = self.period ~= nil
    self.loop_start = 0
    self:SetClickable(false)
    self:UpdateWhilePaused(true)
    self:StartUpdating()
    self:Resize()
end)

-- fixed_root 按比例缩放，需把屏幕像素换算成设计坐标才能贴满
function Wallpaper:Resize()
    local screen_w, screen_h = TheSim:GetScreenSize()
    local scale = math.min(screen_w / RESOLUTION_X, screen_h / RESOLUTION_Y)
    local view_w, view_h = screen_w / scale, screen_h / scale
    local aspect = self.aspect or forced_aspect or VIDEO_ASPECT

    local w, h
    if GetModConfigData("fill") == 2 then
        w = math.min(view_w, view_h * aspect)
        h = math.min(view_h, view_w / aspect)
    else
        w, h = view_w, view_h
    end

    self.video:SetSize(w, h)
    -- 黑底铺满整个视口：保持比例模式下多出来的边也要盖住
    self.backdrop:SetSize(view_w, view_h)
    if self.still then self.still:SetSize(w, h) end
end

-- VideoWidget 没有 SetTint，所以不能用"把视频淡出"的办法露出底下的图
function Wallpaper:ShowCover()
    if self.covered or not self.still then return end
    self.covered = true
    self.still:Show()
end

function Wallpaper:HideCover()
    if not self.covered then return end
    self.covered = false
    self.still:Hide()
end

function Wallpaper:Play()
    if self.playing then return end
    self.playing = true
    self.video:Play()
end

-- 播完立刻在当前帧重开。原来用 inst:DoTaskInTime(0) 排任务，要等 scheduler 调度到，
-- 主菜单里这段时间不受控；重开越早，被垫住的时间就越短
function Wallpaper:OnUpdate(dt)
    self.uptime = self.uptime + dt
    if not self.playing then return end

    if self.video:IsDone() then
        self.cover_time = self.cover_time + dt
        self:ShowCover()
        if not self.restarting then
            self.restarting = true
            -- 跑到第一次播完才知道这一轮实际多长，后面几轮就按这个周期提前盖尾巴
            self.period = self.uptime - self.loop_start
            self.period_guess = nil
            self.loop_start = self.uptime
            self.video:Play()
        elseif self.cover_time >= SEAM_MAX_COVER then
            -- 重开没生效、一直停在播完状态：再试一次，不能干等着
            self.cover_time = 0
            self.video:Play()
        end
        return
    end

    if self.restarting then
        self.cover_time = self.cover_time + dt
        if self.cover_time >= SEAM_REVEAL_DELAY then
            self.restarting = false
            self.cover_time = 0
            self:HideCover()
        end
        return
    end

    -- 还没播完但已经进了尾巴：这段片子自己是淡出的，等 IsDone 才盖就漏黑了，提前盖住
    if self.period then
        local elapsed = self.uptime - self.loop_start
        if elapsed >= self.period - SEAM_PRE_COVER then
            self:ShowCover()
        end
        -- 用的是时长种子而到点还没播完，说明素材被换过了，这条立刻作废，不能一直冻着画面
        if self.period_guess and elapsed >= self.period + SEAM_GUESS_TOLERANCE then
            self.period, self.period_guess = nil, nil
            self:HideCover()
        end
    end
end

--------------------------------------------------------------------------
-- 主菜单接入

local chosen_wallpaper = selected_wallpaper()

-- 原版 FE_MUSIC 这个事件在 FMOD 里自己就是无限循环的，所以游戏只在主菜单构造时 PlaySound 一次；
-- 本 mod 盘里的歌是播一遍就结束，于是挂个看门狗：确认它响过之后，标签一旦不再 PlayingSound 就重新触发。
-- 需要借一个每帧 OnUpdate 的部件来跑
local function attach_music_watchdog(host)
    if not music_enabled then return end
    local sound = TheFrontEnd:GetSound()
    if not sound or type(sound.PlayingSound) ~= "function" then return end

    local heard, idle = false, 0
    local orig_update = host.OnUpdate
    function host:OnUpdate(dt)
        if sound:PlayingSound("FEMusic") then
            heard, idle = true, 0
        elseif heard then
            idle = idle + dt
            if idle >= MUSIC_RESTART_DELAY then
                idle = 0
                -- 洗牌档：每轮重开之前换一首，下一次 PlaySound 用的就是新事件路径
                if music_shuffle then
                    music_track = pick_track()
                    GLOBAL.FE_MUSIC = SOUND_EVENT_ROOT .. music_track
                end
                sound:PlaySound(FE_MUSIC, "FEMusic")
            end
        end
        if orig_update then return orig_update(self, dt) end
    end
end

-- 开关类选项（黑边/菜单底色/公告栏）与壁纸、音乐互相独立，所以这个钩子无条件装
AddClassPostConstruct("screens/redux/multiplayermainscreen", function(self)
    if GetModConfigData("sidebar") == 2 and self.sidebar then self.sidebar:Hide() end
    if GetModConfigData("letterbox") == 2 and self.letterbox then self.letterbox:Hide() end
    if GetModConfigData("motd") == 2 and self.motd_panel then self.motd_panel:Hide() end

    local host
    if chosen_wallpaper then
        if self.banner_root then self.banner_root:Hide() end
        host = self.fixed_root:AddChild(Wallpaper(chosen_wallpaper))
        host:MoveToBack()
        host:Play()
        -- 这里刻意不包装 OnHide/OnShow：子菜单打开时让视频继续解码，
        -- 返回主菜单就不会有重开门缝。在里面 Stop/Play 会直接让游戏 abort() 崩掉
    elseif music_enabled then
        -- 壁纸关掉了，没有会每帧回调的部件，建个空壳专门给音乐打点
        host = self.fixed_root:AddChild(Widget("P3RMusicTicker"))
        host:UpdateWhilePaused(true)
        host:StartUpdating()
    end

    if host then attach_music_watchdog(host) end
end)
