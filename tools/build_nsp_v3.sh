#!/usr/bin/env bash
set -euo pipefail

export DEVKITPRO=/opt/devkitpro
export PATH=/opt/devkitpro/tools/bin:/opt/devkitpro/devkitA64/bin:$PATH

echo "[0/5] Syncing modified source, icon, NACP, and patched Picture XYZ assets..."
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/platform/switch/main.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/platform/switch/main.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/platform/switch/input_mapping.h /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/platform/switch/input_mapping.h
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/platform/switch/input_buttons.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/platform/switch/input_buttons.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/game_config.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/game_config.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/filesystem_stream.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/filesystem_stream.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/scene.h /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/scene.h
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/scene.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/scene.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/scene_save.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/scene_save.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/scene_settings.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/scene_settings.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/scene_title.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/scene_title.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/scene_keyguide.h /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/scene_keyguide.h
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/src/scene_keyguide.cpp /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/src/scene_keyguide.cpp
cp /mnt/d/YumeNikki-Nx/work/src/easyrpg-player-0.8.1.1/CMakeLists.txt /home/ubuntu/yn-build/vendor/easyrpg-player-0.8.1.1/CMakeLists.txt
rm -f /home/ubuntu/yn-build/package_v2/romfs/Picture/*.png
cp /mnt/d/YumeNikki-Nx/work/patched_picture/*.xyz /home/ubuntu/yn-build/package_v2/romfs/Picture/
cp /mnt/d/YumeNikki-Nx/work/icon_256.jpg /home/ubuntu/yn-build/package_v2/control/icon_AmericanEnglish.dat
cp /mnt/d/YumeNikki-Nx/work/icon_256.jpg /home/ubuntu/yn-build/package_v2/control/icon_SimplifiedChinese.dat
cp /mnt/d/YumeNikki-Nx/work/icon_256.jpg /home/ubuntu/yn-build/package_v2/control/icon_TraditionalChinese.dat
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
cp ./out/0100a1b2c3d40000.nsp /mnt/d/YumeNikki-Nx/dist/梦日记_interim2.nsp

echo "[5/5] Verifying output artifacts..."
ls -la /mnt/d/YumeNikki-Nx/dist/梦日记_interim2.nsp /mnt/d/YumeNikki-Nx/dist/梦日记_standalone.nro
sha256sum /mnt/d/YumeNikki-Nx/dist/梦日记_interim2.nsp /mnt/d/YumeNikki-Nx/dist/梦日记_standalone.nro
