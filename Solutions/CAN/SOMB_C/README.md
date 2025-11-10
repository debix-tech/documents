## The configurations for CAN1 and CAN2

### Device Tree Configuration:

```
&flexcan1 {
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_flexcan1>;
//	xceiver-supply = <&reg_can1_stby>;
	status = "okay";
};

&flexcan2 {
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_flexcan2>;
	//xceiver-supply = <&reg_can2_stby>;
	status = "okay";
};


&iomuxc {
//Add CAN 1-2
	pinctrl_flexcan2: flexcan2grp {
		fsl,pins = <
			MX93_PAD_GPIO_IO25__CAN2_TX	0x139e
			MX93_PAD_GPIO_IO27__CAN2_RX	0x139e
		>;
	};


	pinctrl_flexcan1: flexcan1grp {
		fsl,pins = <
			MX93_PAD_PDM_CLK__CAN1_TX	0x139e
			MX93_PAD_PDM_BIT_STREAM0__CAN1_RX	0x139e
		>;
	};	
};

```



**Test Procedure**

1. Hardware Connection:

Connect the two CAN ports together, for example CAN1 and CAN2, then run:

```shell
root@DebixSomB:/# ip link set can0 up type can bitrate 1000000 dbitrate 5000000 fd on
[11072.340539] IPv6: ADDRCONF(NETDEV_CHANGE): can0: link becomes ready
root@DebixSomB:/# ip link set can1 up type can bitrate 1000000 dbitrate 5000000 fd on
[11073.718111] IPv6: ADDRCONF(NETDEV_CHANGE): can1: link becomes ready

```

2. Send and Receive Data – CAN Communication Test：

In Terminal 1, run the listener tool:

```shell
candump -ta can1
```

In Terminal 2, send data:

```shell
cangen can0
```

