### 1. Device Tree Configuration

```c
&eqos {
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_eqos>;
	phy-mode = "rgmii-id";
	phy-handle = <&ethphy1>;
	// snps,reset-gpios = <&pca9535 12 GPIO_ACTIVE_LOW>;
	// snps,reset-delays-us = <10 20 200000>;
	//pinctrl-assert-gpios = <&pca9535 12 GPIO_ACTIVE_LOW>;
	status = "okay";

	mdio {
		compatible = "snps,dwmac-mdio";
		#address-cells = <1>;
		#size-cells = <0>;
		clock-frequency = <2500000>;
		reset-delay-us = <10>;
		reset-post-delay-us = <150>;
		reset-gpios = <&pca9535 12 GPIO_ACTIVE_LOW>;
		ethphy1: ethernet-phy@0 {
			compatible = "ethernet-phy-id001c.c916","ethernet-phy-ieee802.3-c22";//need to use RTL8211E Gigabit Ethernet driver
			//compatible = "ethernet-phy-ieee802.3-c22";
			reg = <0>;
			 //phy-id = <0>;
			//  0x001cc916
			eee-broken-1000t;
		};
	};
};



&fec {
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_fec>;
	phy-mode = "rgmii-id";
	phy-handle = <&ethphy2>;
	fsl,magic-packet;
	phy-reset-gpios = <&pca9535 11 GPIO_ACTIVE_LOW>;
        phy-reset-duration = <10>;
        phy-reset-post-delay = <150>;
	status = "okay";

	mdio {
		#address-cells = <1>;
		#size-cells = <0>;
		clock-frequency = <5000000>;

		ethphy2: ethernet-phy@0 {
			compatible =  "ethernet-phy-id001c.c916","ethernet-phy-ieee802.3-c22";//need to use RTL8211E Gigabit Ethernet driver
			reg = <0>;
			eee-broken-1000t;
		};
	};
};

&iomuxc {
	pinctrl_eqos: eqosgrp {
		fsl,pins = <
			MX93_PAD_ENET1_MDC__ENET_QOS_MDC			0x57e
			MX93_PAD_ENET1_MDIO__ENET_QOS_MDIO			0x57e
			MX93_PAD_ENET1_RD0__ENET_QOS_RGMII_RD0			0x57e
			MX93_PAD_ENET1_RD1__ENET_QOS_RGMII_RD1			0x57e
			MX93_PAD_ENET1_RD2__ENET_QOS_RGMII_RD2			0x57e
			MX93_PAD_ENET1_RD3__ENET_QOS_RGMII_RD3			0x57e
			MX93_PAD_ENET1_RXC__CCM_ENET_QOS_CLOCK_GENERATE_RX_CLK	0x58e
			MX93_PAD_ENET1_RX_CTL__ENET_QOS_RGMII_RX_CTL		0x57e
			MX93_PAD_ENET1_TD0__ENET_QOS_RGMII_TD0			0x57e
			MX93_PAD_ENET1_TD1__ENET_QOS_RGMII_TD1			0x57e
			MX93_PAD_ENET1_TD2__ENET_QOS_RGMII_TD2			0x57e
			MX93_PAD_ENET1_TD3__ENET_QOS_RGMII_TD3			0x57e
			MX93_PAD_ENET1_TXC__CCM_ENET_QOS_CLOCK_GENERATE_TX_CLK	0x58e
			MX93_PAD_ENET1_TX_CTL__ENET_QOS_RGMII_TX_CTL		0x57e
		>;
	};

	pinctrl_eqos_sleep: eqossleepgrp {
		fsl,pins = <
			MX93_PAD_ENET1_MDC__GPIO4_IO00				0x31e
			MX93_PAD_ENET1_MDIO__GPIO4_IO01				0x31e
			MX93_PAD_ENET1_RD0__GPIO4_IO10                          0x31e
			MX93_PAD_ENET1_RD1__GPIO4_IO11				0x31e
			MX93_PAD_ENET1_RD2__GPIO4_IO12				0x31e
			MX93_PAD_ENET1_RD3__GPIO4_IO13				0x31e
			MX93_PAD_ENET1_RXC__GPIO4_IO09                          0x31e
			MX93_PAD_ENET1_RX_CTL__GPIO4_IO08			0x31e
			MX93_PAD_ENET1_TD0__GPIO4_IO05                          0x31e
			MX93_PAD_ENET1_TD1__GPIO4_IO04                          0x31e
			MX93_PAD_ENET1_TD2__GPIO4_IO03				0x31e
			MX93_PAD_ENET1_TD3__GPIO4_IO02				0x31e
			MX93_PAD_ENET1_TXC__GPIO4_IO07                          0x31e
			MX93_PAD_ENET1_TX_CTL__GPIO4_IO06                       0x31e
		>;
	};

	pinctrl_fec: fecgrp {
		fsl,pins = <
			MX93_PAD_ENET2_MDC__ENET1_MDC			0x57e
			MX93_PAD_ENET2_MDIO__ENET1_MDIO			0x57e
			MX93_PAD_ENET2_RD0__ENET1_RGMII_RD0		0x57e
			MX93_PAD_ENET2_RD1__ENET1_RGMII_RD1		0x57e
			MX93_PAD_ENET2_RD2__ENET1_RGMII_RD2		0x57e
			MX93_PAD_ENET2_RD3__ENET1_RGMII_RD3		0x57e
			MX93_PAD_ENET2_RXC__ENET1_RGMII_RXC		0x58e
			MX93_PAD_ENET2_RX_CTL__ENET1_RGMII_RX_CTL	0x57e
			MX93_PAD_ENET2_TD0__ENET1_RGMII_TD0		0x57e
			MX93_PAD_ENET2_TD1__ENET1_RGMII_TD1		0x57e
			MX93_PAD_ENET2_TD2__ENET1_RGMII_TD2		0x57e
			MX93_PAD_ENET2_TD3__ENET1_RGMII_TD3		0x57e
			MX93_PAD_ENET2_TXC__ENET1_RGMII_TXC		0x58e
			MX93_PAD_ENET2_TX_CTL__ENET1_RGMII_TX_CTL	0x57e
		>;
	};

	pinctrl_fec_sleep: fecsleepgrp {
		fsl,pins = <
			MX93_PAD_ENET2_MDC__GPIO4_IO14			0x51e
			MX93_PAD_ENET2_MDIO__GPIO4_IO15			0x51e
			MX93_PAD_ENET2_RD0__GPIO4_IO24			0x51e
			MX93_PAD_ENET2_RD1__GPIO4_IO25			0x51e
			MX93_PAD_ENET2_RD2__GPIO4_IO26			0x51e
			MX93_PAD_ENET2_RD3__GPIO4_IO27			0x51e
			MX93_PAD_ENET2_RXC__GPIO4_IO23                  0x51e
			MX93_PAD_ENET2_RX_CTL__GPIO4_IO22		0x51e
			MX93_PAD_ENET2_TD0__GPIO4_IO19			0x51e
			MX93_PAD_ENET2_TD1__GPIO4_IO18			0x51e
			MX93_PAD_ENET2_TD2__GPIO4_IO17			0x51e
			MX93_PAD_ENET2_TD3__GPIO4_IO16			0x51e
			MX93_PAD_ENET2_TXC__GPIO4_IO21                  0x51e
			MX93_PAD_ENET2_TX_CTL__GPIO4_IO20               0x51e
		>;
	};
};
```



