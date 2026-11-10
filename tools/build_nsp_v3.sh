#!/usr/bin/env bash
set -euo pipefail

source /home/ubuntu/yn-build/env.sh
export DEVKITPRO=/opt/devkitpro
export PATH=/opt/devkitpro/tools/bin:/opt/devkitpro/devkitA64/bin:$PATH

echo "[0/5] Syncing modified source, icon, NACP, and patched Picture XYZ assets..."
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/platform/switch/main.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/platform/switch/main.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/platform/switch/ui.h /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/platform/switch/ui.h
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/platform/switch/ui.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/platform/switch/ui.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/platform/switch/bezel_png.h /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/platform/switch/bezel_png.h
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/platform/switch/input_mapping.h /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/platform/switch/input_mapping.h
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/platform/switch/input_buttons.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/platform/switch/input_buttons.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/game_config.h /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/game_config.h
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/game_config.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/game_config.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/filesystem_stream.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/filesystem_stream.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/scene.h /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/scene.h
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/scene.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/scene.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/scene_save.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/scene_save.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/scene_settings.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/scene_settings.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/scene_language.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/scene_language.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/scene_title.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/scene_title.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/CMakeLists.txt /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/CMakeLists.txt
cp /mnt/d/YumeNikki-Nx/work/patched_picture/SwitchKeyGuide.xyz /home/ubuntu/yn-build/package_v2/romfs/Picture/SwitchKeyGuide.xyz
cp /mnt/d/YumeNikki-Nx/work/patched_picture/SwitchKeyGuide.xyz /home/ubuntu/yn-build/package_v2/romfs/Language/zh/Picture/SwitchKeyGuide.xyz
cp /mnt/d/YumeNikki-Nx/work/patched_picture/SwitchKeyGuide.xyz /home/ubuntu/yn-build/package_v2/romfs/Language/zh_tr/Picture/SwitchKeyGuide.xyz
cp /mnt/d/YumeNikki-Nx/work/patched_picture/GameFlow.xyz /home/ubuntu/yn-build/package_v2/romfs/Picture/GameFlow.xyz
cp /mnt/d/YumeNikki-Nx/work/patched_picture/indream.xyz /home/ubuntu/yn-build/package_v2/romfs/Picture/indream.xyz

for lang_dir in "/home/ubuntu/yn-build/package_v2/romfs/Language/zh/Picture" "/home/ubuntu/yn-build/package_v2/romfs/Language/zh_tr/Picture"; do
  cp /mnt/d/YumeNikki-Nx/work/patched_picture/GameFlow.xyz "$lang_dir/000000000142.xyz"
  cp /mnt/d/YumeNikki-Nx/work/patched_picture/indream.xyz "$lang_dir/0000000138.xyz"
  cp /mnt/d/YumeNikki-Nx/work/patched_picture/FCgameflow.xyz "$lang_dir/00000000000049.xyz"
  cp /mnt/d/YumeNikki-Nx/work/patched_picture/FCindream.xyz "$lang_dir/000000000048.xyz"
  cp /mnt/d/YumeNikki-Nx/work/patched_picture/FamiGameIntro.xyz "$lang_dir/0000000000000000000149.xyz"
  cp "/mnt/d/YumeNikki-Nx/work/patched_picture/[G]frame.xyz" "$lang_dir/0000080.xyz"
  cp "/mnt/d/YumeNikki-Nx/work/patched_picture/[G1]Title.xyz" "$lang_dir/000000000000085.xyz"
done
cp "/mnt/d/YumeNikki-Nx/work/patched_picture/[G1]Title.xyz" /home/ubuntu/yn-build/package_v2/romfs/Picture/000000000000085.xyz

cp /mnt/d/YumeNikki-Nx/work/game/Map0002.lmu /home/ubuntu/yn-build/package_v2/romfs/Map0002.lmu
if [ -f /mnt/d/Download/iconfinal.png ]; then
  convert /mnt/d/Download/iconfinal.png -quality 98 /mnt/d/YumeNikki-Nx/work/icon_256.jpg
  cp /mnt/d/Download/iconfinal.png /mnt/d/YumeNikki-Nx/work/iconfinal.png
elif [ -f /mnt/d/YumeNikki-Nx/work/iconfinal.png ]; then
  convert /mnt/d/YumeNikki-Nx/work/iconfinal.png -quality 98 /mnt/d/YumeNikki-Nx/work/icon_256.jpg
