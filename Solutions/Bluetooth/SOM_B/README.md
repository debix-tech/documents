Bluetooth

## 1. Device Tree Configuration

```C
//BT
&lpuart5 {
	/* BT */
	pinctrl-names = "default";
	//pinctrl-assert-gpios = <&pcal6524 19 GPIO_ACTIVE_HIGH>;
	assigned-clocks = <&clk IMX93_CLK_LPUART5>;
	//assigned-clock-parents = <&clk IMX93_SYS_PLL1_80M>;
	pinctrl-0 = <&pinctrl_uart5>;
	fsl,uart-has-rtscts;
	status = "okay";

	// bluetooth {
	// 	compatible = "nxp,88w8987-bt";
	// };
};



/{
//Add BT 
	bt_rfkill {
		compatible = "fsl,mxc_bt_rfkill";
		pinctrl-names = "default";
		pinctrl-0 = <&pinctrl_bt_ctrl>;
		bt-power-gpios = <&pca9535 1 GPIO_ACTIVE_LOW>;
		wake-bt-gpios =  <&pca9535 2 GPIO_ACTIVE_LOW>;
		wake-host-gpios = <&gpio2 7 GPIO_ACTIVE_LOW>;
		status ="okay";
	};

};



&iomuxc {
//Add for BT
	pinctrl_uart5: uart5grp {
		fsl,pins = <
			MX93_PAD_GPIO_IO00__LPUART5_TX		0x31e
			MX93_PAD_GPIO_IO01__LPUART5_RX		0x31e
			MX93_PAD_GPIO_IO03__LPUART5_RTS_B	0x31e
			MX93_PAD_GPIO_IO02__LPUART5_CTS_B	0x31e
		>;
	};
	
	
	//Add BT ctrl pin
	pinctrl_bt_ctrl: bt_ctrl {
		fsl,pins = <
			MX93_PAD_GPIO_IO07__GPIO2_IO07        0x31e
		>;
	};
	
};
```



## 2. Driver and Firmware

Driver Reference: `drivers\bluetooth\mx8_bt_rfkill.c`

Firmware Location: `/lib/firmware/brcm/`

```
brcmfmac43455-sdio.bin
brcmfmac43455-sdio.txt
BCM4345C5.hcd
```



## 3. Sending Files

Before using Bluetooth, you need to load the firmware and bring up Bluetooth:

```shell
hciattach /dev/ttyLP4 bcm43xx 3000000 flow -t 20
rfkill unblock bluetooth
hciconfig hci0 up
hciconfig 
```

Then you can send files as follows:

```
1. Pair Bluetooth:
bluetoothctl
power on
scan on 
discoverable on           //Enable discoverable mode
pair 14:99:3E:62:83:9F
exit
2. Send files using obexctl:
ps -ef | grep obexd
If no related process is found, run:
/usr/libexec/bluetooth/obexd -n &

obexctl
connect 14:99:3E:62:83:9F
send 111.txt
Then confirm the file transfer on your phone.
```





## 4. Receiving Files

```
1. Pair Bluetooth:
bluetoothctl
power on
scan on 
pair 14:99:3E:62:83:9F
exit

2. Start file receiving service:
killall obexd
/usr/libexec/bluetooth/obexd -n -r /home/root/Downloads -a &
The received files will be saved in /home/root/Downloads

3. Send a file from the phone.
```





## 5. Bluetooth Audio

A2DP stands for Advanced Audio Distribution Profile

```shell
1. Connect Bluetooth headset:
bluetoothctl
power on
scan on 
pair 14:99:3E:62:83:9F
connect xxx
trust xxx
exit

2. Check and configure:
root@DebixSomB:/boot# pw-cli ls Node
        id 30, type PipeWire:Interface:Node/3
                object.serial = "30"
  
        id 52, type PipeWire:Interface:Node/3
                object.serial = "52"
                object.path = "alsa:acp:es8316audio:2:capture"
                factory.id = "19"
                client.id = "47"
                device.id = "48"
                priority.session = "2000"
                priority.driver = "2000"
                node.description = "Built-in Audio Stereo"
                node.name = "alsa_input.platform-sound-es8316.stereo-fallback"
                node.nick = "HiFi ES8316 HiFi-0"
                media.class = "Audio/Source"
        id 56, type PipeWire:Interface:Node/3
                object.serial = "58"
                factory.id = "12"
                client.id = "47"
                device.id = "55"
                priority.session = "1010"
                priority.driver = "1010"
                node.description = "TWS"
                node.name = "bluez_output.50_D9_7E_12_39_61.1"
                media.class = "Audio/Sink"

pw-cli set-default 56  //Set PipeWire’s default audio output (sink) to node ID 56

pw-metadata -n settings 0 default.audio.sink bluez_output.50_D9_7E_12_39_61.1
//Check the current default output using pw-metadata

3. Playback examples:
pw-play sample-12s.wav ---Play a .wav file

gst-launch-1.0 filesrc location=/boot/SampleVideo_1280x720_30mb.mp4 ! decodebin name=dec dec. ! queue ! autovideosink dec. ! queue ! audioconvert ! audioresample ! pulsesink  --Play a local MP4 video

gst-launch-1.0 souphttpsrc location=https://gstreamer.freedesktop.org/data/media/sintel_trailer-480p.webm ! decodebin name=dec dec. ! queue ! autovideosink dec. ! queue ! audioconvert ! audioresample ! pulsesink  --Play an online video
```

