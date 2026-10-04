# 饥荒联机版主菜单动态壁纸 / DST Main-Menu Video Wallpaper

饥荒联机版（Don't Starve Together）的**纯客户端** mod：把主菜单背景换成循环播放的视频，
并能替换主菜单背景音乐。房主不需要安装。

> **名称与商标说明**：本项目与 ATLUS / SEGA 及《Persona 3 Reload》没有任何关联，也不是它的衍生作品，
> 仓库内不含任何来自该游戏的素材。提到 "P3R" 只是说明这个 mod 常被用来播放该类风格的壁纸，属于指示性描述。

创意工坊：<https://steamcommunity.com/sharedfiles/filedetails/?id=3812384622>

---

## 仓库里有什么

| 路径 | 说明 |
| --- | --- |
| `modmain.lua` | 全部逻辑：扫描壁纸槽位、主菜单挂钩、循环接缝处理、音乐切换 |
| `modinfo.lua` | 元信息 + 所有配置项（含中英双语 hover） |
| `mod.manifest` | Klei 打包用的清单（自己上传前请换一个新 UUID，否则会和已订阅的工坊版撞车） |
| `samples/` | 三段**原创**示例壁纸 + 一键重新生成的脚本，见下 |

## 仓库里**没有**什么（重要）

以下素材提取自《Persona 3 Reload》，版权归 ATLUS / SEGA，因此**不随源码发布**：

- `movies/1.ogv` —— 自带壁纸（P3R 主菜单循环片段）
- `sound/mymusic.fsb` / `sound/mymusic.fbp` —— 自带的主菜单配乐（FMOD 音色库）
- `images/1.tex` / `images/1.xml` —— 上面那段视频的首帧垫图
- `modicon.tex` / `modicon.xml` —— 工坊条目图标（P3R 角色图）

clone 下来直接跑的话：壁纸功能正常（把任意 `.ogv` 放进 `movies/1.ogv` 即可），
音乐部分需要自己准备 FMOD 音色库，或者删掉 `modmain.lua` 里这两行注册：

```lua
Assets[#Assets + 1] = Asset("FILE", SOUND_BANK .. ".fsb")
Assets[#Assets + 1] = Asset("SOUNDPACKAGE", SOUND_FEV .. ".fev")
```

## 安装

把整个目录放到 `Don't Starve Together/mods/<你的目录名>/`，或订阅工坊版。

## 配置项

| 键 | 含义 |
| --- | --- |
| `wallpaper` | 壁纸槽位 1~8、"随机轮换"（每次进主菜单换一张）、或"关闭"（不加载视频，只保留音乐和其他开关） |
| `fill` | 画面"铺满屏幕" / "保持比例" |
| `shade` | 画面压暗 0 / 10% / 20% / 30% / 45%，让亮壁纸上的菜单文字更好读 |
| `video_duration` | 视频时长档位；自定义素材填实际长度，第一圈就能干净衔接 |
| `video_aspect` | 画面比例档位（16:9 / 16:10 / 1920x1020 / 4:3 / 21:9 / 1:1） |
| `letterbox` | 原版上下黑边显示/隐藏 |
| `sidebar` | 左侧菜单栏底色显示/隐藏 |
| `motd` | 右侧公告栏显示/隐藏 |
| `music` | 内置 4 首 / 随机播放 / 原版 BGM |
| `music_volume` | 主菜单音量：默认 / 25% / 50% / 75%，只压主菜单这一首（音乐选"原版"时同样生效） |

## 用自己的素材

1. 视频转成 Theora `.ogv`（游戏不认 mp4），按 `movies/1.ogv` ~ `movies/8.ogv` 放进 mod 目录。
2. 每张素材可以写自己的参数：同目录放一个纯文本 `movies/N.cfg`，一行一项：
   ```
   # 井号开头是注释
   duration=20.5      # 片子实际长度（秒）
   aspect=16:9        # 也接受 1920x1080 或直接写比值
   ```
   有了 cfg 就不用再动配置项，换槽位也不会串参数。优先级：`cfg` > 配置项 > 内置种子。
3. 想要循环看不出接缝：选首尾画面接近、结尾不要淡出到黑的片子；
   或者用正弦驱动的镜头位移（见 `samples/generate.sh`），接缝在数学上就是连续的。
4. 再配一张同名首帧图 `images/N.tex` + `images/N.xml`，缺图时接缝处会垫黑。
5. 游戏没有读取片子原生尺寸的接口，"保持比例"默认按 1920x1020 画；素材被压扁就在比例档或 cfg 里指定。
6. 空槽位自动跳过，找不到指定槽位时回落到第一个可用素材。

## 关于声音：能做到和做不到

