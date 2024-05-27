#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present redwolftech
# Copyright (C) 2023 JELOS (https://github.com/JustEnoughLinuxOS)

. /etc/profile
jslisten set "mpv"

#load gptokeyb support files
control-gen_init.sh
source /storage/.config/gptokeyb/control.ini
get_controls

systemctl start mpv

FBWIDTH="$(fbwidth)"
FBHEIGHT="$(fbheight)"

ASPECT=$(printf "%.2f" $(echo "(${FBWIDTH} / ${FBHEIGHT})" | bc -l))

case ${ASPECT} in
  1.*)
   RES="${FBWIDTH}x${FBHEIGHT}"
  ;;
  0.*)
   RES="${FBHEIGHT}x${FBWIDTH}"
  ;;
esac

$GPTOKEYB "mpv" -c &

/usr/bin/mpv --fullscreen --geometry=${RES} --hwdec=auto-safe --input-ipc-server=/tmp/mpvsocket "${1}"

kill -9 $(pidof gptokeyb) 

systemctl stop mpv
exit 0
