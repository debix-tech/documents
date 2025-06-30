🔄 将 DEBIX Model C 的 UART Debug 口改为普通 UART 使用

本教程指导你如何关闭默认的串口调试功能（Console），将 UART（如 LPUART1）变成一个用户可用的普通串口设备。



🧱 1️⃣ 修改 U-Boot：关闭串口控制台输出

📁 编辑文件：

```
include/configs/imx93_evk.h
```

🔧 将原始控制台参数：

```c

    "console=ttyLP0,115200 earlycon\0"

```

✅ 修改为：

```c

    "console=tty0,115200 earlycon\0"

```

📌 说明：

- `ttyLP0` 是默认的串口 Console；
- 修改为 `tty0` 表示将 Console 输出重定向到 **图形终端或空终端**，释放 `ttyLP0` 给用户应用使用。



🧬 2️⃣ 修改 Linux Kernel：释放 DTS 中串口占用

修改dts文件`arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts`

注释掉`stdout-path = &lpuart1;`

