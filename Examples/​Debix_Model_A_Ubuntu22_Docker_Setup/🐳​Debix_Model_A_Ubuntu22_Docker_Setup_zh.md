🐳 在 DEBIX Model A (Ubuntu 22.04) 上安装并使用 Docker



🧱 第 1 步：更新系统软件源

```shell
sudo apt update
```

确保系统是最新状态，以避免安装过程中出现依赖问题。



🐳 第 2 步：安装 Docker

```shell
sudo apt install docker.io -y
```

📦 `docker.io` 是 Ubuntu 官方仓库中的 Docker 稳定版本。



🔧 第 3 步：启动 Docker 服务

```shell
sudo systemctl start docker
```



🔁 第 4 步：设置 Docker 开机自启

```shell
sudo systemctl enable docker
```

系统每次重启后将自动启动 Docker 服务。



🧪 第 5 步：验证 Docker 安装是否成功

```shell
docker --version

```

输出示例：

```shell
Docker version 24.x.x, build abcdefg

```



🚀 第 6 步：运行你的第一个容器

```shell
sudo docker run hello-world

```

✅ 如果安装正确，会看到如下输出：

```shell
Hello from Docker!
This message shows that your installation appears to be working correctly.

```

