Debix SOM B-OTA Upgrade-swupdate

### Summary of A/B Partition Upgrade Steps:

```
1. Add swupdate to the Yocto project
cd sources
git clone https://github.com/sbabic/meta-swupdate.git

2. Add meta-swupdate-debix to the Yocto project
cp -ar meta-swupdate-debix sources

3. Add compilation settings in sources/meta-imx/tools/imx-setup-release.sh
+echo "BBLAYERS += \"\${BSPDIR}/sources/meta-swupdate\"" >> $BUILD_DIR/conf/bblayers.conf
+echo "BBLAYERS += \"\${BSPDIR}/sources/meta-swupdate-imx\"" >> $BUILD_DIR/conf/bblayers.conf  
+echo "IMAGE_INSTALL:append = \" lua swupdate swupdate-www swupdate-progress swupdate-client swupdate-tools-ipc u-boot-imx u-boot-fw-utils systemd-swusys json-c\"" >> conf/local.conf
+echo "IMAGE_FSTYPES = \" ext4 ext4.gz wic.bmap wic.gz\"" >> conf/local.conf   

4. Compile
bitbake swupdate-image ---This command builds the minimal root filesystem `swupdate-image-imx93evk.rootfs.cpio.gz.u-boot` containing swupdate, used as a recovery system.
bitbake core-image-base--- This one builds the full system. 

5. Add swupdate-scripts to /sources
 git clone https://github.com/NXP/swupdate-scripts.git
 
6. Generate Keys
openssl genrsa -aes256 -out priv.pem
openssl rsa -in priv.pem -out swu_public.pem -outform PEM -pubout
Put the keys in the correspinding locations：
swu_public.pem --->	sources\meta-swupdate-debix\recipes-support\swupdate\swupdate\swu_public.pem
priv.pem  ---->	sources\swupdate-scripts\update_image_build\priv.pem

7. Create base image
Execute the following in /sources/swupdate-scripts/base_image_assembling:
rm slota slotb
ln -s ../../../SOM_B/tmp/deploy/images/imx93evk/ slota
ln -s ../../../SOM_B/tmp/deploy/images/imx93evk/ slotb

Modify the image sizes in sources\swupdate-scripts\boards\cfg_imx93_base_doualcopy.cfg
cp cfg_imx93_base_doualcopy.cfg cfg_imx93_base.cfg

./assemble_base_image.sh -d -b imx93  
    (-d means enable double slot copy)
    (-e means enable emmc. Default is sd)
    This will generate swu_doublecopy_rescue_imx93_sd_20250928.sdcard, which is used to flash to an SD card.

8. Create swu image
 Modify some variables in sources\swupdate-scripts\boards\cfg_imx93_update_image_doualcopy.cfg, such as root filesystem size.
 cp cfg_imx93_update_image_doualcopy.cfg cfg_imx93_update_image.cfg
 
 Modify sw-description-imx93-sd-dualcopy-image.template, such as `bootenv`, and the device section under `images` to indicate whether to upgrade to slotA or slotB.
 cd sources/swupdate-scripts/update_image_build
 rm slot_update
 ln -s ../../../SOM_B/tmp/deploy/images/imx93evk/ ./slot_update
 ./swu_update_image_build.sh -d  -s ./priv.pem -b imx93 -g
     (-d means enable double slot copy)
     (-e means enable emmc. Default is sd)
This generates imx93_1.0_LF_v6.1.36_2.1.0_doublecopy_sd_image_20250928_sign.swu, which is used for upgrading.

9. Check the development board's IP address, then enter it in the browser:
	Example: 192.168.2.120:8080

10. Upgrade
Drag imx93_1.0_LF_v6.1.36_2.1.0_doublecopy_sd_image_20250928_sign.swu into the browser.


Notes:
1. If using an SD card, modify:
root@DebixSomB:/# cat /etc/fw_env.config
/dev/mmcblk1 0x700000 0x4000
/dev/mmcblk1 0x704000 0x4000

2. A watchdog is required to ensure that if the system loses power during the upgrade process and the upgrade fails, the system can reboot. This allows bootcount to be updated properly.
When bootcount > bootlimit, it will trigger altbootcmd, and altbootcmd will check:
    (singelcopy)If the current bootslot is `singlenormal` or `singlerescue`, it runs `altbootsingle`, which then runs `swuboot`.
    (dualcopy)If the current bootslot is `dualA` or `dualB`, it runs `altbootdual`, which then performs a rollback.

You must ensure `upgrade_available=1` so that changes to `bootcount` are saved and take effect（sources\meta-swupdate-debix\recipes-core\systemd\systemd-swusys\clrupstatus.service）
If "upgrade_available" is 0, "bootcount" is not saved.
If "upgrade_available" is 1, "bootcount" is saved.

```

