#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present JELOS (https://github.com/JustEnoughLinuxOS)

. /etc/profile

jslisten set "-9 drastic"

#load gptokeyb support files
control-gen_init.sh
source /storage/.config/gptokeyb/control.ini
get_controls

#Copy drastic files to .config
if [ ! -d "/storage/.config/drastic" ]; then
  mkdir -p /storage/.config/drastic/
  cp -r /usr/config/drastic/* /storage/.config/drastic/
fi

if [ ! -d "/storage/.config/drastic/system" ]; then
  mkdir -p /storage/.config/drastic/system
fi

for bios in nds_bios_arm9.bin nds_bios_arm7.bin
do
  if [ ! -e "/storage/.config/drastic/system/${bios}" ]; then
     if [ -e "/storage/roms/bios/${bios}" ]; then
       ln -sf /storage/roms/bios/${bios} /storage/.config/drastic/system
     fi
  fi
done

#Copy drastic files to .config
if [ ! -f "/storage/.config/drastic/drastic.gptk" ]; then
  cp -r /usr/config/drastic/drastic.gptk /storage/.config/drastic/
fi

#Copy drastic SDL.so to lib
if [ ! -f "/storage/.config/drastic/lib/libSDL2-2.0.so.0" ]; then
  cp -r /usr/config/drastic/lib/libSDL2-2.0.so.0 /storage/.config/drastic/lib/libSDL2-2.0.so.0
fi

#Make drastic savestate folder
if [ ! -d "/storage/roms/savestates/nds" ]; then
  mkdir -p /storage/roms/savestates/nds
fi

#Link savestates to roms/savestates/nds
rm -rf /storage/.config/drastic/savestates
ln -sf /storage/roms/savestates/nds /storage/.config/drastic/savestates

#Link saves to roms/nds/saves
rm -rf /storage/.config/drastic/backup
ln -sf /storage/roms/nds /storage/.config/drastic/backup

cd /storage/.config/drastic/

$GPTOKEYB "drastic" -c "drastic.gptk" &
export LD_LIBRARY_PATH=/storage/.config/drastic/lib
./drastic "$1"
kill -9 $(pidof gptokeyb)
