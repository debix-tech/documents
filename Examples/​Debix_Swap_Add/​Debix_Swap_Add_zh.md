📦debix增加swap分区方法



✅ 步骤 1：查看当前内存与 Swap 使用情况

```shell
free -m 
    total        used        free      shared  buff/cache   available
Mem:         1947        808         368       11         771        1039
Swap:         127         39           88
```

✅ 步骤 2：创建一个 1GB 的 Swap 文件

```shell
dd if=/dev/zero of=/swapfile1 bs=1024 count=1048576
1048576+0 records in
1048576+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 30.0344 s, 35.8 MB/s
```

说明：

- 该命令会生成一个大小为 **1GB** 的文件 `/swapfile1`，作为新的交换空间。

- 如果你有其他内存大小，可根据需求调整 `count`。

  

✅ 步骤 3：格式化为 Swap 类型并设置权限

```shell
sudo mkswap /swapfile1
mkswap: /swapfile1: insecure permissions 0644, fix with: chmod 0600 /swapfile1
Setting up swapspace version 1, size = 1024 MiB (1073737728 bytes)
no label, UUID=0845fdc8-a7c2-4e39-9af6-4d6cd00b900c

sudo chmod 600 /swapfile1
```



✅ 步骤 4：立即启用 Swap 文件，输入命令

```shell
swapon /swapfile1
swapon: /swapfile1: insecure permissions 0644, 0600 suggested.
```



✅ 步骤 5：让 Swap 文件开机自动挂载

编辑` /etc/fstab`文件，并增加如下代码

```shell
/swapfile1 swap swap defaults 0 0
```



✅ 步骤 6：优化 Swap 使用策略

编辑`/etc/sysctl.conf`文件，并增加如下代码

```shell
vm.swappiness=10
```

### 🔧 参数含义：

- `vm.swappiness` 的值范围是 **0 到 100**
- 它表示内核在将内存页移到 swap 空间（虚拟内存）时的“积极程度”：

| 值   | 行为解释                                            |
| ---- | --------------------------------------------------- |
| 0    | **尽量不使用 swap**，除非万不得已（物理内存快用完） |
| 10   | 很少使用 swap，只在内存压力大时才使用（偏向缓存）   |
| 60   | 默认值，**平衡内存缓存与 swap 使用**                |
| 100  | **积极使用 swap**，尽早将不活跃页移到 swap          |

7.重启系统，输入命令`reboot`

8.查看swap分区大小， 输入命令

```shell
free -m
               total        used        free      shared  buff/cache   available
Mem:         1947         704         891       1         351        1163
Swap:         1151           0        1151
```

✅ **完成后，你的系统将具备 1GB 的新 Swap 分区，并在每次启动时自动挂载使用**