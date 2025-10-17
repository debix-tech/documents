### ModelC+LVDS+TD101A Display



1. Configure Backlight

Here, TPM4 is used as an example:

```
	lvds_backlight: lvds_backlight {
		compatible = "pwm-backlight";
		pinctrl-names = "default";
		pinctrl-0 = <&pinctrl_pwm>;
		pwms = <&tpm4 2 100000 0>;
		enable-gpios = <&gpio2 12 GPIO_ACTIVE_HIGH>;
		//power-supply = <&reg_vdd_12v>;
		status = "okay";

		brightness-levels = < 0  1  2  3  4  5  6  7  8  9
				     10 11 12 13 14 15 16 17 18 19
				     20 21 22 23 24 25 26 27 28 29
				     30 31 32 33 34 35 36 37 38 39
				     40 41 42 43 44 45 46 47 48 49
				     50 51 52 53 54 55 56 57 58 59
				     60 61 62 63 64 65 66 67 68 69
				     70 71 72 73 74 75 76 77 78 79
				     80 81 82 83 84 85 86 87 88 89
				     90 91 92 93 94 95 96 97 98 99
				    100>;
		default-brightness-level = <80>;
	};

	
//Add for TPM4 by debix
&tpm4 {
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_pwm4>;
	status = "okay";
};


```



```
&iomuxc {
        pinctrl_lvds: lvdsengrp {
        fsl,pins = <
			MX93_PAD_PDM_BIT_STREAM1__GPIO1_IO10 0x139e
                >;
        };
        pinctrl_pwm: pwmgrp {
         fsl,pins = <
			MX93_PAD_GPIO_IO12__GPIO2_IO12	0x139e
			//MX93_PAD_GPIO_IO13__GPIO2_IO13	0x139e
                >;
        };
		pinctrl_pwm4: pwm4grp {
		fsl,pins = <
			MX93_PAD_GPIO_IO13__TPM4_CH2 0x39e
		>;
	};

};

```



2. Configure LDB (LVDS Display Bridge)

```
&ldb_phy {
	status = "okay";
};

&ldb {
	status = "okay";

	lvds-channel@0 {
		//fsl,data-mapping = "jeida";
		fsl,data-mapping = "spwg";
		fsl,data-width = <24>;
		status = "okay";

		port@1 {
			reg = <1>;

			lvds_out: endpoint {
				remote-endpoint = <&panel_lvds_in>;
			};
		};
	};
};

	lvds_panel {
		pinctrl-names = "default";
		pinctrl-0 = <&pinctrl_lvds>;
		compatible = "debix,JW101HD_X00";
		//compatible = "debix,HC101IK25050-D59V.C";
        backlight = <&lvds_backlight>;
		enable-gpios = <&gpio1 10 GPIO_ACTIVE_HIGH>;

		port {
			panel_lvds_in: endpoint {
				remote-endpoint = <&lvds_out>;
			};
		};
	};
```



Disable DSI since Model C only supports one display interface at a time:

```
//disable mipi dphy and dsi for lvds panel
&dphy {
	status = "disabled";
};

&dsi {
	status = "disabled";
};

```







3. Configure Clocks

```
//set lcdif status to okay
&lcdif {
	status = "okay";
	// assigned-clock-rates = <498000000>, <75000000>, <400000000>, <133333333>;
	assigned-clock-rates = <460259800>, <65751400>, <400000000>, <133333333>; 
};

```







4. Debug Methods

Common tools for troubleshooting:

```
drmdevice
Modetest   Check display link status

fbset
cat /sys/kernel/debug/dri/0/state  View framebuffer settings

/sys/class/backlight/lvds_backlight/brightness   Control backlight brightness



```

Use modetest to display color bars:

```shell
modetest -M imx-drm -s 36@34:1280x800@XR24   Sets color bar test. If Weston is running, stop it first: systemctl stop weston
setting mode 1280x800-61.97Hz on connectors 36, crtc 34
```

![image-20250918084201225](./image-20250918084201225.png)

![image-20250918084306127](./image-20250918084306127.png)

