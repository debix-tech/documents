## Using NXP’s Docker to Build Yocto

The reason for using Docker is to directly use the prebuilt image provided by NXP, which reduces the hassle of setting up the environment. Also, when using older versions of Ubuntu, some dependencies may not be installable.

### 1. If Docker is not installed, follow these steps:

#### Install Docker

There are various methods of installing [docker](https://docs.docker.com/engine/install/ubuntu/), i.e. by docker script:

```{.sh}
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
```



#### Run docker without sudo



To work better with docker, without `sudo`, add your user to `docker group`.

```{.sh}
$ sudo usermod -aG docker <your_user>
```



Log out and log back in so that your group membership is re-evaluated.

#### Set docker to work with proxy



Create a docker config file at `~/.docker/config.json` and enter the following:

```{.sh}
{
"proxies":
    {
     "default":
         {
          "httpProxy":"http://proxy.example.com:80"
         }
    }
}
```



Note: replace the 'example' proxy with your proxy info.

#### Create docker service



```{.sh}
$ sudo mkdir -p /etc/systemd/system/docker.service.d
$ sudo vim /etc/systemd/system/docker.service.d/http-proxy.conf
```



add the following:

```{.sh}
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80/"
Environment="NO_PROXY=localhost,someservices.somecompany.com"
```



Restart Docker

```{.sh}
  $ sudo systemctl daemon-reload
  $ sudo systemctl restart docker
```

---

### 2. If Docker is already installed, follow these steps:

**a. Download the source code:**

```sh
git clone https://github.com/nxp-imx/imx-docker.git
```

**b. Set environment variables, e.g., working directory `DOCKER_WORKDIR`, Yocto version `IMX_RELEASE`:**

```shell
./env.sh
```

```shell
ljm@a8023ae46797:/workstation1/ljm/polyhex-imx93/yocto/imx-6.12.20-2.0.0$ cat env.sh 
#!/bin/bash
# Here are some default settings.
# Make sure DOCKER_WORKDIR is created and owned by current user.

# Docker

DOCKER_IMAGE_TAG="imx-yocto"
DOCKER_WORKDIR="/workstation1/ljm/polyhex-imx93/yocto"

# Yocto

IMX_RELEASE="imx-6.12.20-2.0.0"

YOCTO_DIR="${DOCKER_WORKDIR}/${IMX_RELEASE}-build"

MACHINE="imx8mpevk"
DISTRO="fsl-imx-xwayland"
IMAGES="imx-image-core"

REMOTE="https://github.com/nxp-imx/imx-manifest"
BRANCH="imx-linux-walnascar"
MANIFEST=${IMX_RELEASE}".xml"

```
**c. Install Ubuntu image:**

```sh
./docker-build.sh Dockerfile-Ubuntu-22.04
```

**d. Run the Docker container:**

```sh
./docker-run.sh
```

**e. Download the NXP Yocto source code:**

Run:

```sh
./yocto-build.sh
```

Or manually:

```sh
repo init -u https://github.com/nxp-imx/imx-manifest.git -b imx-linux-walnascar -m imx-6.12.20-2.0.0.xml
repo sync
MACHINE=imx93evk DISTRO=fsl-imx-xwayland source ./imx-setup-release.sh -b SOM_B
bitbake imx-image-full
```

---

## Issues

**Issue 1:**

```
glib-compile-resources: g_subprocess_wait: assertion 'G_IS_SUBPROCESS (subprocess)' failed  
g_object_unref: assertion 'G_IS_OBJECT (object)' failed  
resources.gresource.xml: Failed to close file descriptor for child process (Operation not permitted)
```

**Solution:**
Add `--security-opt seccomp=unconfined` when running the container.

---

**Issue 2:**

```shell
ERROR: When reparsing /workstation1/ljm/polyhex-imx93/yocto-L6.12.20-2.0.0/sources/meta-imx/meta-imx-ml/recipes-libraries/tensorflow-lite/tensorflow-lite-ethosu-delegate_2.18.0.bb:do_configure, the basehash value changed from c2040ab19d5851a94bc1726fb195fece8505f9c46ab4049593f86cb5d735b7bf to f8d72d1ba2284d743b6906b2442300957cc1eddf88bd2436eca805483dc13041. The metadata is not deterministic and this needs to be fixed.
ERROR: The following commands may help:
ERROR: $ bitbake tensorflow-lite-ethosu-delegate -cdo_configure -Snone
ERROR: Then:
ERROR: $ bitbake tensorflow-lite-ethosu-delegate -cdo_configure -Sprintdiff
```

**Solution:**

```sh
bitbake tensorflow-lite-ethosu-delegate -cdo_configure -Snone
bitbake tensorflow-lite-ethosu-delegate -cdo_configure -Sprintdiff
```

---

**Issue 3:**

The built image does not include `.wic` file. You can extract it from `.wic.zst`:

```sh
unzstd my-image.wic.zst
```

---

**Issue 4:**

Install cross-compilation toolchain:

```sh
bitbake meta-toolchain
```

The generated script can be found at:

```
/workstation1/ljm/polyhex-imx93/yocto-L6.12.20-2.0.0/SOM_B/tmp/deploy/sdk/fsl-imx-xwayland-glibc-x86_64-meta-toolchain-armv8a-imx93evk-toolchain-6.12-walnascar.sh
```

