### SOMB+Camera+GC2145

Refer to imx93-debix-SOMB-TD101A200A.dts device tree.



1. Configure GC2145

```
&lpi2c1 {
	gc2145_0: gc2145_mipi@3c {
		compatible = "galaxycore,gc2145";
		reg = <0x3c>;
		pinctrl-names = "default";
		//pinctrl-0 = <&pinctrl_csi0_pwn>, <&pinctrl_csi0_rst>, <&pinctrl_csi0_mclk>;
		//pinctrl-0 = <&pinctrl_csi0_mclk>;
		clocks = <&clk IMX93_CLK_24M>;
		clock-names = "xclk";
		assigned-clocks = <&clk IMX93_CLK_CCM_CKO3>;
		assigned-clock-parents = <&clk IMX93_CLK_24M>;
		assigned-clock-rates = <24000000>;
		csi_id = <0>;
		powerdown-gpios = <&pca9535 3 GPIO_ACTIVE_HIGH>;
		reset-gpios = <&pca9535_1 15 GPIO_ACTIVE_LOW>;
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
};


```

2. Configure CSI

```
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

```

3. Configure ISI

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



4. Debug Methods

List all enumerated devices:

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

media-ctl -d /dev/media0 --set-v4l2 '"gc2145 0-003c":0[fmt:UYVY8_1X16/1280x720 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:full-range]'

media-ctl -d /dev/media0 --set-v4l2 '"mxc_isi.0":0[fmt:UYVY8_1X16/1280x720 field:none colorspace:jpeg xfer:srgb ycbcr:601 quantization:full-range]'

media-ctl -d /dev/media0 --set-v4l2 '"crossbar":0[fmt:UYVY8_1X16/1280x720 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]'

media-ctl -d /dev/media0 --set-v4l2 '"csidev-4ae00000.csi":0[fmt:UYVY8_1X16/1280x720 field:none colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]'
```

Preview:

```
gst-launch-1.0 v4l2src device=/dev/video0 io-mode=4 ! video/x-raw, format=YUY2, width=1280,height=720,framerate=30/1 ! autovideosink
```

Capture a photo:

```
gst-launch-1.0 v4l2src device=/dev/video0 num-buffers=1 ! video/x-raw, format=YUY2, width=1280, height=720 ! videoconvert ! pngenc ! filesink location=photo.png
```