- 素材自带音轨的话游戏会**连声音一起放**，和背景音乐叠着响；素材那一轨本身没有音量控制，响不响、多响都取决于素材，
  但背景音乐可以用配置项「主菜单音量」压下去给它让路。
- **不能**换成自己的 mp3/ogg/wav。饥荒没有任何播放裸音频文件的接口，自定义音乐只能随 mod 打包预烘焙的 FMOD 音色库。
  实测把纯音轨的 `.ogg` 放进 `movies/` 彻底不认——`Video` 部件要求存在 Theora 画面轨，
  只有 Vorbis 的话一帧都解不出来，完全没有声音。
- 想用别的歌，目前只有一条路：用 ffmpeg 把音频封进一个带画面的 `.ogv`，当壁纸素材放进去。

## 示例素材（`samples/`）

`wallpaper2/3/4` 三段是本仓库自产的：画面全部用 ffmpeg 的 `geq`/`gradients` 滤镜程序化绘制
（月夜山海 1920x1020 12s、黄昏天际线 1280x720 8s、极光 2016x864 16s），不含任何第三方版权内容，
和代码一起按 MIT 许可发布。故意做成三种不同时长、三种不同比例，用来验证 `movies/N.cfg` 这条旁路。

`generate.sh` 是完整的复现命令；滤镜图存在同目录的 `still_*.filter.txt` 里。
试玩就按脚本末尾注释改名成 `movies/2.ogv` + `movies/2.cfg` + `images/2.tex` + `images/2.xml`。
这三段**只存在于仓库**：工坊发布包从 v8 起只带槽位 1（瘦身回 33 MB），想让它们进包得自己拷进 `movies/` 和 `images/`。

## 实现要点（都实测过）

- `Video` 部件没有循环 API，也没有 `SetTint`；`GetSize()` 在 `Load` 之后一律返回 `(0, 0)`，拿不到片子原生尺寸。
- 接缝处理：在预计播完前把首帧贴图盖在视频上层，再重新 `Play()`；`IsDone()` 之后才重播会黑一帧。
- 压暗：`Video` 不支持 `SetTint`，所以在壁纸部件最上层蒙一张 `images/global.xml` 的 `square.tex`，用 `SetTint(0,0,0,alpha)` 当半透明黑。这层必须加在**首帧垫图之上**，否则接缝换帧的那一下画面会跟着忽明忽暗。
- 随机轮换：扫描 `movies/` 时顺手记下"哪些槽位真的存在"，抽取只在这个表里做，所以空槽位不会被抽到；再用 `last_rotated_slot` 挡掉连续两次同一张。抽的时机是主菜单**构造**那一刻，也就是"每次回主菜单换一张"，不是"每次循环换一张"。
- 不要在主菜单的 `OnHide`/`OnShow` 里对 `Video` 调 `Stop`/`Play`，会触发原生断言崩在 `util/Pool.h`。
- 客户端 mod 的配置界面**只渲染 list 型选项**，`type="number"` 的不会出现 —— 所以每素材的数值参数走 `movies/N.cfg` 旁路文件（沙盒里 `io.open` + `softresolvefilepath` 可用）。
- 音量是挂在**事件标签**上的：`SoundEmitter:SetVolume("FEMusic", 0.5)`，它和游戏选项里的"音乐音量"是两条链（后者调 FMOD 的 `set_music` 总线），两者**叠乘**而不是互相覆盖。游戏每次重新 `PlaySound` 都可能把它顶回默认值，而 mod 的钩子在 post-construct、抢不到起播那一刻，所以要在"从没在响 → 在响"这个沿上补一次。
- 散包 `mods/<name>` 与已订阅的工坊版 UUID 相同时，**谁生效以模组列表的勾选为准**（两份都启用时工坊版顶掉散包）。所以测自己的新字节最省事的办法是改散包并在列表里启用它，别去动 `workshop/content/322330/<id>/`——那是 Steam 的地盘，一次 workshop query 就会用已发布的包把你改的覆盖掉。
- 日志里中文 `print` 会被剥掉，参数排错要靠 ASCII 探针行。

## 许可

代码 MIT（见 `LICENSE`）。**许可只覆盖代码与本仓库自产的示例素材**，
不包含上文明确排除的《Persona 3 Reload》相关素材，那些内容也不得从本仓库再分发。
`LICENSE` 保持标准 MIT 原文、范围声明写在这里，是因为 GitHub 的许可证识别只认纯模板文本，
追加段落会让条目显示成 "Other"。

## 参考与致谢

- 整体结构、以及"循环接缝处把首帧图盖在视频上层"的做法，参考创意工坊 mod
  「温蒂动态壁纸」（作者 zzzzzzzs、临夏听舟，条目 3547896422）。**借的是思路，不是代码。**
