

🧪 Usage

Check the current temperature

```shell
root@DebixSomB:~# cat /sys/class/thermal/thermal_zone0/temp
40350
```

Check the triggered trip points

```
root@DebixSomB:~#  cat /sys/class/thermal/thermal_zone0/trip_point_0_temp
105000
root@DebixSomB:~# cat /sys/class/thermal/thermal_zone0/trip_point_1_temp
105000


```

🔧 Current trip point configuration (unit: millidegree Celsius, °C × 1000):

| Thermal Zone    | trip_point_0_temp | trip_point_1_temp |
| --------------- | ----------------- | ----------------- |
| `thermal_zone0` | 95000 → 95°C      | 105000 → 105°C    |
| `thermal_zone1` | 95000 → 95°C      | 105000 → 105°C    |

🧩 Description

- `trip_point_0_temp = 95000`: This is **the passive thermal point**. When exceeded, it will trigger cooling actions such as CPU throttling.
- `trip_point_1_temp = 105000`: This is **the critical thermal point**. When exceeded, the system may trigger shutdown or kernel panic for protection.



You can modify these values through the `temperature` property in the `thermal-zones` node of the device tree, or directly via the terminal, for example:

```shell
root@DebixSomB:~# cat  /sys/class/thermal/thermal_zone0/trip_point_1_temp 
105000
root@DebixSomB:~# echo 100000 >  /sys/class/thermal/thermal_zone0/trip_point_1_temp 
root@DebixSomB:~# cat  /sys/class/thermal/thermal_zone0/trip_point_1_temp 
100000

```


🧩 Simulate high temperature trigger – system shutdown

```shell
echo 105000 >  /sys/class/thermal/thermal_zone0/emul_temp

[ 2396.221023] System is too hot. GPU3D will work at 1/64 clock.
[ 2396.227218] thermal thermal_zone0: cpu-thermal: critical temperature reached, shutting down
[ 2396.235599] reboot: HARDWARE PROTECTION shutdown (Temperature too high)

Message from syslogd@imx8mp-debix at Thu Apr  6 00:41:15 2023 ...
kernel: thermal thermal_zone0: cpu-thermal: critical temperature reached, shutting down

Message from syslogd@imx8mp-debix at Thu Apr  6 00:41:15 2023 ...
kernel: reboot: HARDWARE PROTECTION shutdown (Temperature too high)
root@imx8mp-debix:~#          Stopping Sess񞟏K  ] Removed slice Slice /system/modprobe.
.....
.....
         Stopping Linux Firmware Loader Daemon...
         Stopping Getty on tty1...
         Stopping NFS status monitor for NFSv2/3 locking....
         Stopping Telephony service...
         Stopping LSB: Run /etc/rc.local if it exist...
         Stopping Serial Getty on ttymxc1...
         Stopping System Logging Service...
[ 2396.812755] thermal thermal_zone0: cpu-thermal: critical temperature reached, shutting down
[ 2396.821145] reboot: HARDWARE PROTECTION shutdown (Temperature too high)
         Stopping Load/Save OS Random Seed...
         Stopping Weston, a Wayland…ositor, as a system service...

```

