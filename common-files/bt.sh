#!/bin/bash

# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2023 JELOS (https://github.com/JustEnoughLinuxOS)

# Source predefined functions and variables
. /etc/profile

volume $(get_setting "audio.volume")
pactl set-port-latency-offset $(pactl list cards short | grep -E -o bluez.*[[:space:]]) headset-output 100000
