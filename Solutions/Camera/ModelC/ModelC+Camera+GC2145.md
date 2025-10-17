### ModelC+Camera+GC2145

Refer to the device tree file: imx93-debix-Model_C-TD101A-200A.dts



1. GC2145 Configuration

```
&lpi2c1 {
// Add for ISI and MIPI CSI
		gc2145_0: gc2145_mipi@3c {
		compatible = "galaxycore,gc2145";
		reg = <0x3c>;
		pinctrl-names = "default";
		pinctrl-0 = <&pinctrl_csi0_pwn>, <&pinctrl_csi0_rst>, <&pinctrl_csi0_mclk>;
		//pinctrl-0 = <&pinctrl_csi0_mclk>;
		clocks = <&clk IMX93_CLK_CCM_CKO3>;//Note: this is the clock for mclk
		clock-names = "xclk";
		assigned-clocks = <&clk IMX93_CLK_CCM_CKO3>;
        assigned-clock-parents = <&clk IMX93_CLK_24M>;
        assigned-clock-rates = <24000000>;
		csi_id = <0>;
		// powerdown-gpios = <&pca9535 3 GPIO_ACTIVE_HIGH>;
		// reset-gpios = <&pca9535_1 15 GPIO_ACTIVE_LOW>;
		powerdown-gpios = <&gpio2 18 GPIO_ACTIVE_HIGH>;
		reset-gpios = <&gpio2 16 GPIO_ACTIVE_LOW>;
		//mclk = <24000000>;
		//mclk_source = <0>;
		mipi_csi;
		status = "okay";



		port {
			#address-cells = <1>;
			#size-cells = <0>;

				gc2145_isp_out: endpoint {
					remote-endpoint = <&mipi_csi_in>;
					#if 1
						data-lanes = <1 2>;
					#else
						data-lanes = <1>;
					#endif
						clock-lanes = <0>;
					link-frequencies = /bits/ 64 <120000000 192000000 240000000>;
				};

			// port {
			// 		gc2145_mipi_ep: endpoint {
			// 				remote-endpoint = <&mipi_csi_ep>;
			// 				data-lanes = <1 2>;
			// 				clock-lanes = <0>;
			// 				// link-frequencies = /bits/ 64 <240000000>;
			// 				link-frequencies = /bits/ 64 <120000000 192000000 240000000>;
			// 		};
			//     };
			// };
		};

	};
//End of MIPI CSI


};


```

2. CSI Configuration

```
&dphy_rx {
	status = "okay";
};
&mipi_csi {
	status = "okay";

		ports {
		#address-cells = <1>;
		#size-cells = <0>;

		port@0 {
			reg = <0>;

			mipi_csi_in: endpoint {
				remote-endpoint = <&gc2145_isp_out>;
			#if 1
				data-lanes = <1 2>;
			#else
				data-lanes = <1>;
			#endif
				// clock-lanes = <0>;
			#if 1
				cfg-clk-range = <28>; /*24MHz = 28*/
				hs-clk-range = <0x16>;  
				bus-type = <4>;
			#endif
			};
		};

		port@1 {
			reg = <1>;

			mipi_csi_out: endpoint {
				remote-endpoint = <&isi_in>;
			};
		};
	};

	// port@0 {
	// 	reg = <0>;
	// 	mipi_csi_ep: endpoint {
	// 		remote-endpoint = <&gc2145_mipi_ep>;
	// 		data-lanes = <1>;
	// 		cfg-clk-range = <28>;
	// 		hs-clk-range = <0x2B>;
	// 		bus-type = <1>;
			
	// 	};
	// };
};
//End of MIPI CSI

```

3. ISI Configuration

```
&isi{

	status = "okay";
		port {
		isi_in: endpoint {
			remote-endpoint = <&mipi_csi_out>;
		};
	};

};
```



4. Pin Configuration

```
&iomuxc {
        pinctrl_lvds: lvdsengrp {
        fsl,pins = <
			MX93_PAD_PDM_BIT_STREAM1__GPIO1_IO10 0x31e
                >;
        };
        pinctrl_pwm: pwmgrp {
         fsl,pins = <
			MX93_PAD_GPIO_IO12__GPIO2_IO12	0x31e
			//MX93_PAD_GPIO_IO13__GPIO2_IO13	0x139e
                >;
        };
		pinctrl_pwm4: pwm4grp {
		fsl,pins = <
			MX93_PAD_GPIO_IO13__TPM4_CH2 0x139e
		>;
	};

	//Add for camera 
	pinctrl_csi0_pwn: csi0_pwn_grp {
                fsl,pins = <
                         MX93_PAD_GPIO_IO18__GPIO2_IO18		0x31e
                >;
        };
	pinctrl_csi0_rst: csi0_rst_grp {
                fsl,pins = <
                         MX93_PAD_GPIO_IO16__GPIO2_IO16		0x31e
                >;
        };
	pinctrl_csi0_mclk: csi0_mclk_grp {
                fsl,pins = <
			 MX93_PAD_CCM_CLKO3__CCMSRCGPCMIX_CLKO3  0x31e //need to set to 0x31e pull up 
			// MX93_PAD_CCM_CLKO3__CCMSRCGPCMIX_CLKO3  0x1fe
                >;
        };

};
```



5. Debug Methods

List currently enumerated devices：

```
root@DebixSomB:~# v4l2-ctl --list-devices
mxc-isi-cap (platform:4ae40000.isi):
	/dev/video0
	/dev/video1
	/dev/media0
```

Print media topology:

```
media-ctl -p
```

List supported controls:

```
v4l2-ctl --device=/dev/v4l-subdev1 --list-ctrls
```



Set display parameters:

```
media-ctl -d /dev/media0 -l "'gc2145 0-003c':0 -> 'csidev-4ae00000.csi':0[1]"
media-ctl -d /dev/media0 --set-v4l2 '"gc2145 0-003c":0[fmt:UYVY8_1X16/640x480 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:full-range]'
media-ctl -d /dev/media0 --set-v4l2 '"mxc_isi.0":0[fmt:UYVY8_1X16/640x480 field:none colorspace:jpeg xfer:srgb ycbcr:601 quantization:full-range]'
media-ctl -d /dev/media0 --set-v4l2 '"crossbar":0[fmt:UYVY8_1X16/640x480 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]'
media-ctl -d /dev/media0 --set-v4l2 '"csidev-4ae00000.csi":0[fmt:UYVY8_1X16/640x480 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]'

```

Preview:

```
gst-launch-1.0 v4l2src device=/dev/video0 io-mode=4 ! video/x-raw, format=YUY2, width=640,height=480,framerate=30/1 ! autovideosink
```

