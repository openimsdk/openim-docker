# OpenIM Docker

<<<<<<< HEAD
本指南提供了使用 Docker Compose 部署 OpenIM v3.5 的详细说明。内容涵盖从准备环境到验证部署的全部步骤。

> [!WARNING]
> 需要注意的是，本指南仅适用于 OpenIM v3.5。如果您还想使用旧版本，那么请参考其他的 `release-*` 分支。

**Documentation**

+ [https://docs.openim.io/zh-Hans/guides/gettingStarted/dockerCompose](https://docs.openim.io/zh-Hans/guides/gettingStarted/dockerCompose)


## 环境准备

- 确保有一个干净的服务器环境。详情请访问[OpenIM 环境设置](https://www.notion.so/OpenIM-v3-5-Docker-Compose-9e94fc1fec3a4bc28c54db0c629301f8?pvs=21)。
- 在服务器上安装 Docker。

## 仓库设置

克隆仓库并选择适当的分支：

```bash
git clone -b refactor/openim-docker https://github.com/openimsdk/openim-docker openim-docker && cd openim-docker && make init
```

## 基础配置

- 使用 `curl http://ifconfig.me` 确定您的外部服务 IP。
- 在环境中设置您的 IP 地址：

```bash
export OPENIM_IP="您的 IP 地址"
```

- 如果您忘记了这一步，可以参考后面的 [配置文件修改](#配置文件修改)。


## 高级配置

对于复杂配置：

- 复制 `.env` 文件并进行必要的配置，使用 `make init`。
- 请参阅 [OpenIM 服务器环境文档](https://github.com/openimsdk/open-im-server/blob/main/docs/contrib/environment.md) 了解详细指导。


## 配置读取的优先级

最高的优先级是从环境变量中读取的值，其次是 `.env` 文件中的值，最后是 `docker-compose.yaml` 文件中的默认值。

## 启动服务

- 启动 OpenIM 服务：

```bash
docker compose up -d
```

## 验证

- **OpenIM 服务器：** 使用 `docker compose logs -f openim-server` 检查日志。
- **OpenIM 聊天：** 使用 `docker compose logs -f openim-chat` 进行日志验证。
- **OpenIM Web：** 访问 http://127.0.0.1:11001，注册，并在账户之间验证发送图片和文本。
- **OpenIM 管理：** 访问 https://127.0.0.1:11002，使用默认凭据 `admin1, admin1`。

## 目录结构

```bash
smile@smile:/data/workspaces/openim-docker$ tree 
.
├── 📝 `docker-compose.yaml` - *Docker Compose配置文件，用于定义和运行多容器Docker应用程序。*
├── 📂 `example` - *包含各种示例配置文件和脚本，展示如何配置和使用OpenIM服务。*
│   ├── 📄 `basic-openim-server-dependency.yml` - *基本OpenIM服务器依赖配置。*
│   ├── 📄 `full-openim-server-and-chat.yml` - *完整的OpenIM服务器和聊天服务配置。*
│   ├── 📄 `full-openim-server-chat-web-admin.yml` - *包括服务器、聊天、Web界面和管理员工具的完整配置。*
│   ├── 📄 `only-openim-server.yml` - *仅包含OpenIM服务器的配置。*
│   └── 📄 `volume-all-server.yml` - *服务器的卷配置文件。*
├── 📄 `FAQ-CN.md` - *中文常见问题解答文档。*
├── 📄 `FAQ.md` - *英文常见问题解答文档。*
├── 📄 `LICENSE` - *项目许可证文件。*
├── 📄 `Makefile` - *自动化构建工具配置文件。*
├── 📂 `openim-server` - *OpenIM服务器的相关文件。*
│   └── 📂 `_output`
│       └── 📂 `logs`
│           └── 📄 `openim_20240102.log` - *服务器日志文件。*
├── 📄 `README.md` - *项目英文说明文档。*
├── 📄 `README_zh-CN.md` - *项目中文说明文档。*
└── 📂 `scripts` - *项目的初始化、配置和升级脚本。*
    ├── 📄 `clean.sh` - *清理脚本。*
    ├── 📄 `create-topic.sh` - *用于创建消息主题。*
    ├── 📄 `init-config.sh` - *初始化配置的脚本。*
    ├── 📄 `mongo-init.sh` - *初始化MongoDB的脚本。*
    ├── 📄 `README.md` - *脚本说明文档。*
    ├── 📂 `template` - *项目模板文件。*
    │   ├── 📄 `boilerplate.txt`
    │   ├── 📄 `footer.md.tmpl`
    │   ├── 📄 `head.md.tmpl`
    │   ├── 📄 `LICENSE`
    │   ├── 📄 `LICENSE_TEMPLATES`
    │   └── 📄 `project_README.md`
    └── 📄 `upgrade.sh` - *项目升级脚本。*
```

1. `docker-compose.yaml`：这是一个Docker Compose文件，用于定义和运行多容器Docker应用程序。它描述了应用程序所需的服务、网络和卷。
2. `example`目录：包含多个示例配置文件，用于展示如何使用和部署OpenIM服务。
    - `basic-openim-server-dependency.yml`：基本的OpenIM服务器依赖配置。
    - `full-openim-server-and-chat.yml`：包括OpenIM服务器和聊天服务的完整配置。
    - `full-openim-server-chat-web-admin.yml`：包括服务器、聊天、Web界面和管理员工具的全套配置。
    - `only-openim-server.yml`：仅包含OpenIM服务器的配置。
    - `volume-all-server.yml`：用于配置服务器的卷， 以 Valume 的形式挂载到容器中。
3. `FAQ-CN.md`和`FAQ.md`：分别是中文和英文的常见问题解答文档，提供对OpenIM用户常见疑问的回答。
6. `Makefile`：一个构建自动化工具配置文件，用于简化编译和安装过程。
7. `openim-server`目录：存放OpenIM服务器的相关文件，都是由 openim-server 服务启动后映射出来生成的。
    - `_output/logs`：存放日志文件，例如`openim_20240102.log`记录了特定日期的日志信息。
8. `_output`目录：通常包含构建过程的输出，如二进制文件、临时文件和工具。
    - `bin`：编译生成的二进制文件。
    - `tmp`：临时文件。
    - `tools`：项目使用的工具。
9. `README.md`和`README_zh-CN.md`：项目的说明文件，分别是英文和中文版本，提供项目概览和基本信息。
10. `scripts`目录：包含多个脚本文件，用于项目的初始化、配置和升级。
    - `clean.sh`：清理脚本，用于清除临时文件或构建输出。
    - `create-topic.sh`和`mongo-init.sh`：用于初始化数据库和消息队列的脚本。
    - `init-config.sh`：初始化配置的脚本。
    - `README.md`：对脚本目录的描述。
    - `template`子目录：包含项目模板文件，如许可证模板和README模板。
    - `upgrade.sh`：用于升级项目的脚本。

## 使用 example 部署

注意的是，如果是使用 example 部署，那么需要设定 `DATA_DIR` 的变量来指定数据存储的位置。

```bash
export DATA_DIR="/test/test"
```

`DATA_DIR` 将会存放中间件的配置信息，数据信息，日志信息。以及 openim-server 和 openim-chat 的配置信息以及日志信息。

例如，当我部署 openim-server, openim-chat, openim-admin 以及 openim-web，使用：

```bash
docker-compose -f example/full-openim-server-chat-web-admin.yml up -d 
```

查看日志：
```bash
docker-compose -f example/full-openim-server-chat-web-admin.yml logs -f openim-server
docker-compose -f example/full-openim-server-chat-web-admin.yml logs -f openim-chat
```

查看数据存放的位置：

```bash
cat example/.env |grep DATA_DIR
```

清空数据：

```bash
docker-compose -f example/full-openim-server-chat-web-admin.yml down
rm -rf "数据存放的位置"
```

**目录结构：**

```bash
$ tree /test/ -L 3
/test/
└── test
    ├── components
    │   ├── kafka
    │   ├── mnt
    │   ├── mongodb
    │   ├── mysql
    │   └── redis
    └── openim-server
    │   ├── config
    │   ├── logs
    │   └── _output
    │
    └── openim-chat
        ├── config
        └── logs
```

## 配置文件修改

在配置文件修改前，使用 `docker compose down` 停止服务。

- 要修改配置，请主要关注 `.env` 文件。
- 使用 `make init` 初始化配置文件。
- 在 Docker 中，对于 `.env`、`openim-server/config/config.yaml` 和 `openim-chat/config/config.yaml` 中的共享变量，遵循完全重新生成配置或部分更新的步骤。
- 对于 `OPENIM_IP`、`API_OPENIM_PORT`、`MINIO_PORT` 等特定更新，确保在 `openim-server/config/config.yaml` 中更新。

```bash
object:
  apiURL: "http://$OPENIM_IP:$API_OPENIM_PORT"
  minio:
    endpoint: "http://$DOCKER_BRIDGE_GATEWAY:$MINIO_PORT"
    signEndpoint: "http://$OPENIM_IP:$MINIO_PORT"

grafanaUrl: http://$OPENIM_IP:$GRAFANA_PORT
```

## 常见配置

- 根据您的需求设置 `OPENIM_IP`、`DATA_DIR` 和 `IMAGE_REGISTRY`。
- 对于 MySQL、Redis、Kafka、MongoDB、MinIO 和 Zookeeper 等数据库配置，更新相应的端口和凭证。


## OpenIM Docker 升级

- 从 V3.4 升级到 V3.5 涉及代码更改和部署结构重构，暂时不支持自动升级。
- 对于小的更新（并且是 v3.5以及 v3.5 以后得升级）不涉及到配置文件的添加或者删除，修改 `.env` 文件中的 `SERVER_IMAGE_VERSION` 和 `CHAT_IMAGE_VERSION`。
- 使用 `git pull` 和 `make upgrade` 进行仓库更新。


## 清理部署

- 使用 `docker compose down` 停止服务。
- 使用 `sudo make clean` 清理配置。
- 根据需要选择性清理数据并清理未使用的网络： `docker network prune -f`

## 补充信息

- 确保聊天的 IP 和端口环境变量一致。
- 有关快速验证、管理后台、监控系统以及更详细的配置说明，请参阅 OpenIM 文档。

## 常见问题

+ 新版 Docker 集成了 `docker-compose`。旧版可能不支持网关功能。建议升级到较新的版本，例如 23.0.1。

+ 遇到部署的问题查找 issue: [https://github.com/openimsdk/openim-docker/issues
](https://github.com/openimsdk/openim-docker/issues
)。issue 不存在的话请帮助我们提 issue。
=======

## 目录结构

```
smile@smile:/data/workspaces/openim-docker$ tree 
.
├── docker-compose.yaml
├── example
│   ├── basic-openim-server-dependency.yml
│   ├── full-openim-server-and-chat.yml
│   ├── full-openim-server-chat-web-admin.yml
│   ├── full-openim-server-chat-web.yml
│   ├── only-openim-server.yml
│   ├── scripts
│   │   ├── create-topic.sh
│   │   └── mongo-init.sh
│   └── volume-all-server.yml
├── FAQ-CN.md
├── FAQ.md
├── go.mod
├── go.sum
├── LICENSE
├── Makefile
├── openim-server
│   └── _output
│       └── logs
│           └── openim_20240102.log
├── _output
│   ├── bin
│   ├── tmp
│   └── tools
├── README.md
├── README_zh-CN.md
└── scripts
    ├── clean.sh
    ├── create-topic.sh
    ├── init-config.sh
    ├── mongo-init.sh
    ├── README.md
    ├── template
    │   ├── boilerplate.txt
    │   ├── footer.md.tmpl
    │   ├── head.md.tmpl
    │   ├── LICENSE
    │   ├── LICENSE_TEMPLATES
    │   └── project_README.md
    └── upgrade.sh
```
>>>>>>> upstream/main
