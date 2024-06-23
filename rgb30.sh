#! /bin/bash
filename=$1
source_img_name=${filename%.*}
#source_img_file="${source_img_name}.img.gz"
#target_img_name="JELOS-RGB30.aarch64-20240314-MOU"
mount_point="target"
common_files="common-files"
system_root="SYSTEM-root"
systemd_path="${system_root}/usr/lib/systemd/system"
config_path="${system_root}/usr/config"
modules_load_path="${system_root}/usr/lib/modules-load.d"

if [ -z "$1" ]  
then  
    echo "Should run with img as: sudo ./jelos.sh xxx.img"
    exit 1
fi

# Check if root
if [ "$UID" -ne 0 ]; then
    echo "The script should be run with sudo!!!" >&2
    exit 1
fi

echo "Welcome to build Jelos for RGB30!"

echo "Creating mount point"
mkdir ${mount_point}
echo "Mounting Jelos boot partition"
loop_device=$(losetup -f)
losetup -P $loop_device $1
mount ${loop_device}p3 ${mount_point}

echo "Decompressing SYSTEM image"
rm -rf ${system_root}
unsquashfs -d ${system_root} ${mount_point}/SYSTEM

# Add roms partition
echo "Update fs-resze file"
sudo cp -f ${common_files}/fs-resize_jelos ${system_root}/usr/lib/jelos/fs-resize 


sudo cp -f ${common_files}/010-autorun ${system_root}/usr/lib/autostart/cbepx/
sudo cp -f ${common_files}/007-rootpw ${system_root}/usr/lib/autostart/common/

echo "Support openborff"
cp -f ${common_files}/openbor/OpenBOR_ff  ${system_root}/usr/bin/
chmod 775 ${system_root}/usr/bin/OpenBOR_ff
cp -f ${common_files}/openbor/start_OpenBOR.sh  ${system_root}/usr/bin/
chmod 775 ${system_root}/usr/bin/start_OpenBOR.sh
cp -f ${common_files}/openbor/master*  ${system_root}/usr/config/openbor/

echo "Optimize system startup"
cp -f ${common_files}/automount ${system_root}/usr/bin/
chmod 775 ${system_root}/usr/bin/automount

echo "Fix pico8"
cp -f ${common_files}/start_pico8.sh ${system_root}/usr/bin/
chmod 775 ${system_root}/usr/bin/start_pico8.sh

echo "Update smb.conf"
cp -f ${common_files}/smb.conf ${system_root}/usr/config/

echo "Fix flycast"
cp -f ${common_files}/flycast ${system_root}/usr/bin/
chmod 775 ${system_root}/usr/bin/flycast
cp -f ${common_files}/start_flycast.sh ${system_root}/usr/bin/
chmod 775 ${system_root}/usr/bin/start_flycast.sh

echo "fix bluetooth"
cp -f ${common_files}/bt/hciattach-realtek.service ${system_root}/usr/lib/systemd/system/
chmod 775 ${system_root}/usr/lib/systemd/system/hciattach-realtek.service
ln -s ../hciattach-realtek.service ${system_root}/usr/lib/systemd/system/multi-user.target.wants/hciattach-realtek.service
cp -f ${common_files}/bt/rtk_hciattach ${system_root}/usr/bin/rtk_hciattach
chmod 775 ${system_root}/usr/bin/rtk_hciattach
cp -f ${common_files}/bt/rtl8821c_* ${system_root}/usr/lib/kernel-overlays/base/lib/firmware/
cp -f ${common_files}/bt/rtl8723d* ${system_root}/usr/lib/kernel-overlays/base/lib/firmware/

rm -rf ${system_root}/usr/lib/systemd/system/bluetoothsense.service
cp -f ${common_files}/batocera-bluetooth ${system_root}/usr/bin/batocera-bluetooth
chmod 775 ${system_root}/usr/bin/batocera-bluetooth
cp -f ${common_files}/jelos-bluetooth ${system_root}/usr/bin/jelos-bluetooth
chmod 775 ${system_root}/usr/bin/jelos-bluetooth
cp -f ${common_files}/bluetoothctl ${system_root}/usr/bin/
chmod 775 ${system_root}/usr/bin/bluetoothctl
cp -f ${common_files}/bt.sh ${system_root}/usr/bin/
chmod 775 ${system_root}/usr/bin/bt.sh