elif [ -f /mnt/d/Download/ynologo.png ]; then
  convert /mnt/d/Download/ynologo.png -quality 98 /mnt/d/YumeNikki-Nx/work/icon_256.jpg
  cp /mnt/d/Download/ynologo.png /mnt/d/YumeNikki-Nx/work/ynologo.png
fi

LANG_ICONS=(
  "AmericanEnglish"
  "BritishEnglish"
  "Japanese"
  "French"
  "German"
  "LatinAmericanSpanish"
  "Spanish"
  "Italian"
  "Dutch"
  "CanadianFrench"
  "Portuguese"
  "Russian"
  "Korean"
  "TraditionalChinese"
  "SimplifiedChinese"
  "BrazilianPortuguese"
)
for lang in "${LANG_ICONS[@]}"; do
  cp /mnt/d/YumeNikki-Nx/work/icon_256.jpg "/home/ubuntu/yn-build/package_v2/control/icon_${lang}.dat"
done
python3 /mnt/d/YumeNikki-Nx/tools/patch_nacp.py /home/ubuntu/yn-build/package_v2/control/control.nacp

echo "[1/5] Running host unit test for SwitchInput::ApplyPad..."
g++ -std=c++17 -DUSE_SDL=1 \
  -I/home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src \
  -I/home/ubuntu/yn-build/vendor/liblcf-0.8.1/src \
  -I/opt/devkitpro/portlibs/switch/include \
  /mnt/d/YumeNikki-Nx/tools/tests/test_input_mapping.cpp \
  -o /tmp/test_input_mapping
/tmp/test_input_mapping

echo "[2/5] Compiling EasyRPG Player for Nintendo Switch..."
cmake -S /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1 -B /home/ubuntu/yn-build/build/switch-player -DPLAYER_WITH_FREETYPE=ON -DPLAYER_WITH_HARFBUZZ=ON
cmake --build /home/ubuntu/yn-build/build/switch-player -j"$(nproc)"

echo "[3/5] Generating ExeFS NSO and standalone NRO..."
/opt/devkitpro/tools/bin/elf2nso \
  /home/ubuntu/yn-build/build/switch-player/easyrpg-player.elf \
  /home/ubuntu/yn-build/package_v2/exefs/main

/opt/devkitpro/tools/bin/elf2nro \
  /home/ubuntu/yn-build/build/switch-player/easyrpg-player.elf \
  /mnt/d/YumeNikki-Nx/dist/梦日记_standalone.nro \
  --nacp=/home/ubuntu/yn-build/package_v2/control/control.nacp \
  --icon=/home/ubuntu/yn-build/package_v2/control/icon_AmericanEnglish.dat \
  --romfsdir=/home/ubuntu/yn-build/package_v2/romfs

echo "[4/5] Packaging NSP with hacBrewPack v3.05..."
cd /home/ubuntu/yn-build/package_v2
rm -rf hacbrewpack_temp hacbrewpack_nca hacbrewpack_nsp hacbrewpack_backup out nca
mkdir -p out nca

KEYS_FILE="/mnt/d/YumeNikki-Nx/keys/prod.keys"
if [ ! -f "$KEYS_FILE" ]; then
  KEYS_FILE="/mnt/d/Download/SwitchKeys/prod.keys"
fi
if [ ! -f "$KEYS_FILE" ]; then
  echo "Error: Switch prod.keys not found!"
  exit 1
fi

/home/ubuntu/yn-build/tools/hacbrewpack_src/hacBrewPack-master/hacbrewpack \
  --nologo --keepncadir \
  -k "$KEYS_FILE" \
  --nspdir ./out --ncadir ./nca > ./hacbrewpack_v3.log 2>&1

tail -n 25 ./hacbrewpack_v3.log
cp ./out/0100a1b2c3d40000.nsp /mnt/d/YumeNikki-Nx/dist/梦日记_v1.2.1.nsp

echo "[5/5] Verifying output artifacts..."
ls -la /mnt/d/YumeNikki-Nx/dist/梦日记_v1.2.1.nsp /mnt/d/YumeNikki-Nx/dist/梦日记_standalone.nro
sha256sum /mnt/d/YumeNikki-Nx/dist/梦日记_v1.2.1.nsp /mnt/d/YumeNikki-Nx/dist/梦日记_standalone.nro