### 2. Drivers

✅ (1) EQoS Driver (DesignWare EQOS)

`drivers\net\ethernet\stmicro\stmmac\stmmac_main.c`

✅ (2) FEC Driver (NXP IMX FEC)

`drivers/net/ethernet/freescale/fec_main.c`



**Test 1: Basic Network Test**

(1) Bring up the Ethernet interfaces

```shell
ifconfig eth0 up 
ifconfig eth1 up 
```

(2) Test network connectivity

```shell
ping 8.8.8.8
```



**Test 2: Wake-on-LAN (WOL) — Wake CPU via Network Port**

(1) Enable Wake-on-LAN; if the following flags appear, it means WOL is supported

> 		Supports Wake-on: g
> 		Wake-on: g

```shell
root@DebixSomB:~# ethtool -s eth0 wol g
[  152.276976] stmmac: wakeup enable


root@DebixSomB:~# ethtool eth0
Settings for eth0:
        Supported ports: [ TP    MII ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Half 1000baseT/Full
                                1000baseX/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Half 1000baseT/Full
                                1000baseX/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                             100baseT/Half 100baseT/Full
                                             1000baseT/Full
        Link partner advertised pause frame use: Symmetric
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        master-slave cfg: preferred slave
        master-slave status: slave
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: external
        MDI-X: Unknown
        Supports Wake-on: ug
        Wake-on: g
        Current message level: 0x0000003f (63)
                               drv probe link timer ifdown ifup
        Link detected: yes

```



