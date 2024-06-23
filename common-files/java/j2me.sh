#!/bin/bash
. /etc/profile
. /etc/os-release

#jslisten stop

cd /storage/java

JAVA_HOME='/storage/jdk'
export JAVA_HOME
PATH="$JAVA_HOME/bin:$PATH"
export PATH

mkdir -p ./.java/.systemPrefs
mkdir -p ./.java/.userPrefs
chmod -R 755 ./.java

export LANG="zh_CN.UTF-8"

#JAVA_TOOL_OPTIONS='-Xverify:none -Djava.util.prefs.systemRoot=/storage/roms/savestates/j2me/ -Djava.util.prefs.userRoot=/storage/roms/savestates/j2me/ -Djava.awt.headless=true -Dsun.jnu.encoding=UTF-8 -Dfile.encoding=UTF-8 -Djava.library.path=/storage/java/lib'
JAVA_TOOL_OPTIONS='-Xverify:none -Djava.awt.headless=true -Dsun.jnu.encoding=UTF-8 -Dfile.encoding=UTF-8 -Djava.library.path=/storage/java/lib'
export JAVA_TOOL_OPTIONS

#jslisten set "java"


gamedir=`dirname "$1"`

if echo $gamedir | grep "240x320" > /dev/null
then
	# echo "240*320" >>0.txt
	java -jar /storage/java/freej2me-sdl.jar "$1" 240 320 100

elif echo $gamedir | grep "320x240" > /dev/null
then
	# echo "320*240" >>0.txt
	java -jar /storage/java/freej2me-sdl.jar "$1" 320 240 100

elif echo $gamedir | grep "128x128" > /dev/null
then
	# echo "128*128" >>0.txt
	java -jar /storage/java/freej2me-sdl.jar "$1" 128 128 100
	
elif echo $gamedir | grep "176x208" > /dev/null
then
	# echo "128*128" >>0.txt
	java -jar /storage/java/freej2me-sdl.jar "$1" 176 208 100

elif echo $gamedir | grep "176x220" > /dev/null
then
	# echo "128*128" >>0.txt
	java -jar /storage/java/freej2me-sdl.jar "$1" 176 220 100

elif echo $gamedir | grep "360x640" > /dev/null
then
	# echo "128*128" >>0.txt
	java -jar /storage/java/freej2me-sdl.jar "$1" 360 640 100

elif echo $gamedir | grep "640x360" > /dev/null
then
	# echo "640*360" >>0.txt
	java -jar /storage/java/freej2me-sdl.jar "$1" 640 360 100

else
	echo "none"
	java -jar /storage/java/freej2me-sdl.jar "$1" 240 320 100
fi
