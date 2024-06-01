#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021-present 351ELEC (https://github.com/351ELEC)
# make by G.R.H

. /etc/profile

clear > /dev/console

if [ ! -f "/storage/roms/bios/freej2me-sdl.jar" ]; then
    cp /usr/config/game/freej2me/freej2me-sdl.jar /storage/roms/bios
    cp -rf /usr/config/game/java /storage/
fi

if [ ! -f "/storage/roms/bios/freej2me-lr.jar" ]; then
    cp /usr/config/game/freej2me/freej2me-lr.jar /storage/roms/bios
fi

if [ ! -f "/storage/roms/bios/freej2me-linux-aarch64.jar" ]; then
    cp /usr/config/game/freej2me/freej2me-linux-aarch64.jar /storage/roms/bios
fi

JDKDEST="/storage/jdk"
JDKNAME="zulu11.48.21-ca-jdk11.0.11"

mkdir -p ${JDKDEST}

[ "$(ls -A ${JDKDEST})" ] && JDKINSTALLED="yes" || JDKINSTALLED="no"

if [ ${JDKINSTALLED} == "no" ]; then
  if [ -f "/storage/data/jdk.zip" ]; then
      echo "Inflating JDK please be patient..." > /dev/console
      unzip -o "/storage/data/jdk.zip" -d "/storage" > /dev/console 2>&1
      chmod 755 -R ${JDKDEST}/*
  else
      echo -e "GET http://bing.com HTTP/1.0\n\n" | nc bing.com 80 > /dev/null 2>&1
      if [ $? -ne 0 ]; then
          text_viewer -e -w -t "No Internet!" -m "You need to be connected to the internet to download the JDK.";
          exit 1
      else
          echo "Downloading JDK please be patient..." > /dev/console
          cd ${JDKDEST}/..
          wget "https://cdn.azul.com/zulu-embedded/bin/${JDKNAME}-linux_aarch64.tar.gz" > /dev/console 2>&1
          echo "Inflating JDK please be patient..." > /dev/console
          tar xvfz ${JDKNAME}-linux_aarch64.tar.gz ${JDKNAME}-linux_aarch64/lib > /dev/console 2>&1
          tar xvfz ${JDKNAME}-linux_aarch64.tar.gz ${JDKNAME}-linux_aarch64/bin > /dev/console 2>&1
          tar xvfz ${JDKNAME}-linux_aarch64.tar.gz ${JDKNAME}-linux_aarch64/conf > /dev/console 2>&1
          rm ${JDKNAME}-linux_aarch64/lib/*.zip
          mv ${JDKNAME}-linux_aarch64/* jdk
          rm -rf ${JDKNAME}-linux_aarch64*

          for del in jmods include demo legal man DISCLAIMER LICENSE readme.txt release Welcome.html; do
            rm -rf ${JDKDEST}/${del}
          done
        fi
  fi
  echo "JDK done! loading core!" > /dev/console
  cp -rf /usr/config/game/freej2me/freej2me-lr.jar /storage/roms/bios
fi
chmod 777 -R ${JDKDEST}/*
clear > /dev/console < /dev/null 2>&1
exit 0