- 逐行比对（对象是该 mod 的 `modmain.lua` / `modinfo.lua` / `scripts/apis.lua`，共 57 KB）：
  本仓库 253 行有效代码里只有 **10 行**与它相同，且全部是 DST mod 的通用样板——
  `local Video/Widget/Image = require "widgets/…"` 三行、`modinfo.lua` 的 `*_compatible` 标志块、
  `GLOBAL.setmetatable(env, {`。反过来查，本 mod 的实现符号
  `MOVIE_SLOTS`、`read_cfg`、`parse_cfg`、`DURATION_HINTS`、`SEAM_PRE_COVER`、
  `attach_music_watchdog`、`MUSIC_SHUFFLE`、`ASPECT_TIERS` 在对方文件里出现 **0 次**：
  多槽位扫描、`movies/N.cfg` 旁路、随机播放看门狗、提前盖尾的接缝状态机、比例换算与黑底都是本仓库自行实现。
- 我们没有获得「温蒂动态壁纸」作者的代码授权，所以本仓库**也不含他们的任何代码**。
  若你要基于他们的实现做二次开发，请先到工坊页面确认对方的许可意愿。

---

# English

Client-only Don't Starve Together mod: looping video wallpaper on the main menu, plus optional
custom menu music. The host does not need it.

**What is not in this repo.** `movies/1.ogv`, `sound/*.fsb|*.fev`, `images/1.tex|1.xml` and
`modicon.*` are extracted from *Persona 3 Reload* and belong to ATLUS / SEGA, so they are not
redistributed here. The wallpaper feature works as soon as you drop any `.ogv` into `movies/1.ogv`;
for the music either bring your own FMOD bank or delete the two `Asset(...)` registration lines
quoted above.

**Bring your own footage.** Convert to Theora `.ogv` (mp4 is not supported), name it
`movies/1.ogv` ~ `movies/8.ogv`, and optionally add a plain-text `movies/N.cfg` next to it with
`duration=` and `aspect=` (per-asset settings beat the global option tiers). Add a first-frame
cover `images/N.tex` + `images/N.xml` or the seam is covered with black.

**Two more switches.** `wallpaper` also accepts *Rotate*: a different clip every time the main menu
is constructed, drawn only from slots that actually exist and never the same one twice in a row.
`shade` (none / 10% / 20% / 30% / 45%) dims the picture so the menu text stays readable on a bright
wallpaper — `Video` has no `SetTint`, so this is a translucent `square.tex` overlay, placed
deliberately *above* the first-frame cover so the seam does not flicker brighter.

**Sound, verified.** If your footage carries an audio track the game plays it, layered over the
menu music, with no volume control of its own — the `music_volume` option (Default / 25% / 50% / 75%) ducks
the *music* to make room, and it stacks with the game's own music-volume slider because that one drives
FMOD's `set_music` bus while this one sets the event's volume. You cannot use a bare audio file: DST has
no API for playing mp3/ogg/wav, and a `Video` widget needs a Theora video track — an audio-only `.ogg`
decodes nothing at all. The only workaround is muxing a song into a picture-bearing `.ogv`.

**`samples/`** holds three original wallpapers (1920x1020/12s, 1280x720/8s, 2016x864/16s) drawn
procedurally with ffmpeg filters, plus `generate.sh` to reproduce them. The camera drift is driven
by `sin(2*PI*t/T)` with `T` equal to the clip length, so the loop seam is continuous by construction.
They are deliberately three different durations and three different aspect ratios, to exercise the
`movies/N.cfg` path. They live in the repo only — the published workshop package ships slot 1 alone.

**License.** Code and the bundled original samples are MIT. The excluded *Persona 3 Reload* assets
are not. This project is not affiliated with ATLUS / SEGA and ships no material from their game.

**Credit.** The overall structure and the idea of covering the loop seam with a first-frame image
follow the workshop mod "Wendy Animated Wallpaper" (zzzzzzzs, 临夏听舟, item 3547896422) — the
*approach*, not the code. Line-by-line against that mod's `modmain.lua` / `modinfo.lua` /
`scripts/apis.lua` (57 KB): only 10 of our 253 substantive lines match, all of them universal DST
boilerplate (the three `require "widgets/…"` lines, the `*_compatible` flag block from Klei's
modinfo template, `GLOBAL.setmetatable(env, {`). Conversely, every symbol that carries this mod's
own logic — `MOVIE_SLOTS`, `read_cfg`, `parse_cfg`, `DURATION_HINTS`, `SEAM_PRE_COVER`,
`attach_music_watchdog`, `MUSIC_SHUFFLE`, `ASPECT_TIERS` — appears zero times in their files. We do
not have that author's permission to distribute their code, so none of it is in this repo either.
