> The SOMB and SOMC modules utilize the identical HYM8563 component. Therefore, the instructions in this section apply to both.


### 1. Device Tree Configuration

Add hym8563 under the lpi2c5 node:

```C
&lpi2c5 {
hym8563: hym8563@51 {
		compatible = "haoyu,hym8563";
		reg = <0x51>;
		#clock-cells = <0>;
		clock-frequency = <32768>;
		clock-output-names = "xin32k";
		init_date="2025/03/27";
		interrupt-parent = <&pca9535>;
		interrupts = <15 IRQ_TYPE_EDGE_FALLING>;
		status = "okay";	
//		pinctrl-names = "default";
//		pinctrl-0 = <&pinctrl_rtc_int>;
	};
};
```



### 2. Driver

Path: `drivers\rtc\rtc-hym8563.c`

Corresponding configuration option: `CONFIG_RTC_DRV_HYM8563`



### 3. Usage

```shell
//Set system time to rtc1
root@DebixSomB:~# hwclock --systohc -f /dev/rtc1

//Read time
root@DebixSomB:~# hwclock -r -f /dev/rtc1
2025-10-24 11:55:30.433473+00:00

```



### 4. Test RTC Wake-up Function

```shell
root@DebixSomB:~# rtcwake -s 60 -m mem -d /dev/rtc1
rtcwake: wakeup from "mem" using /dev/rtc1 at Fri Oct 24 11:59:11 2025
[ 6847.090687] PM: suspend entry (deep)
[ 6847.094389] Filesystems sync: 0.000 seconds
[ 6847.103512] Freezing user space processes
[ 6847.109501] Freezing user space processes completed (elapsed 0.001 seconds)
[ 6847.116513] OOM killer disabled.
[ 6847.119756] Freezing remaining freezable tasks
[ 6847.125439] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
[ 6847.132854] printk: Suspending console(s) (use no_console_suspend to debug)
[ 6848.190570] ieee80211 phy0: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[ 6848.190586] ieee80211 phy0: brcmf_cfg80211_get_tx_power: error (-5)
[ 6848.740526] imx-dwmac 428a0000.ethernet eth0: Link is Down
[ 6848.764144] fsl-se secure-enclave: Successfully unregistered ele-trng
[ 6848.765937] PM: suspend devices took 1.620 seconds
[ 6848.768034] Disabling non-boot CPUs ...
[ 6848.769680] psci: CPU1 killed (polled 0 ms)
[ 6848.770602] Enabling non-boot CPUs ...
[ 6848.770775] Detected VIPT I-cache on CPU1
[ 6848.770812] GICv3: CPU1: found redistributor 100 region 0:0x0000000048060000
[ 6848.770844] CPU1: Booted secondary processor 0x0000000100 [0x412fd050]
[ 6848.771368] CPU1 is up
[ 6848.778840] fsl-se secure-enclave: Successfully registered ele-trng
[ 6848.866450] imx-dwmac 428a0000.ethernet eth0: configuring for phy/rgmii-id link mode
[ 6848.866709] debix ens34 phy_id1=0x1c,phy_id2=0xc916
[ 6848.900470] imx-dwmac 428a0000.ethernet eth0: No Safety Features support found
[ 6848.900488] imx-dwmac 428a0000.ethernet eth0: IEEE 1588-2008 Advanced Timestamp supported
[ 6848.901939] es8316 1-0010: Unable to sync registers 0x0-0x2. -5
[ 6849.065003] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43455-sdio for chip BCM4345/6
[ 6849.065100] brcmfmac mmc2:0001:1: Direct firmware load for brcm/brcmfmac43455-sdio.fsl,imx93-11x11-evk.bin failed with error -2
[ 6849.065110] brcmfmac mmc2:0001:1: Falling back to sysfs fallback for: brcm/brcmfmac43455-sdio.fsl,imx93-11x11-evk.bin
[ 6849.065942] PM: resume devices took 0.288 seconds
[ 6849.208219] OOM killer enabled.
[ 6849.211364] Restarting tasks ... done.
[ 6849.218438] random: crng reseeded on system resumption
[ 6849.229514] es8316 hp_jack_event hp out
[ 6849.233540] PM: suspend exit
root@DebixSomB:~# [ 6849.352136] brcmfmac: brcmf_c_process_txcap_blob: no txcap_blob available (err=-2)
[ 6849.360087] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4345/6 wl0: Feb 29 2024 23:48:32 version 7.45.274.1 (2b2667d CY) FWID 01-c411401c
[ 6851.963938] debix ens33 phy_id1=0x1c,phy_id2=0xc916
[ 6851.969288] imx-dwmac 428a0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx

```

