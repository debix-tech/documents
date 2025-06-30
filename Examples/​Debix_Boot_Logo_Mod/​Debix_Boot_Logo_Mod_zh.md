🎨 DEBIX 开发板更换开机 Logo 教程（Model A 适用）

✅ 步骤 1：下载 DEBIX 官方内核源码
	代码网址：https://github.com/debix-tech
📥 下载命令：

```shell
git clone --depth=1 https://github.com/debix-tech/linux-nxp-debix.git
```

✅ 步骤 2：准备新的 Logo 图片（`.ppm` 格式）
在ubuntu22.04系统上将png图片转换为ppm格式文件命令：

```shell
pngtopnm <input.png> ><output.pnm>
```

将图片转换成224色命令：

```shell
ppmquant 224 <input.pnm> > <output.pnm>
```

再将224色图片转换成ASCII 二进制文件，命令：

```shell
pnmtoplainpnm <input.pnm> > <output.ppm>
```

最后使用`file <name.ppm> `查看文件格式，文件格式为：`Netpbm image data, size = [宽] x [高], pixmap, ASCII text` 即可。

✅ 步骤 3：替换内核中的默认 Logo 文件
将你准备好的 logo 文件覆盖内核源代码目录中的默认 logo 文件：

```shell
drivers/video/logo/logo_linux_clut224.ppm
```

替换logo需将准备好的`logo.ppm`改名为`logo_linux_clut224.ppm`替换。

⚠️ 注意：

- 文件名必须为：`logo_linux_clut224.ppm`
- 格式必须为 ASCII PPM，颜色不超过 224 色

✅ 步骤 4：重新编译内核并替换镜像
重新编译内核，命令：`make -j4`
编译完成后在`arch/arm64/boot`目录下找到`Image`镜像文件，替换到TF卡中，重启debix即可。