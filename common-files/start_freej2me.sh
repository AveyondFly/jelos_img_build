#!/usr/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present 351ELEC (https://github.com/351ELEC)

. /etc/profile
#jslisten set "-9 java"

set_kill set "-9 sdl_interface"

export LANG="zh_CN.UTF-8"

if [[ "${2}" == "freej2me_mod" ]]; then
	/storage/java/j2me.sh $1
else
	JAVA_TOOL_OPTIONS='-Xverify:none -Djava.awt.headless=true -Dsun.jnu.encoding=UTF-8 -Dfile.encoding=UTF-8'
	export JAVA_TOOL_OPTIONS
	/storage/jdk/bin/java -jar /storage/java/freej2me-linux-aarch64.jar $1
fi

