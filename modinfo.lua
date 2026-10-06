name = "P3R 主菜单动态壁纸"
description = "感谢订阅。想要加的功能、或者碰到了问题，欢迎在评论区留言——这个 mod 是照着大家的使用反馈继续改的。\n\n致谢：循环衔接处“播完前用首帧图盖住再重播”的处理思路，参考创意工坊 mod「温蒂动态壁纸」（作者 zzzzzzzs、临夏听舟，条目 3547896422）。借的是思路，不是代码。\n\n壁纸署名：槽位 2 来自 Wallpaper Engine 条目 3141346973「Live2d- Persona 3 结城理 ゆうきまこと Yuuki Makoto (sound)」，槽位 3 来自条目 3794989445「【4k】Live2d动态壁纸-明日方舟联动P3R结城理 ゆうきまこと Yuuki Makoto (BGM：Brand New Days - 川村ゆみ)」，槽位 4 来自条目 3484837776「persona3 结城理」；本 mod 只做了裁剪、无缝循环处理和 Theora 转码，并且转码时去掉了音轨（原条目的 BGM 不在包内），画面著作权属于原作者与 Atlus/SEGA。槽位 1 则是提取自《Persona 3 Reload》的主菜单画面。喜欢这几张的话，请去原条目点个赞。\n\n把主菜单背景换成循环播放的视频，并可替换主菜单背景音乐（纯客户端 mod，房主不需要装）。自带壁纸 4 张（槽位 1~4，署名见上文）+ 4 首可选音乐（可选“随机播放”在四首之间洗牌，不会连着放同一首），音乐选“原版”即保留游戏自带 BGM。\n\n换自己的素材：视频按 movies/1.ogv ~ movies/8.ogv 放进 mod 目录（共 8 个槽位，Theora .ogv，游戏不认 mp4）。每张素材可以写自己的参数：同目录放一个 movies/N.cfg 纯文本，一行 duration=20.5、一行 aspect=16:9（比例也接受 1920x1080 或 1.777），它优先于配置项里的“视频时长/视频比例”。想要循环看不出接缝，请选首尾画面接近、结尾不要淡出到黑的片子，再配一张同名首帧图 images/N.tex + images/N.xml（缺图时接缝处会垫黑）。壁纸 2~8 没有文件时会自动回落到可用的那一个。自定义素材选“自动”时第一圈可能仍有一次短暂垫图（周期要播完才知道），把“视频时长”填成片子实际长度即可第一圈就干净。\n\n素材自带音轨的话，游戏会连声音一起放出来（和背景音乐叠着响，视频音量不能单独调，但可以用配置项“主菜单音量”把背景音乐压低）；自带 4 张壁纸都是纯画面轨，所以都不响。但背景音乐不能换成你自己的文件：饥荒没有播放 mp3/ogg/wav 这类裸音频的接口，纯音轨的 .ogg 就算放进 movies/ 也一帧都解不出来（实测），自定义音乐只能是随 mod 打包发布的 FMOD 音色库。想用别的歌，只有把声音封进带画面的 .ogv 当壁纸素材这一条路。\n\n配置项：壁纸槽位（含“随机轮换”和“关闭”档）、画面铺满/保持比例、画面压暗、视频时长、视频比例、原版黑边/左侧菜单底色/公告栏的显示隐藏、背景音乐、主菜单音量。\n\n“随机轮换”每次重新构造主菜单界面时抽一张，只在你实际放了文件的槽位之间抽，并且不会连着两次同一张（实测在子界面之间来回不算重新构造，所以基本就是每次启动游戏换一张）。“画面压暗”是在壁纸最上层蒙一层半透明黑（10/20/30/45%，默认不压暗），素材太亮、菜单按钮和文字看不清时开一档；它同时盖住接缝处的首帧垫图，所以接缝不会忽明忽暗。\n\n--- English ---\nThank you for subscribing - feature requests and bug reports in the comments are what keep this mod moving, so please leave one.\n\nCredits: the seam trick (cover the video with its own first frame just before the clip ends, then replay) follows the workshop mod Wendy Animated Wallpaper (zzzzzzzs, 临夏听舟, item 3547896422) - the approach, not the code. Wallpaper credits: slot 2 is a re-cut of Wallpaper Engine item 3141346973 \"Live2d- Persona 3 结城理 ゆうきまこと Yuuki Makoto (sound)\", slot 3 of 3794989445 \"【4k】Live2d动态壁纸-明日方舟联动P3R结城理 ゆうきまこと Yuuki Makoto (BGM：Brand New Days - 川村ゆみ)\", slot 4 of 3484837776 \"persona3 结城理\" - only the crop, the seamless-loop edit and the Theora transcode are ours, and the transcode drops the audio track, so the source items' BGM is not in this package; the artwork itself belongs to the original authors and to Atlus/SEGA. Slot 1 is extracted from the Persona 3 Reload main menu. If you like them, please rate the source items.\n\nReplaces the main menu background with a looping video, and optionally the main menu music. Client-only: only you need to install it, the host does not.\n\nShips with 4 wallpapers (slots 1-4) + 4 music tracks (Shuffle randomizes among the four, never repeating the same one twice in a row). Pick \"Vanilla / 原版\" to keep the game's own music.\n\nBring your own assets: drop videos into movies/1.ogv ~ movies/8.ogv (8 slots, Theora .ogv only, mp4 is not supported). Each clip can carry its own settings via a plain-text movies/N.cfg next to it - one line duration=20.5, one line aspect=16:9 (1920x1080 or 1.777 also work); the cfg wins over the Video duration / Video aspect options. For a loop you cannot see, use footage whose last frame resembles its first and that does not fade to black at the end, then add a matching first-frame cover images/N.tex + images/N.xml (without it the seam falls back to black). Slots with no file fall back to the first available wallpaper.\n\nNote: the first loop of custom footage may still flash the cover once, because the period is only known after it plays through; set the Video duration option (视频时长) to the clip's real length to get a clean seam from loop one.\n\nSound: if your footage carries an audio track, the widget plays it too (it layers over the menu music and has no separate volume - use the Menu volume option to duck the music instead) - all four bundled wallpapers are video-only, hence silent. Your own music files are NOT supported, though: Don't Starve Together has no way to play a bare audio file, and an audio-only .ogg dropped into movies/ decodes nothing (verified in-game), so custom music can only ever ship as a pre-baked FMOD bank inside the mod. The one workaround is to mux your song into a video-bearing .ogv and use it as a wallpaper.\n\nOptions: wallpaper slot (including Rotate and Off switches), fit (fill screen / keep aspect), shade, video duration, video aspect, vanilla letterbox, sidebar, MOTD panel, background music, menu music volume.\n\n\"Rotate\" draws a new wallpaper every time the main menu screen is rebuilt - only among the slots you actually have files for, and never the same one twice in a row (moving between sub-screens inside the same session does not rebuild the menu, so in practice it is one draw per game launch). \"Shade\" dims the video with a translucent black layer on top of it (10/20/30/45%, off by default): turn it on when bright footage makes the menu buttons hard to read. It also covers the first-frame still used at the seam, so the seam never flickers."
tagline = "主菜单循环视频背景 + 自定义背景音乐"
author = "白白"
version = 9
forumthread = ""

