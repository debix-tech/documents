FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

FILES:${PN} += "/etc/*"
SRC_URI += " file://0009-imx93-enable-env_redunand-bootcount-limit-lf-6.12.3.patch "

SWU_HW_REV ?= "1.0"

do_install:append:mx93-nxp-bsp () {

    echo "/dev/mmcblk0 0x700000 0x4000" > ${D}/${sysconfdir}/fw_env.config
    echo "/dev/mmcblk0 0x704000 0x4000" >> ${D}/${sysconfdir}/fw_env.config
    echo "${MACHINE} ${SWU_HW_REV}" > ${D}/${sysconfdir}/hwrevision
    install -D -m 644  ${D}/${sysconfdir}/fw_env.config  ${DEPLOYDIR}
    install -D -m 644  ${D}/${sysconfdir}/hwrevision  ${DEPLOYDIR}

}

do_install:append:mx8qxp-nxp-bsp () {

    echo "/dev/mmcblk1 0x700000 0x2000" > ${D}/${sysconfdir}/fw_env.config
    echo "/dev/mmcblk1 0x702000 0x2000" >> ${D}/${sysconfdir}/fw_env.config
    echo "${MACHINE} ${SWU_HW_REV}" > ${D}/${sysconfdir}/hwrevision
    install -D -m 644  ${D}/${sysconfdir}/fw_env.config  ${DEPLOYDIR}
    install -D -m 644  ${D}/${sysconfdir}/hwrevision  ${DEPLOYDIR}

}

do_install:append:mx8mm-nxp-bsp () {

    echo "/dev/mmcblk1 0x700000 0x4000" > ${D}/${sysconfdir}/fw_env.config
    echo "/dev/mmcblk1 0x704000 0x4000" >> ${D}/${sysconfdir}/fw_env.config
    echo "${MACHINE} ${SWU_HW_REV}" > ${D}/${sysconfdir}/hwrevision
    install -D -m 644  ${D}/${sysconfdir}/fw_env.config  ${DEPLOYDIR}
    install -D -m 644  ${D}/${sysconfdir}/hwrevision  ${DEPLOYDIR}

}

do_install:append:mx6ull-nxp-bsp () {

    echo "/dev/mmcblk1 0xE0000 0x2000" > ${D}/${sysconfdir}/fw_env.config
    echo "/dev/mmcblk1 0xE2000 0x2000" >> ${D}/${sysconfdir}/fw_env.config
    echo "${MACHINE} ${SWU_HW_REV}" > ${D}/${sysconfdir}/hwrevision
    install -D -m 644  ${D}/${sysconfdir}/fw_env.config  ${DEPLOYDIR}
    install -D -m 644  ${D}/${sysconfdir}/hwrevision  ${DEPLOYDIR}
}
