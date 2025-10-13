### SOMB+MIPI+TD080B Display



1. Configure Backlight

Here we take TPM6 as an example:

```
/ {
	backlight: backlight {
		compatible = "pwm-backlight";
                //pinctrl-names = "default";
		//pinctrl-0 = <&pinctrl_pwm>;
		pwms = <&tpm6 0 100000 0>;
		//enable-gpios = <&gpio2 20 GPIO_ACTIVE_HIGH>;
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
	
&tpm6 {
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_pwm6>;
	status = "okay";
};
```



```
&iomuxc {
	pinctrl_pwm6: pwm6grp {
		fsl,pins = <
			MX93_PAD_GPIO_IO08__TPM6_CH0 0x39e
			//MX93_PAD_GPIO_IO13__TPM4_CH2 0x39e
		>;
	};
};
```



2. Configure DSI

```
&dphy {
	status = "okay";
};

&dsi {
	#address-cells = <1>;
	#size-cells = <0>;

	status = "okay";
        panel@0 {
                compatible = "debix,TD080B";
                reg = <0>;
                backlight = <&backlight>;
                // pinctrl-0 = <&pinctrl_mipi_dsi_en>;
                reset-gpio = <&pca9535 5 GPIO_ACTIVE_HIGH>;
                dsi-lanes = <4>;
                video-mode = <2>;       /* 0: burst mode
                                         * 1: non-burst mode with sync event
                                         * 2: non-burst mode with sync pulse
                                         */
                panel-width-mm = <107>;
                panel-height-mm = <172>;
                status = "okay";
		port {
			panel_in: endpoint {
				remote-endpoint = <&dsi_out>;
			};
		};
	};

	ports {
		port@1 {
			reg = <1>;

			dsi_out: endpoint {
				remote-endpoint = <&panel_in>;
			};
		};

        };

};
```



**Disable ldb**<br>
Since the SOM-B only supports one display interface at a time, the LVDS interface must be disabled.

```
&ldb {
	status = "disabled";

};

&ldb_phy {
	status = "disabled";
};
```



3. Configure Clock

```
&lcdif {
//mipi = clk /3 
//lvds = clk /7 

	assigned-clock-rates = <300000000>, <74250000>, <400000000>, <133333333>;
	//assigned-clock-rates = <150000000>, <50000000>, <400000000>, <133333333>;
	//assigned-clock-rates = <225000000>, <75000000>, <400000000>, <133333333>;
};

```



4. Debug Methods

Common debugging tools:

```
drmdevice
Modetest — check if the display pipeline (link) is working properly

fbset
cat /sys/kernel/debug/dri/0/state  — check current display state

/sys/class/backlight/lvds_backlight/brightness — control backlight



```

Use modetest to display color bars for testing:

```shell
modetest -M imx-drm -s 36@34:1280x800@XR24 # This command sets color-bar test mode.
systemctl stop weston # If Weston is running, disable it first:
setting mode 1280x800-61.97Hz on connectors 36, crtc 34
```

![image-20250918084201225](./image-20250918084201225.png)

![image-20250918084306127](./image-20250918084306127.png)

