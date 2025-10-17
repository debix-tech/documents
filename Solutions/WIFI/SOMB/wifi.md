### SOMB+K019



1. Device Tree Configuration

1.1 Configure SDIO

```
&usdhc3 {
	pinctrl-names = "default", "state_100mhz", "state_200mhz";
	pinctrl-0 = <&pinctrl_usdhc3>, <&pinctrl_usdhc3_wlan>;
	pinctrl-1 = <&pinctrl_usdhc3_100mhz>, <&pinctrl_usdhc3_wlan>;//need to use 100mhz or 200mhz,when meet error -110 whilst initialising SDIO card
	pinctrl-2 = <&pinctrl_usdhc3_200mhz>, <&pinctrl_usdhc3_wlan>;
	mmc-pwrseq = <&usdhc3_pwrseq>;
	//pinctrl-assert-gpios = <&pcal6524 13 GPIO_ACTIVE_HIGH>;
	bus-width = <4>;
	pm-ignore-notify;
	keep-power-in-suspend;
	non-removable;
	//cap-power-off-card;
	/delete-property/ vmmc-supply;
	status = "okay";
	    wakeup-source;
    wifi-host;
	//clock-frequency = <50000000>;
	//clock-frequency = <50000000>;

#if 0
	wifi_wake_host {
		compatible = "nxp,wifi-wake-host";
		interrupt-parent = <&gpio2>;
		interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
		interrupt-names = "host-wake";
	};
#else
	brcmf: brcmf@1 {
		ret = <1>;
		compatible = "brcm,bcm4329-fmac";
		interrupt-parent = <&gpio2>;
		interrupts = <9 IRQ_TYPE_LEVEL_HIGH>;
		interrupt-names = "host-wake";
	};
#endif
};

//Add wifi reg_on pin
	usdhc3_pwrseq: usdhc3_pwrseq {
		compatible = "mmc-pwrseq-simple";
		pinctrl-names = "default";
    	//	pinctrl-0 = <&pinctrl_wlan_reg_on>;
		//post-power-on-delay-ms = <500>;
		reset-gpios = <&pca9535 0 GPIO_ACTIVE_LOW>;
	};
```



1.2 Configure Related Pins

```
	/* need to config the SION for data and cmd pad, refer to ERR052021 */
	pinctrl_usdhc3_100mhz: usdhc3-100mhzgrp {
		fsl,pins = <
			MX93_PAD_SD3_CLK__USDHC3_CLK		0x158e
			MX93_PAD_SD3_CMD__USDHC3_CMD		0x4000138e
			MX93_PAD_SD3_DATA0__USDHC3_DATA0	0x4000138e
			MX93_PAD_SD3_DATA1__USDHC3_DATA1	0x4000138e
			MX93_PAD_SD3_DATA2__USDHC3_DATA2	0x4000138e
			MX93_PAD_SD3_DATA3__USDHC3_DATA3	0x4000138e
		>;
	};

	/* need to config the SION for data and cmd pad, refer to ERR052021 */
	pinctrl_usdhc3_200mhz: usdhc3-200mhzgrp {
		fsl,pins = <
			MX93_PAD_SD3_CLK__USDHC3_CLK		0x15fe
			MX93_PAD_SD3_CMD__USDHC3_CMD		0x400013fe
			MX93_PAD_SD3_DATA0__USDHC3_DATA0	0x400013fe
			MX93_PAD_SD3_DATA1__USDHC3_DATA1	0x400013fe
			MX93_PAD_SD3_DATA2__USDHC3_DATA2	0x400013fe
			MX93_PAD_SD3_DATA3__USDHC3_DATA3	0x400013fe
		>;
	};

	pinctrl_usdhc3_sleep: usdhc3grpsleep {
		fsl,pins = <
			MX93_PAD_SD3_CLK__GPIO3_IO20		0x31e
			MX93_PAD_SD3_CMD__GPIO3_IO21		0x31e
			MX93_PAD_SD3_DATA0__GPIO3_IO22		0x31e
			MX93_PAD_SD3_DATA1__GPIO3_IO23		0x31e
			MX93_PAD_SD3_DATA2__GPIO3_IO24		0x31e
			MX93_PAD_SD3_DATA3__GPIO3_IO25		0x31e
		>;
	};
	
//Add wifi-wake-host pin
	pinctrl_usdhc3_wlan: usdhc3wlangrp {
		fsl,pins = <
			MX93_PAD_GPIO_IO09__GPIO2_IO09 0x31e
		>;
	}; 
```



2. Driver Configuration

```
## debix add for wifi
CONFIG_BRCMUTIL=y
CONFIG_BRCMFMAC=m
CONFIG_BRCMFMAC_PROTO_BCDC=y
CONFIG_BRCMFMAC_SDIO=y
```



3. Verify Firmware Placement<br>
Check that firmware files are located in `/lib/firmware/brcm/`



4. Connect to wifi

```
ifconfig wlan0 up
```

If the following error occurs, it's due to RF-kill:

```
ifconfig wlan0 up SIOCSIFFLAGS: Operation not possible due to RF-kill
```

Run:

```
rfkill list
rfkill unblock all
```

Then connect and obtain an IP address:

```
ifconfig wlan0 up
wpa_passphrase BH123 1234567890 >> /etc/wpa_supplicant.conf
wpa_supplicant -Dnl80211 -iwlan0 -c/etc/wpa_supplicant.conf -t &
udhcpc -iwlan0 q

```


<br>






**WI-FI as AP Mode (Sharing Ethernet Network)**

1. ifconfig wlan0 192.168.2.1 netmask 255.255.255.0 up

2. hostapd -B hostapd.conf

```
interface=wlan0
driver=nl80211
ctrl_interface=/var/run/hostapd
ssid=MyAP
channel=3
ieee80211n=1
hw_mode=g
ignore_broadcast_ssid=0

```

3. touch /etc/udhcpd.leases

4. udhcpd -fS udhcpd.conf &

```
start 192.168.2.166
end 192.168.2.180
interface wlan0
max_leases 20
remaining yes
auto_time 7200
decline_time 3600
conflict_time 3600
offer_time 60
min_lease 60
lease_file /etc/udhcpd.leases
opt dns 114.114.114.114 #192.168.1.2 192.168.1.10 
option subnet 255.255.255.0 
opt router 192.168.2.166

```

5. Enable network traffic forwarding

```
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
echo 1 > /proc/sys/net/ipv4/ip_forward
```

6. Connect your phone to the “MyAP” Wi-Fi network, and it should work properly.