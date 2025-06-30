下面介绍如何在yocto工程里面修改kernel，uboot的源代码为debix提供，以便可以在yocto里面使用debix提供的kernel和uboot



## ⚙️ 一、下载 NXP Yocto 工程 和 DEBIX 内核 / U-Boot 源码



📦 第 1 步：下载 `repo` 工具

```shell
mkdir ~/bin
cd ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > repo
chmod a+x repo

```

📌 `repo` 是 Google 提供的多 Git 仓库管理工具，用于拉取 Yocto 工程多个子模块。



🛠 第 2 步：添加环境变量（永久生效）

编辑 `~/.bashrc` 文件，末尾添加：

```shell
export PATH=~/bin:$PATH
```

然后执行使其生效：

```shell
source ~/.bashrc
```



🧾 第 3 步：配置 Git 用户信息（用于 repo 管理）

```shell
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --list

```

🌐 第 4 步：下载 NXP 官方 Yocto 工程

```shell
mkdir imx-yocto-bsp
cd imx-yocto-bsp
repo init -u https://github.com/nxp-imx/imx-manifest.git \
          -b imx-linux-kirkstone \
          -m imx-5.15.71-2.2.0.xml

```

* 📌 该命令基于 **Linux 5.15.71** 内核版本；

* `-b` 指定分支，`-m` 指定 manifest 文件；

拉取全部源码：

```shell
repo sync
```



🧰 第 5 步：集成 DEBIX 专用kernel内核 & U-Boot 源码

📁 创建本地代码目录

在`imx-yocto-bsp`目录下创建如下文件夹存放debix的kernel源码和uboot源码

```shell
mkdir polyhex-code
cd polyhex-code
```

⬇️ 下载源码到对应目录：

- 🐧 **内核源码**

  ```shell
  git clone https://github.com/debix-tech/linux-nxp-debix.git 
  ```

  切换到对应的分支，比如这里的 **lf_5.15.71-debix_model_ab**

  ```shell
  git checkout lf_5.15.71-debix_model_ab
  ```

  

* 🧱 **U-Boot 源码**

  ```shell
  git clone https://github.com/debix-tech/uboot-nxp-debix.git
  ```

  切换到对应的分支

  ```shell
  git checkout lf_v2022.04-debix_model_a
  ```

  

## 🧩 二、在 Yocto 工程中指定 DEBIX 的内核和 U-Boot 源码

🧱 第 1 步：修改 U-Boot 配方（`.bb` 文件）

📁 路径：`sources/meta-imx/meta-bsp/recipes-bsp/u-boot/u-boot-imx_2022.04.bb`

✅ 需要修改的字段如下：

```shell
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
UBOOT_SRC ?= "git://${BSPDIR}/polyhex-code/uboot-nxp-debix;protocol=file"
#UBOOT_SRC ?= "git://github.com/nxp-imx/uboot-imx.git;protocol=https"
#SRCBRANCH = "lf_v2022.04"
SRCBRANCH = "lf_v2022.04-debix_model_a"
SRCREV = "cf7f1d8c1d3b5b5c2db2b809e1ff1ed79e73ea66"
#SRCREV = "181859317bfafef1da79c59a4498650168ad9df6"
LOCALVERSION = ""

```



`UBOOT_SRC`  变量指定了下载路径，这里的路径指向了存放uboot源码的目录，📌注意这里需要根据具体的路径来修改

`SRCBRANCH` 指定了git分支，比如这里的`lf_v2022.04-debix_model_a`，📌注意这里需要根据具体来修改

`SRCREV` 指定了下载的commit的版本，commit版本号要替换成debix的，📌注意这里需要根据具体来修改，不然会导致编译报错



🐧 第 2 步：修改 Linux 内核配方

📁 路径：`sources/meta-imx/meta-bsp/recipes-kernel/linux/linux-imx_5.15.bb`

✅ 需要修改的字段如下：

```shell
SRCBRANCH = "lf-5.15.y"
#LOCALVERSION = "-lts-next"
LOCALVERSION = ""
KERNEL_SRC ?= "git://${BSPDIR}/polyhex-code/linux-nxp-debix;protocol=file;branch=${SRCBRANCH}"
#KERNEL_SRC ?= "git://github.com/nxp-imx/linux-imx.git;protocol=https;branch=${SRCBRANCH}"
KBRANCH = "lf_5.15.71-debix_model_ab"
#KBRANCH = "${SRCBRANCH}"
SRC_URI = "${KERNEL_SRC}"
SRCREV = "d740759168c787aaafefd999788db7263fdb471e"
#SRCREV = "95448dd0dc9b621ae027cbefedaaa7c3d0d3ad2d"

```

上面红色部分为需要修改的部分

`KERNEL_SRC`  变量指定了下载路径，这里的路径指向了存放Linux源码的目录，📌注意这里需要根据具体的路径来修改

`SRCBRANCH` 指定了git分支，比如这里的`lf_5.15.71-debix_model_ab`，📌注意这里需要根据具体来修改

`SRCREV` 指定了下载的commit的版本，commit版本号要替换成debix的，📌注意这里需要根据具体来修改，不然会导致编译报错



## 🔧三、重新编译

修改之后，重新编译即可