(2) Check IP and MAC addresses

```shell

root@DebixSomB:~# ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.2.166  netmask 255.255.255.0  broadcast 192.168.2.255
        inet6 fe80::1207:23ff:fe6d:fa06  prefixlen 64  scopeid 0x20<link>
        ether 10:07:23:6d:fa:06  txqueuelen 1000  (Ethernet)
        RX packets 149  bytes 16515 (16.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 62  bytes 7812 (7.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 106


```



(3) Enter suspend mode

```shell
root@imx8mp-debix:~# echo mem > /sys/power/state
[  934.957246] PM: suspend entry (deep)
[  934.961277] Filesystems sync: 0.000 seconds
[  934.966689] Freezing user space processes
[  934.972279] Freezing user space processes completed (elapsed 0.001 seconds)
[  934.979283] OOM killer disabled.
[  934.982518] Freezing remaining freezable tasks
[  934.988208] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
[  934.995631] printk: Suspending console(s) (use no_console_suspend to debug)

```

(4) Send a magic packet from the PC to wake the device

> Note: Ensure that the PC and the Debix board are in the same local area network (LAN).

On the PC:

```shell
ljm@polyhex:~/workstation/lckfb$ wakeonlan -i 192.168.2.166 10:07:23:6d:fa:06
Sending magic packet to 192.168.2.166:9 with 10:07:23:6d:fa:06

```

After sending, the Debix board will wake up automatically:

```shell
root@DebixSomB:~# echo mem > /sys/power/state
[  225.024128] PM: suspend entry (deep)
[  225.035003] Filesystems sync: 0.007 seconds
[  225.046031] Freezing user space processes
[  225.051990] Freezing user space processes completed (elapsed 0.001 seconds)
[  225.058980] OOM killer disabled.
[  225.062223] Freezing remaining freezable tasks
[  225.067933] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
[  225.075330] printk: Suspending console(s) (use no_console_suspend to debug)
[  226.107958] ieee80211 phy0: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[  226.107975] ieee80211 phy0: brcmf_cfg80211_get_tx_power: error (-5)
[  226.689543] fsl-se secure-enclave: Successfully unregistered ele-trng
[  226.692273] PM: suspend devices took 1.608 seconds
[  226.694334] Disabling non-boot CPUs ...
[  226.694992] psci: CPU1 killed (polled 0 ms)
[  226.695941] Enabling non-boot CPUs ...
[  226.696119] Detected VIPT I-cache on CPU1
[  226.696158] GICv3: CPU1: found redistributor 100 region 0:0x0000000048060000
[  226.696190] CPU1: Booted secondary processor 0x0000000100 [0x412fd050]
[  226.696747] CPU1 is up
[  226.701528] fsl-se secure-enclave: Successfully registered ele-trng
[  226.787832] imx-dwmac 428a0000.ethernet eth0: Link is Down
[  226.787886] imx-dwmac 428a0000.ethernet eth0: No Safety Features support found
[  226.787900] imx-dwmac 428a0000.ethernet eth0: IEEE 1588-2008 Advanced Timestamp supported
[  226.788072] debix ens34 phy_id1=0x1c,phy_id2=0xc916
[  226.788301] es8316 1-0010: Unable to sync registers 0x0-0x2. -5
[  226.788491] debix ens33 phy_id1=0x1c,phy_id2=0xc916
[  226.788971] imx-dwmac 428a0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
[  226.962711] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43455-sdio for chip BCM4345/6
[  226.962816] brcmfmac mmc2:0001:1: Direct firmware load for brcm/brcmfmac43455-sdio.fsl,imx93-11x11-evk.bin failed with error -2
[  226.962828] brcmfmac mmc2:0001:1: Falling back to sysfs fallback for: brcm/brcmfmac43455-sdio.fsl,imx93-11x11-evk.bin
[  226.963564] PM: resume devices took 0.264 seconds
[  227.110902] OOM killer enabled.
[  227.114043] Restarting tasks ... done.
[  227.131027] random: crng reseeded on system resumption
[  227.145482] PM: suspend exit
[  227.145526] es8316 hp_jack_event hp out
root@DebixSomB:~# [  227.264190] brcmfmac: brcmf_c_process_txcap_blob: no txcap_blob available (err=-2)
[  227.272110] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4345/6 wl0: Feb 29 2024 23:48:32 version 7.45.274.1 (2b2667d CY) FWID 01-c411401c


```