api_version = 6
api_version_dst = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
hamlet_compatible = false
all_clients_require_mod = false
client_only_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = { "主菜单", "壁纸" }

configuration_options = {
    {
        name = "wallpaper",
        label = "壁纸",
        hover = "视频文件放在 mod 目录的 movies/1.ogv ~ movies/8.ogv。\n没有对应文件的选项会自动回落到第一个可用壁纸。\n选“随机轮换”则每次回到主菜单换一张，只在实际存在的槽位之间抽，不会连着两次同一张。\n选“关闭”则不加载视频，主菜单恢复原样，此时音乐等其他选项仍然生效。\n素材若自带音轨，游戏会连声音一起放出来（跟音乐叠着响，没有单独的视频音量控制）；想只要画面就用纯画面轨的 .ogv，自带的 4 张壁纸都是这样所以都不响。\n多槽位时建议在 movies/<槽位>.cfg 里写这个素材自己的时长和比例，例：\nduration=20.5\naspect=16:9",
        default = 1,
        options = {
            { description = "壁纸 1", data = 1 },
            { description = "壁纸 2", data = 2 },
            { description = "壁纸 3", data = 3 },
            { description = "壁纸 4", data = 4 },
            { description = "壁纸 5", data = 5 },
            { description = "壁纸 6", data = 6 },
            { description = "壁纸 7", data = 7 },
            { description = "壁纸 8", data = 8 },
            { description = "随机轮换 / Rotate", data = 9 },
            { description = "关闭 / Off", data = 0 },
        },
    },
    {
        name = "video_duration",
        label = "视频时长",
        hover = "循环衔接用。选“自动”时，第一圈要等播完才知道周期，可能露一次尾巴；\n填上自己素材的实际时长，第一圈就能提前盖住接缝。\n自带壁纸 1 已内置实测时长 14.52s，一般不用改。\n填小了最多多闪一次垫图（约 2 秒后自动放弃纠正），填大了不会有任何影响。\n这里是对当前选中壁纸的全局设置；多个槽位素材各自的时长不同，请改用 movies/<槽位>.cfg 里的 duration=秒数（它优先于本档位）。",
        default = 0,
        options = {
            { description = "自动 / Auto", data = 0 },
            { description = "5 s", data = 5 },
            { description = "10 s", data = 10 },
            { description = "15 s", data = 15 },
            { description = "20 s", data = 20 },
            { description = "30 s", data = 30 },
            { description = "45 s", data = 45 },
            { description = "60 s", data = 60 },
            { description = "90 s", data = 90 },
        },
    },
    {
        name = "video_aspect",
        label = "视频比例",
        hover = "只在“保持比例”模式下起作用。\n默认按自带壁纸 1 的尺寸 1920x1020（≈16:8.5）。\n引擎没有读取片子原生尺寸的接口，所以换素材后若画面被压扁/拉扁，请在这里手动指定比例。\n多个槽位素材比例不同，请改用 movies/<槽位>.cfg 里的 aspect=16:9 或 aspect=1920x1080（它优先于本档位）。",
        default = 0,
        options = {
            { description = "默认 / Default", data = 0 },
            { description = "16:9", data = 1 },
            { description = "16:10", data = 2 },
            { description = "16:8.5", data = 3 },
            { description = "4:3", data = 4 },
            { description = "21:9", data = 5 },
            { description = "1:1", data = 6 },
        },
    },
    {
        name = "fill",
        label = "画面适配",
        hover = "铺满：视频拉伸到整个屏幕，非 16:9 屏幕会有变形。\n保持比例：视频不变形，多出来的部分留黑。",
        default = 1,
        options = {
            { description = "铺满屏幕", data = 1 },
            { description = "保持比例", data = 2 },
        },
    },
    {
        name = "shade",
        label = "画面压暗",
        hover = "在壁纸最上层蒙一层半透明黑，让主菜单的按钮和文字看得清。\n档位就是这层黑的不透明度：20% 即压掉两成亮度。\n压暗同时盖住循环接缝的首帧垫图，所以接缝处不会忽明忽暗。\n素材本身很暗、或者只想看原画，就选“不压暗”。",
        default = 0,
        options = {
            { description = "不压暗 / None", data = 0 },
            { description = "10%", data = 1 },
            { description = "20%", data = 2 },
            { description = "30%", data = 3 },
            { description = "45%", data = 4 },
        },
    },
    {
        name = "letterbox",
        label = "原版黑边",
        hover = "主菜单前景的上下/左右黑色遮罩。",
        default = 2,
        options = {
            { description = "显示", data = 1 },
            { description = "隐藏", data = 2 },
        },
    },
    {
        name = "sidebar",
        label = "左侧菜单栏底色",
        default = 1,
        options = {
            { description = "显示", data = 1 },
            { description = "隐藏", data = 2 },
        },
    },
    {
        name = "motd",
        label = "公告栏",
        hover = "主菜单右侧的活动/新闻面板。",
        default = 2,
        options = {
            { description = "显示", data = 1 },
            { description = "隐藏", data = 2 },
        },
    },
    {
        name = "music",
        label = "主菜单音乐",
        hover = "选“原版”则保留游戏自带的主菜单音乐。\n“随机播放”会在上面 4 首之间洗牌，每首播完接下一首，不会连着放同一首。\n这里不能换成自己的音乐文件：游戏没有播放 mp3/ogg/wav 的接口，自定义音乐必须打成 FMOD 音色库随 mod 发布。\n想用别的歌，只能把声音封进带画面的 .ogv 里当壁纸素材（见壁纸说明）。",
        default = 1,
        options = {
            { description = "1. want_to_be_close", data = 1 },
            { description = "2. wall_moon_full_life", data = 2 },
            { description = "3. color_your_night", data = 3 },
            { description = "4. changing_seasons", data = 4 },
            { description = "随机播放 / Shuffle", data = 5 },
            { description = "原版 / Vanilla", data = 0 },
        },
    },
    {
        name = "music_volume",
        label = "主菜单音量",
        hover = "只压主菜单这一首的音量。游戏选项里的“音乐音量”调的是总音量，这一档是在它基础上再压低，两者叠乘。\n选“默认”就是不动它。\n音乐选“原版”时这一档同样生效。\n壁纸素材自带音轨、跟背景音乐叠着嫌吵时，用它把背景音乐压低一档。",
        default = 0,
        options = {
            { description = "默认 / Default", data = 0 },
            { description = "25%", data = 1 },
            { description = "50%", data = 2 },
            { description = "75%", data = 3 },
        },
    },
}
