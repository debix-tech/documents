🎮 在 DEBIX 上连接并测试 Xbox 手柄



🧱 第 1 步：安装 Xbox 手柄驱动

```shell
sudo apt-get install xboxdrv
```

📌 `xboxdrv` 是一个通用的 Xbox 控制器驱动程序，支持 Xbox 360 / One 有线或无线手柄。



🚫 第 2 步：禁用 Bluetooth 的增强型重新传输模式（ERTM）

ERTM 可能会影响 Xbox 蓝牙连接，需要禁用：

```shell
echo 'options bluetooth disable_ertm=Y' | sudo tee -a /etc/modprobe.d/bluetooth.conf

```



🔄 第 3 步：重启debix设备

```shell
sudo reboot
```



📡 第 4 步：连接 Xbox 手柄蓝牙

```shell
sudo bluetoothctl
```

进入蓝牙交互模式后执行：

```shell
scan on                             # 开始扫描设备
connect XX:XX:XX:XX:XX:XX           # 替换为你手柄的 MAC 地址
quit                                # 连接成功后退出

```



🎛️ 第 5 步：安装 joystick 工具

```shell
sudo apt-get install joystick

```

该工具包含 `jstest` 命令用于检测手柄输入。



🖥️ 第 6 步：安装图形界面测试工具（可选）

```shell
sudo apt-get install jstest-gtk

```

运行方式：

```shell
jstest-gtk

```

📊 可视化查看按钮、摇杆、触发器状态。



🎮 第 7 步：使用命令行测试 Xbox 手柄输入



```
sudo jstest /dev/input/js0
```

✅ 若手柄已识别，将看到如下类似输出（随按钮/摇杆操作实时更新）：

```shell
Driver version is 2.1.0.
Joystick (Microsoft X-Box 360 pad) has 8 axes and 11 buttons.

```

