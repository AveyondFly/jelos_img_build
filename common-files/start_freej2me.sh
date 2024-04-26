#!/usr/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present 351ELEC (https://github.com/351ELEC)

. /etc/profile
#jslisten set "-9 java"

export LANG="zh_CN.UTF-8"
/storage/jdk/bin/java -jar /storage/roms/bios/freej2me-linux-aarch64.jar $1