echo "revert kernel"
cp -rf ${common_files}/8821cs.ko ${system_root}/usr/lib/kernel-overlays/base/lib/modules/4.19.172/kernel/drivers/net/wireless/rockchip_wlan/rtl8821cs/8821cs.ko


echo "Update j2me files"
cp -f ${common_files}/freej2me-sdl.jar ${system_root}/usr/config/game/freej2me/freej2me-sdl.jar
cp -rf ${common_files}/java ${system_root}/usr/config/game/
cp -f ${common_files}/freej2me-linux-aarch64.jar ${system_root}/usr/config/game/freej2me/freej2me-linux-aarch64.jar
cp -f ${common_files}/runemu.sh ${system_root}/usr/bin/runemu.sh
chmod 775 ${system_root}/usr/bin/runemu.sh
cp -f ${common_files}/sdl_interface ${system_root}/usr/bin/sdl_interface
chmod 775 ${system_root}/usr/bin/sdl_interface
cp -f ${common_files}/start_freej2me.sh ${system_root}/usr/bin/start_freej2me.sh
chmod 775 ${system_root}/usr/bin/start_freej2me.sh
cp -f ${common_files}/freej2me.sh ${system_root}/usr/bin/freej2me.sh
chmod 775 ${system_root}/usr/bin/freej2me.sh
cp -f ${common_files}/es_systems.cfg ${system_root}/usr/config/emulationstation/

echo "Update nds files"
cp -rf ${common_files}/bg ${system_root}/usr/config/drastic/
mkdir -p ${system_root}/usr/config/drastic/lib/
cp -f ${common_files}/libSDL2-2.0.so.0 ${system_root}/usr/config/drastic/lib/
chmod 775 ${system_root}/usr/config/drastic/lib/libSDL2-2.0.so.0
cp -f ${common_files}/drastic ${system_root}/usr/config/drastic/
chmod 775 ${system_root}/usr/config/drastic/
cp -f ${common_files}/start_drastic.sh ${system_root}/usr/bin/start_drastic.sh
chmod 775 ${system_root}/usr/bin/start_drastic.sh

echo "Update RA core file"
cp ${common_files}/fbneo_libretro.so ${system_root}/usr/lib/libretro/
chmod 775 ${system_root}/usr/lib/libretro/fbneo_libretro.so
cp ${common_files}/multiemu_libretro.so ${system_root}/usr/lib/libretro/
chmod 775 ${system_root}/usr/lib/libretro/multiemu_libretro.so
cp ${common_files}/pcsx_rearmed_rumble_32b_libretro.* ${system_root}/usr/lib/libretro/
chmod 775 ${system_root}/usr/lib/libretro/pcsx_rearmed_rumble_32b_libretro.so
cp ${common_files}/mamearcade_libretro.so ${system_root}/usr/lib/libretro/
chmod 775 ${system_root}/usr/lib/libretro/mamearcade_libretro.so
cp ${common_files}/gam4980_32b_libretro* ${system_root}/usr/lib/libretro/
chmod 775 ${system_root}/usr/lib/libretro/gam4980_32b_libretro.so
cp ${common_files}/onscripter_libretro.so ${system_root}/usr/lib/libretro/onscripter_32b_libretro.so

echo "Update bezels.sh"
cp -f ${common_files}/bezels.sh ${system_root}/usr/bin/
chmod 775 ${system_root}/usr/bin/bezels.sh

echo "Fix mplayer"
cp -f ${common_files}/start_mplayer.sh ${system_root}/usr/bin/start_mplayer.sh
chmod 775 ${system_root}/usr/bin/start_mplayer.sh

echo "Update issue file" 
cp ${common_files}/issue ${system_root}/etc/

echo "Compressing SYSTEM image"
mksquashfs ${system_root} SYSTEM -comp gzip -b 524288
rm ${mount_point}/SYSTEM
mv SYSTEM ${mount_point}/SYSTEM

if [[ $1 == *"v2"* ]]; then
	echo "update v2"
	cp ${common_files}/rk3566-rgb30-v2-linux.dtb ${mount_point}/rk3566-rgb30-linux.dtb
fi

#tempcode, used to generate the img for update.pmf only
#rm -rf ${mount_point}/update

sync

echo "Unmounting Jelos data partition"
umount ${loop_device}p3
losetup -d ${loop_device}

rm -rf ${system_root}
rm -rf ${mount_point}

#cp -f ${source_img_name}.img /media/sf_E_DRIVE/${target_img_name}.img
#mv $1  ${target_img_name}.img
