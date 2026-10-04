#!/bin/sh
# 重新生成这三段示例壁纸（画面全部由 ffmpeg 程序化绘制，不含任何第三方素材）。
# 需要带 libtheora 编码器的 ffmpeg（7.x 官方构建即可）。
#
# 槽位 2：月夜山海 1920x1020 12s   槽位 3：黄昏天际线 1280x720 8s   槽位 4：极光 2016x864 16s
set -e
FF=${FFMPEG:-ffmpeg}

# 1) 先渲一张比目标尺寸大一圈的静帧（多出来的一圈留给平移，平移时不会露边）
$FF -loglevel error -y -filter_complex_script still_A_moonlit.filter.txt -map "[out]" -frames:v 1 -update 1 A_still.png
$FF -loglevel error -y -filter_complex_script still_B_dusk.filter.txt    -map "[out]" -frames:v 1 -update 1 B_still.png
$FF -loglevel error -y -filter_complex_script still_C_aurora.filter.txt  -map "[out]" -frames:v 1 -update 1 C_still.png

# 2) 循环视频：镜头位置用 sin(2*PI*t/T) 驱动，T 就是片子时长，
#    所以第 T 秒的画面严格等于第 0 秒，接缝在数学上就是连续的，不需要"正放+倒放"。
$FF -loglevel error -y -framerate 24 -loop 1 -t 12 -i A_still.png \
    -vf "crop=1920:1020:x='64+58*sin(2*PI*t/12)':y='35+26*sin(2*PI*t/12+1.9)',format=yuv420p" \
    -c:v libtheora -q:v 3 wallpaper2.ogv
$FF -loglevel error -y -framerate 24 -loop 1 -t 8 -i B_still.png \
    -vf "crop=1280:720:x='80+72*sin(2*PI*t/8)':y='45+38*sin(2*PI*t/8+2.4)',format=yuv420p" \
    -c:v libtheora -q:v 3 wallpaper3.ogv
$FF -loglevel error -y -framerate 24 -loop 1 -t 16 -i C_still.png \
    -vf "crop=2016:864:x='36+32*sin(2*PI*t/16)':y='16+13*sin(2*PI*t/16+1.1)',format=yuv420p" \
    -c:v libtheora -q:v 3 wallpaper4.ogv

# 3) 首帧垫图：取视频真正的第 0 帧（不是静帧原图，否则接缝处会跳一下）
$FF -loglevel error -y -i wallpaper2.ogv -vf "select=eq(n\,0)" -frames:v 1 -update 1 frame2.png
$FF -loglevel error -y -i wallpaper3.ogv -vf "select=eq(n\,0)" -frames:v 1 -update 1 frame3.png
$FF -loglevel error -y -i wallpaper4.ogv -vf "select=eq(n\,0)" -frames:v 1 -update 1 frame4.png

# 4) PNG -> .tex 要走 Klei 官方的 TEXCreator（Don't Starve Mod Tools 里那个），没有命令行版本。
#    用 32 位 PowerShell 反射调它，参数：textureType=1D(下拉框第 0 项)、pixelFormat=DXT5(第 2 项)、勾 mipmaps。
#    它写出来的头里 Flags 是 0，游戏里能用的那批贴图是 3，所以补一个字节：
#      printf '\375' | dd of=N.tex bs=1 seek=6 count=1 conv=notrunc
#    配套的 images/N.xml 手写即可，元素名固定 "<N>.tex"，uv 留半个纹素的内缩：
#      u1 = 0.5/宽  u2 = 1 - 0.5/宽  v1 = 0.5/高  v2 = 1 - 0.5/高
#    参考仓库 issue/README，本仓库直接给了生成好的 .tex，跳过这一步也能用。

# 5) 装进 mod 目录试玩（槽位号 = 文件名数字）
#    cp wallpaper2.ogv wallpaper2.cfg  ->  <mod>/movies/2.ogv  <mod>/movies/2.cfg
#    cp wallpaper2.tex wallpaper2.xml  ->  <mod>/images/2.tex  <mod>/images/2.xml
