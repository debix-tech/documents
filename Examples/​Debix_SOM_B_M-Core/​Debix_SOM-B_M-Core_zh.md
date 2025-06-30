somB上面使用M核

M33 核的两种工程调试开发，

第一种方式是通过板子自带的固件进行开发，

第二种方式是使用 IAR Embedded Workbench 来构建可移植的 Freertos 文件进行开发



✅ A. 使用板载固件调试（方式一）

📦 1. 加载官方 M33 固件：

在`/lib/firmware/`路径下提供了5个M核开发的固件，可以直接用来验证

```shell
echo /lib/firmware/imx93-11x11-evk_m33_TCM_rpmsg_lite_str_echo_rtos.elf  > /sys/class/remoteproc/remoteproc0/firmware
```

🚀 2. 启动 M33 核处理器

```shell
root@DebixSomB:/sys/class/remoteproc/remoteproc0# echo start > state
....
[68352.323252] remoteproc remoteproc0: remote processor imx-rproc is now up
```

此时还不能发送字符，还需要将驱动装好命令如下：

🔌 3. 加载 RPMsg 通信驱动

```shell
modprobe imx_rpmsg_tty
```

此时就能看到目录/dev 下多了一个 `ttyRPMSG30`

💬 4. 通过 A 核向 M33 核发送数据

```shell
echo 1234 > /dev/ttyRPMSG30
```

⚠️ 注意事项：避免串口冲突

如果 **M33 使用了 UART2**，你需要从 A 核设备树中禁用对应串口，否则双方会冲突！

```c
diff --git a/arch/arm64/boot/dts/freescale/imx93-debix-SOMB.dts b/arch/arm64/boot/dts/freescale/imx93-debix-SOMB.dts
index 903e06e75..a9cc27659 100755
--- a/arch/arm64/boot/dts/freescale/imx93-debix-SOMB.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-debix-SOMB.dts
@@ -936,11 +936,11 @@ &lpuart1 { /* console */
 };
 
 //Add J36
-&lpuart2 {
-       pinctrl-names = "default";
-       pinctrl-0 = <&pinctrl_uart2>;
-       status = "okay";
-};
+// &lpuart2 {
+//     pinctrl-names = "default";
+//     pinctrl-0 = <&pinctrl_uart2>;
+//     status = "okay";
+// };
 
 //BT
 &lpuart5 {
@@ -1203,12 +1203,12 @@ MX93_PAD_CCM_CLKO3__GPIO4_IO28  0x31e
 
 
 //Add J36 UART
-       pinctrl_uart2: uart2grp {
-               fsl,pins = <
-                       MX93_PAD_UART2_RXD__LPUART2_RX             0x31e
-                       MX93_PAD_UART2_TXD__LPUART2_TX             0x31e
-               >;
-       };
+       // pinctrl_uart2: uart2grp {
+       //      fsl,pins = <
+       //              MX93_PAD_UART2_RXD__LPUART2_RX             0x31e
+       //              MX93_PAD_UART2_TXD__LPUART2_TX             0x31e
+       //      >;
+       // };

```

