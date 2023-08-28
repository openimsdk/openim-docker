# OpenIM Docker Deployment

OpenIM Docker 提供了一个稳定的 OpenIM 构建和部署解决方案，有非常多的部署方案提供选择，使用 Docker 和 Docker Compose 简化了整个过程。

<p align="center">
    <a href="./README.md"><b> English </b></a> •
    <a href="./README-zh_CN.md"><b> 简体中文 </b></a>
</p>

</p>

## 目录结构

```bash
OpenIM Docker Deployment
│
├── 📁 **build/**
│   ├── 📄 Dockerfile-server
│   └── 📄 Dockerfile-chat
│
├── 📁 **openim-server/**
│   ├── 📁 release-v*.*/
│   └── 📁 main/
│
├── 📁 **openim-chat/**
│   ├── 📁 release-v*.*/
│   └── 📁 main/
│
├── 📁 **env/**
│   ├── 📄 openim-server.env
│   └── 📄 openim-chat.env
│
└── 📁 **example/**
    ├── 📄 basic-openim-server-dependency.yml
    ├── 📄 only-openim-server.yml
    └── 📄 full-openim-server-and-chat.yml
```

- `build/`：用于构建 Docker 镜像。
- `openim-server/`：用于部署 openim-server。
- `openim-chat/`：用于部署 openim-chat。
- `env/`：存放 Docker-compose 的环境变量文件。(暂时不需要)
- `example/`：包含各种 Docker-compose 示例，提供特性部署方案。


### 项目结构说明

- 对于 `openim-server` 和 `openim-chat` 的更改，请分别前往 https://github.com/OpenIMSDK/Open-IM-Server/ 和 https://github.com/OpenIMSDK/chat 进行贡献。
- 为了同步两个项目的脚本和配置文件，我们使用自动化工具。您只需要确保文件与原始仓库保持同步。
- 对于环境变量文件和 Docker-compose 示例，请在 `env/` 和 `example/` 目录下进行更改。


## OpenIM Docker 使用方法

#### 1. 获取镜像

您可以从以下三个源获取 Docker 镜像：

- [GitHub Packages](https://github.com/orgs/OpenIMSDK/packages?repo_name=Open-IM-Server)
- 阿里云
- Docker Hub

为了确保获取到最新版本的镜像，请参考以下文档：

- [openim 版本设计](https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/version.md)
- [openim 镜像策略](https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/images.md)

#### 2. 使用 Docker-compose

**克隆存储库：**

```bash
git clone https://github.com/openim-sigs/openim-docker openim/openim-docker && export openim=$(pwd)/openim && cd $openim/openim-docker
```

**默认一键启动：**

```bash
make install
```

**修改配置文件：**

通过三种方式来修改配置文件：

1. 推荐使用环境变量：

```bash
export PASSWORD="openIM123" # 设置密码，默认是 openIM123
export USER="root" # 设置用户名，默认是 root
# 选择 chat 版本 和 server 版本https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/images.md, eg: main, release-v*.*
export CHAT_BRANCH="release-v1.2"   # 设置 chat 版本，默认是 main（不稳定）
export SERVER_BRANCH="release-v3.2" # 设置 server 版本，默认是 main（不稳定）
# ...... 其他环境变量
# MONGO_USERNAME: 设置 MongoDB 用户名
# MONGO_PASSWORD: 设置 MongoDB 密码
# MONGO_DATABASE: 设置 MongoDB 数据库名
# MINIO_ENDPOINT: 设置 MinIO 服务地址
# API_URL: 内网环境下，设置 OpenIM Server API 地址
export API_URL="http://127.0.0.1"
```

需要更新配置：

```bash
make init
```

2. 修改自动化脚本：

```bash
scripts/install/environment.sh
```

需要更新配置：

```bash
make init
```

3. 修改 `config.yaml` 以及 `.env` 文件（但是重新使用 make init 生成配置后会覆盖）


**默认启动选择：**

```bash
docker-compose up -d
```


> **Note**:
> 拉取镜像很慢，可以选择阿里云的镜像。对于 openim-server 以及 openim-chat 是通用的，只需要修改 docker-compose.yml 中的 image 即可。

```bash
# image: ghcr.io/openimsdk/openim-server:latest
image: registry.cn-hangzhou.aliyuncs.com/openimsdk/openim-server:latest
# image: openim/openim-server:latest
```


**定制启动**

根据您的需求，选择相应的 Docker-compose 文件进行启动：

- **基础环境依赖**：

  ```bash
  docker-compose -f example/basic-openim-server-dependency.yml up -d
  ```

- **仅部署 OpenIM Server**：

  ```bash
  docker-compose -f example/only-openim-server.yml up -d
  ```

- **部署 OpenIM Server 和 Chat**：

  ```bash
  docker-compose -f example/full-openim-server-and-chat.yml up -d
  ```

**挂载：**

在Docker Compose文件中，volumes关键字是用来定义命名卷的。命名卷是Docker的一个存储概念，它允许您为容器创建一个持久化的存储空间。这意味着即使容器被删除，存储在该卷中的数据也不会丢失。

为了方便管理，我们使用了命名卷。这些卷的名称与服务的名称相同。例如，openim-server 服务使用了 openim-server 命名卷， openim-chat 服务使用了 openim-chat 命名卷。

查看所有的卷：

```bash
docker volume ls
```

查看特定的卷：

```bash
docker volume inspect <volume-name>
```

删除命名卷:

```bash
docker volume rm <volume-name>
```

删除未使用的卷:

```bash
docker volume prune
```


**定制自己的镜像**

为了方便定制化操作，我们提供了各种发行版以及各种架构的 基础镜像，仓库地址是 https://github.com/openim-sigs/openim-base-image, 方便定制化。


**测试运行状态**

要查看所有服务是否都已启动，可以使用：

```bash
docker-compose ps
```

如果您发现没有启动的容器，您可以查看特定服务的日志以找出原因。例如，查看 OpenIM Server 的日志：

```bash
docker-compose logs openim-server
```

**停止**

停止 Docker-compose 运行的所有服务：

```bash
docker-compose down
```

如果您使用了特定的 `docker-compose` 文件，请确保也在 `down` 命令中指定它。

#### 3. 提示

确保您的 Docker 和 Docker Compose 是最新版本，以确保最佳兼容性和性能。


## 贡献

+ Fork 这个仓库到您的 GitHub 账户下。
+ 克隆 fork 后的仓库到您的本地环境。
+ 创建一个新的分支为您的贡献内容命名。
+ 在您需要修改的部分进行更改。
+ 提交您的更改并推送到您的 fork。
+ 在 GitHub 上创建一个新的 Pull Request。

我们鼓励社区贡献并完善这个项目。具体的贡献流程，请查看 [CONTRIBUTING.md](./CONTRIBUTING.md)。

## 协议

本项目使用 MIT 协议。详情请查看 [LICENSE](./LICENSE)。
