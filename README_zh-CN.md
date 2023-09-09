# OpenIM Docker 部署

- [OpenIM Docker 部署](#openim-docker-部署)
  - [目录结构](#目录结构)
    - [项目结构说明](#项目结构说明)
  - [OpenIM Docker 使用指南](#openim-docker-使用指南)
      - [1. 获取图像](#1-获取图像)
      - [2. 使用 Docker-compose](#2-使用-docker-compose)
    - [一键部署：](#一键部署)
      - [故障排除：](#故障排除)
        - [1.推荐：使用环境变量（如上所述）。](#1推荐使用环境变量如上所述)
        - [2.修改自动化脚本：](#2修改自动化脚本)
        - [3. 修改 `config.yaml` 和 `.env` 文件（但请注意，重复使用 `make init` 生成配置会覆盖它们）。](#3-修改-configyaml-和-env-文件但请注意重复使用-make-init-生成配置会覆盖它们)
  - [OpenIM 数据存储架构指南](#openim-数据存储架构指南)
    - [**二。 OpenIM 默认数据存储结构**](#二-openim-默认数据存储结构)
    - [三. 自定义 OpenIM 的数据存储](#三-自定义-openim-的数据存储)
    - [四。 Docker 卷存储：一种高级方法](#四-docker-卷存储一种高级方法)
    - [自定义启动](#自定义启动)
      - [3.提示](#3提示)
  - [贡献](#贡献)
    - [结论](#结论)
  - [执照](#执照)


OpenIM Docker 为构建和部署 OpenIM 提供了稳定的解决方案。 有许多可用的部署选项，并且使用 Docker 和 Docker Compose 简化了该过程。

<palign="center"><a href="./README.md"><b>ENGLIST</b></a> • <a href="./README_zh-CN.md"><b> 简体中文 </b></a> </p>

## 目录结构

````
OpenIM Docker 部署
│
├── 📁 **构建/**
│ ├── 📄 Dockerfile-服务器
│ └── 📄 Dockerfile-聊天
│
├── 📁 **openim-server/**
│ ├── 📁 发布-v*.*/
│ └── 📁 主/
│
├── 📁 **openim-聊天/**
│ ├── 📁 发布-v*.*/
│ └── 📁 主/
│
├── 📁 **env/**
│ ├── 📄 openim-server.env
│ └── 📄 openim-chat.env
│
└── 📁 **示例/**
     ├── 📄 basic-openim-server-dependency.yml
     ├── 📄 only-openim-server.yml
     └── 📄 full-openim-server-and-chat.yml
````

- `build/`：用于构建 Docker 镜像。
- `openim-server/`：用于部署 openim-server。
- `openim-chat/`：用于部署 openim-chat。
- `env/`：包含 Docker-compose 的环境变量文件。 （暂时不需要）
- `example/`：包含各种 Docker-compose 示例，提供功能部署方案。

### 项目结构说明

- 对于 `openim-server` 和 `openim-chat` 的更改，请分别在 https://github.com/OpenIMSDK/Open-IM-Server/ 和 https://github.com/OpenIMSDK/chat 做出贡献。
- 为了同步两个项目的脚本和配置文件，我们使用自动化工具。 只需确保文件与原始存储库同步即可。
- 对于环境变量文件和 Docker-compose 示例，请在 `env/` 和 `example/` 下进行更改。


## OpenIM Docker 使用指南

#### 1. 获取图像

您可以从以下三个来源获取Docker镜像：

- [GitHub 包](https://github.com/orgs/OpenIMSDK/packages?repo_name=Open-IM-Server)
- 阿里云
- Docker 中心

为确保您获得最新版本的镜像，请参考以下文档：

- [OpenIM版本设计](https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/version.md)
- [OpenIM 图像策略](https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/images.md)



#### 2. 使用 Docker-compose

**设置环境变量**

> 您可以根据需要设置环境变量或使用默认变量。 配置选项可以在 https://github.com/OpenIMSDK/Open-IM-Server/blob/main/scripts/install/environment.sh 找到

````bash
export PASSWORD="openIM123" # 设置密码，默认为openIM123
export USER="root" # 设置用户名，默认为root
# 选择聊天版本和服务器版本 https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/images.md, 例如: main, release-v*.*
export CHAT_BRANCH="main" # 设置聊天版本，默认为release-v3.3（不稳定）
export SERVER_BRANCH="main" # 设置服务器版本，默认为release-v3.3（不稳定）
# ……其他环境变量
# MONGO_USERNAME：设置 MongoDB 用户名
# MONGO_PASSWORD：设置 MongoDB 密码
# MONGO_DATABASE：设置MongoDB数据库名称
# MINIO_ENDPOINT：设置MinIO服务地址
# API_URL：本地网络环境下，设置OpenIM Server API地址
导出 API_URL="http://127.0.0.1:10002"
# DOCKER_BRIDGE_SUBNET：设置Docker网桥网络地址，默认为172.28.0.0/16
导出 DOCKER_BRIDGE_SUBNET=172.28.0.0/16
````

这些只是一些常见的配置选项。
这些只是一些常见的配置选项。
These are just some common configuration options.
这些只是几个常见的配置选项。
These are just a few common configuration options.
 如果您不需要它们，您可以阅读我们的[配置中心说明](https://github.com/openimsdk/open-im-server/blob/main/docs/contrib/environment.md)。

通过“./scripts/init-config.sh”或“make init”渲染所需的配置。 可以直接修改https://github.com/openimsdk/openim-docker/blob/main/scripts/install/environment.sh或者设置linux环境变量。 例如，上面的“PASSWORD”和“USER”。 后一种方法仅适用于当前终端


### 一键部署：

````bash
git 克隆 https://github.com/openim-sigs/openim-docker openim/openim-docker && 导出 openim=$(pwd)/openim && cd $openim/openim-docker && ./scripts/init-config.sh && docker 组成-d
````

#### 故障排除：

常见问题记录在 [FAQ.md](https://github.com/OpenIMSDK/openim-docker/blob/main/FAQ.md) 中。 如果您遇到任何问题，可以参考该文档。

也可以找到以前遇到过的[问题](https://github.com/OpenIMSDK/openim-docker/issues)，如果没有，请向我们提供[问题描述](https://github.com/issues)。 com/openimsdk/openim-docker/issues/new/choose)



####修改配置文件：

修改配置文件有以下三种方式：

##### 1.推荐：使用环境变量（如上所述）。

**用于更新配置：**

````bash
进行初始化
````

##### 2.修改自动化脚本：

````bash
脚本/安装/environment.sh
````

更新配置：

````bash
进行初始化
````

##### 3. 修改 `config.yaml` 和 `.env` 文件（但请注意，重复使用 `make init` 生成配置会覆盖它们）。

**默认启动选择：**

````bash
docker-compose up -d
````

> **注意**：如果获取镜像较慢，可以选择阿里云镜像。 对于 openim-server 和 openim-chat，它们是可以互换的。 只需要修改docker-compose.yml文件中的镜像即可。

````bash
# 图片：ghcr.io/openimsdk/openim-server:latest
图片：registry.cn-hangzhou.aliyuncs.com/openimsdk/openim-server:latest
# 图像：openim/openim-server:最新
````


## OpenIM 数据存储架构指南

### **二。 OpenIM 默认数据存储结构**

**A。 概述**

OpenIM 数据存储的核心是基本组件：Kafka、MNT、MongoDB、MySQL 和 Redis。 每个都有不同的用途，并且需要特定的配置和数据目录以获得最佳性能。

**B。 目录结构**

````bash
$ 树组件/ -d -L 2
成分/
├── 卡夫卡
│ ├── 配置
│ └── 数据
├── mnt
│ ├── 配置
│ └── 数据
├── mongodb
│ └── 数据
├── mysql
│ └── 数据
└── 雷迪斯
     ├── 配置
     └── 数据
````


### 三. 自定义 OpenIM 的数据存储

**A。 设置自定义目录**

对于具有特定存储目录要求的组织，OpenIM 可以灵活地指定自定义目录。 按着这些次序：

1. 通过设置 `DATA_DIR` 环境变量来定义自定义目录路径：

````bash
$ 导出 DATA_DIR="/path/to/your/directory"
````

1. 刷新 OpenIM 的配置以反映此更改：

````bash
$ 进行初始化
````

**注意：** 此操作将更新配置以指向您指定的目录。


### 四。 Docker 卷存储：一种高级方法

**A。 为什么选择 Docker Volume？**

Docker 卷提供隔离存储解决方案，优化数据持久性和性能。 在 Docker 中扩展服务时，使用卷可确保数据保持一致并受到保护。

**B。 将 Docker Volume 与 OpenIM 结合使用**

要启动具有 Docker 卷支持的 OpenIM，请执行：

````bash
$ docker compose -f example/volume-all-server.yml up -d
````

通过此设置，您的 OpenIM 数据可以安全地安装到 Docker 的卷上，从而提供更高的弹性和可扩展性。

**C。 管理 Docker 卷**

1. **列出 OpenIM Docker 卷**

使用以下命令检索与 OpenIM 关联的 Docker 卷列表：

````bash
$ docker 卷 ls | grep 打开 IM 服务器
````

1. **删除数据**

- 对于**本地映射数据**：只需导航到适当的目录并删除所需的文件或文件夹。
- 对于 **Docker 卷数据**：如果您希望清除 Docker 卷中的数据，请使用以下命令：

````bash
$ docker 卷 ls | grep 打开 IM 服务器 | awk '{print $2}' | xargs docker 卷 rm
````

**警告：** 此操作将永久删除数据。 在继续之前，请务必确保您有备份。


### 自定义启动

根据您的要求，选择适当的 Docker-compose 文件来启动：

- **基本环境依赖**：

   ````bash
   docker-compose -f 示例/basic-openim-server-dependency.yml up -d
   ````

- **仅限 OpenIM 服务器**：

   ````bash
   docker-compose -f example/only-openim-server.yml up -d
   ````

- **OpenIM 服务器和聊天**：

   ````bash
   docker-compose -f 示例/full-openim-server-and-chat.yml up -d
   ````

**安装：**

在 Docker Compose 文件中，“volumes”关键字定义命名卷。该卷上存储的数据不会丢失。

为了便于管理，我们使用命名卷。 这些卷与服务具有相同的名称。 例如，openim-server 服务使用 openim-server 命名卷，而 openim-chat 服务使用 openim-chat 命名卷。

查看所有卷：

````bash
docker 卷 ls
````

查看特定卷：

````bash
docker 卷检查 <卷名称>
````

删除命名卷：

````bash
docker 卷 rm <卷名称>
````

删除未使用的卷：

````bash
docker 卷修剪
````

**自定义您的图像**

为了方便定制，我们提供了各种发行版和架构的基本镜像。 仓库地址为https://github.com/OpenIMSDK/openim-base-image，方便定制。

**测试运行状态**

要查看所有服务是否已启动，您可以使用：

````bash
docker-compose ps
````

如果发现容器没有启动，可以查看具体服务的日志来查找原因。 例如查看OpenIM Server的日志：

````bash
docker-compose 日志 openim-server
````

**停止**

要停止 Docker-compose 运行的所有服务：

````bash
docker-compose 下来
````

如果您使用了特定的“docker-compose”文件，请确保也在“down”命令中指定它。

#### 3.提示

确保您的 Docker 和 Docker Compose 是最新的，以保证最佳的兼容性和性能。

## 贡献

- 将此存储库分叉到您的 GitHub 帐户。
- 将分叉存储库克隆到您的本地环境。
- 创建一个新分支并以您的贡献命名。
- 根据需要进行更改。
- 提交您的更改并将其推送到您的叉子上。
- 在 GitHub 上创建新的 Pull 请求。

我们鼓励社区对此项目做出贡献和改进。 具体贡献流程请参考【CONTRIBUTING.md】(https://chat.openai.com/CONTRIBUTING.md)。

### 结论

OpenIM 灵活的存储解决方案使组织能够根据其特定需求配置其基础设施。 无论是通过默认目录、自定义路径还是 Docker 卷，OpenIM 都能保证高效、安全的数据管理。

如需进一步帮助或高级配置，请咨询我们的技术支持团队或参阅 OpenIM 的综合文档。

## 执照

该项目使用 MIT 许可证。 详情请参阅[LICENSE](https://chat.openai.com/LICENSE)。