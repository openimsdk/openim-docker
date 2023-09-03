# OpenIM Docker Deployment

OpenIM Docker offers a stable solution for building and deploying OpenIM. There are many deployment options available, and the process is simplified using Docker and Docker Compose.

<p align="center">     <a href="./README.md"><b> English </b></a> •     <a href="./README_zh-CN.md"><b> 简体中文 </b></a> </p>

## Directory Structure

```
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

- `build/`: For building Docker images.
- `openim-server/`: For deploying openim-server.
- `openim-chat/`: For deploying openim-chat.
- `env/`: Contains environment variable files for Docker-compose. (Not needed for now)
- `example/`: Contains various Docker-compose examples, offering feature deployment schemes.

### Project Structure Explanation

- For changes to `openim-server` and `openim-chat`, please contribute separately at https://github.com/OpenIMSDK/Open-IM-Server/ and https://github.com/OpenIMSDK/chat.
- To synchronize scripts and configuration files of the two projects, we use automation tools. Just ensure that the files are synchronized with the original repository.
- For environment variable files and Docker-compose examples, make changes under `env/` and `example/`.

# Docker Compose 常见问题及解决方法

[toc]

## 1. 配置文件管理

在使用 OpenIM 的新版本（version >= 3.2.0）时，对配置文件的管理变得尤为重要。配置文件不仅为应用程序提供了必要的运行参数，还确保了系统运行的稳定性和可靠性。

### 1.1 生成配置文件

为了生成配置文件，OpenIM 提供了两种方式。一种是通过 `Makefile`，另一种是直接执行初始化脚本。

#### 使用 Makefile

对于熟悉 Makefile 的开发者，这是一个快捷且友好的方式。只需要在项目根目录执行以下命令：

```bash
make init
```

这会触发 `Makefile` 中的相关命令，最终生成所需的配置文件。

#### 使用初始化脚本

对于不想使用 `Makefile` 的用户，或者那些对其不太熟悉的人，我们提供了一个更直接的方式来生成配置文件。只需执行以下命令：

```bash
./scripts/init-config.sh
```

无论选择哪种方式，都会生成相同的配置文件。因此，可以根据个人喜好和环境来选择最适合自己的方法。

### 1.2 验证配置文件

生成配置文件后，最好对其进行验证，确保它能够满足应用程序的要求。验证的标志如下：

[日志输出内容...]

这些日志输出确保了配置文件已正确生成并可以被 OpenIM 服务正确解析。

### 1.3 配置文件的修改与管理

配置文件通常不需要频繁修改。但在某些情况下，例如当更改数据库连接参数或修改其他关键参数时，可能需要调整它。

建议通过环境变量的方式去配置和管理 ~

建议在修改配置文件之前，先备份原始文件。这样，如果出现问题，可以很容易地回滚到原始状态。

此外，对于在团队中使用 OpenIM 的情况，建议使用版本控制系统（如 Git）来管理配置文件。这可以确保团队成员都使用相同的配置，并能够跟踪任何修改。



## 2. Docker Compose 不支持 gateway

Docker Compose 是一个工具，用于定义和运行多容器的 Docker 应用程序。有时，你可能会遇到不支持特定功能，如 `gateway` 的问题。下面是详细的指南，包括问题、原因、解决方法和调试技巧。

### 2.1 问题描述

当使用 Docker Compose 文件定义网络时，尝试设置 gateway 参数可能会出现以下错误：

```
ERROR: The Compose file './docker-compose.yaml' is invalid because:
networks.openim-server.ipam.config value Additional properties are not allowed ('gateway' was unexpected)
```

这意味着 Docker Compose 不支持你试图定义的 `gateway` 参数。

### 2.2 原因

Docker Compose 的某些版本可能不支持特定的网络属性，如 `gateway`。这可能是由于 Docker Compose 的版本过旧或配置文件语法有误。

### 2.3 解决方法

#### 检查版本

首先，确保你的 Docker Compose 版本是最新的。要查看版本，执行以下命令：

```
docker-compose version
```

如果你的版本过旧，建议更新到最新版本。

#### 校验配置文件

验证 `docker-compose.yaml` 文件的语法是否正确。确保缩进、空格和格式都是正确的。可以使用在线 YAML 校验工具进行检查。

#### 使用其他网络配置

如果不需要特定的 `gateway` 设置，可以考虑删除或更改它。另外，如果你只是想要为容器定义一个静态 IP，可以使用 `ipv4_address` 属性。

### 2.4 调试与帮助

如果上述方法仍不能解决问题，以下是一些调试技巧和帮助指南：

#### 查看 Docker 文档

Docker 官方文档是一个宝贵的资源。确保你已经阅读了关于 [Docker Compose 文件的官方文档](https://docs.docker.com/compose/compose-file/)。

#### 使用更详细的日志

运行 `docker-compose` 时使用 `-v` 参数可以获得更详细的日志输出，这可能有助于识别问题的根源。

```
docker-compose -v up
```

#### 访问社区和论坛

Docker 有一个非常活跃的社区。如果你遇到问题，可以考虑在 [Docker 论坛](https://forums.docker.com/) 发布问题或搜索其他用户是否有相同的问题。



## 3. MySQL 连接失败

在使用 Docker 运行的应用程序中，MySQL 连接失败是一个常见的问题。该问题可能由多种原因引起，以下是一份全面的指南，旨在帮助你解决 MySQL 连接问题。

### 3.1 问题描述

当你的应用程序或服务尝试连接到 MySQL 容器时，可能会遇到以下错误：

```
[error] failed to initialize database, got error dial tcp 172.28.0.2:13306: connect: connection refused
```

这意味着你的应用程序无法建立到 MySQL 的连接。

### 3.2 常见原因与解决方案

#### MySQL 容器未启动

**检查方法:** 使用 `docker ps` 命令查看所有正在运行的容器。

**解决方法:** 如果你没有看到 MySQL 容器，请确保它已经启动。

```
docker-compose up -d mysql
```

#### 错误的 MySQL 地址或端口

**检查方法:** 检查应用程序的配置文件，确保 MySQL 的地址和端口设置正确。

**解决方法:** 如果使用了默认的 Docker Compose 设置，地址应为 `mysql` (容器名) 并且默认端口是 `3306`。

#### MySQL 用户权限问题

**检查方法:** 登录 MySQL 并检查用户权限。

**解决方法:** 确保连接的 MySQL 用户具有足够的权限。你可以考虑为应用程序创建一个专用用户并授予必要的权限。

#### MySQL 的 `bind-address`

**检查方法:** 如果 MySQL 仅绑定到 `127.0.0.1`，则只能从容器内部访问它。

**解决方法:** 更改 MySQL 的 `bind-address` 到 `0.0.0.0` 以允许外部连接。

#### 网络问题

**检查方法:** 使用 `docker network inspect` 检查容器的网络设置。

**解决方法:** 确保应用程序和 MySQL 容器在同一网络上。

### 3.3 调试方法与帮助

#### 查看 MySQL 日志

查看 MySQL 容器的日志可能会提供有关连接失败的更多信息。

```
docker logs <mysql_container_name>
```

#### 使用 MySQL 客户端进行测试

使用 MySQL 客户端直接连接到数据库可以帮助定位问题。

```
mysql -h <mysql_container_ip> -P 3306 -u <username> -p
```

#### 检查防火墙设置

确保没有防火墙或网络策略阻止应用程序与 MySQL 容器之间的通信。

### 3.4 其他可能的问题

#### 使用旧版本的 Docker 或 Docker Compose

确保你使用的是 Docker 和 Docker Compose 的最新版本。旧版本可能存在已知的连接问题。

#### 数据库没有初始化

如果这是 MySQL 容器的首次启动，可能需要一些时间来初始化数据库。

#### 容器间的时间同步问题

确保所有容器的系统时间都是同步的，因为时间不同步可能会导致认证问题。





## 4. Kafka 错误

Kafka 是一个流行的消息传递系统，但与所有技术一样，你可能会遇到一些常见问题。以下是详细的指南，提供了关于 Kafka 错误的信息，以及如何解决这些问题。

### 4.1 问题描述

当尝试启动或与 Kafka 交互时，你可能会遇到以下错误：

```
Starting Kafka failed: kafka doesn't contain topic:offlineMsgToMongoMysql: 6000 ComponentStartErr
```

此错误表明 Kafka 服务没有预期的主题或组件没有正确启动。

### 4.2 常见原因与解决方案

#### Kafka 未运行或启动失败

**检查方法:** 使用 `docker ps` 或 `docker-compose ps` 查看 Kafka 容器的状态。

**解决方法:** 如果 Kafka 未运行，请确保使用正确的命令启动它。例如，使用 `docker-compose up -d kafka`。

#### 主题不存在

**检查方法:** 使用 Kafka 的命令行工具查看所有可用的主题。

**解决方法:** 如果主题不存在，你需要创建它。你可以使用 `kafka-topics.sh` 脚本来创建新主题。

#### Kafka 配置问题

**检查方法:** 检查 Kafka 的配置文件，确保所有的配置项都设置正确。

**解决方法:** 根据你的需求调整 Kafka 的配置并重新启动服务。

### 4.3 调试方法与帮助

#### 查看 Kafka 日志

Kafka 容器的日志可能包含有用的信息。你可以使用以下命令查看它：

```
docker logs <kafka_container_name>
```

#### 使用 Kafka 命令行工具

Kafka 附带了一系列的命令行工具，这些工具可以帮助你管理和调试服务。确保你熟悉如何使用它们，特别是 `kafka-topics.sh` 和 `kafka-console-producer/consumer.sh`。

#### 确保 Zookeeper 正常运行

Kafka 依赖于 Zookeeper，所以确保 Zookeeper 也在正常运行。

### 4.4 其他可能的问题

#### 网络问题

确保 Kafka 和其他服务（如 Zookeeper）都在同一个 Docker 网络上，并且容器之间可以相互通信。

#### 存储问题

确保 Kafka 容器有足够的磁盘空间。如果磁盘空间不足，Kafka 可能会遇到问题。

#### 版本不兼容

确保你使用的 Kafka 客户端版本与 Kafka 服务版本兼容。



## 5. 网络错误

在使用 Docker 和容器化的应用程序时，网络问题可能是最常见的问题之一。从 IP 地址冲突到容器间连接失败，网络错误的原因和解决方案是多种多样的。

### 5.1 常见的网络错误

#### 错误 1: Invalid address

**问题描述:**

```
Error response from daemon: Invalid address 172.28.0.12: It does not belong to any of this network's subnets
```

这个错误通常意味着你试图给一个容器分配一个不属于 Docker 网络子网的 IP 地址。

**解决方案:**

1. 使用 `docker network inspect [network_name]` 检查网络的子网范围。
2. 确保为容器分配的 IP 地址在这个范围内。

#### 错误 2: Pool overlaps

**问题描述:**

```
failed to create network example_openim-server: Error response from daemon: Pool overlaps with other one on this address space
```

这意味着你试图创建一个与现有网络有重叠 IP 地址范围的新网络。

**解决方案:**

1. 更改新网络的 IP 地址范围。
2. 或者删除现有的重叠网络（在确保其不再需要的情况下）。

### 5.2 调试网络问题的方法

#### 1. `docker network ls`

列出所有的 Docker 网络，这样你可以看到是否有任何预期之外的网络或重复的网络。

#### 2. `docker network inspect [network_name]`

检查特定的 Docker 网络配置，特别是 IP 地址范围和连接到该网络的容器。

#### 3. `ping` 和 `curl`

从一个容器内部 ping 另一个容器的 IP 地址或使用 curl 尝试连接到另一个容器的服务。这可以帮助你确定网络连接问题的位置。

#### 4. 查看容器日志

使用 `docker logs [container_name]` 检查容器的日志，可能会有一些与网络相关的错误或警告。

### 5.3 其他可能的网络问题

#### DNS 解析问题

容器可能无法解析其他容器的域名。确保你的容器使用了正确的 DNS 设置，并且可以访问 DNS 服务器。

#### 端口未暴露或绑定

如果你的服务在容器内部运行，但无法从外部访问，确保你已经在 Dockerfile 中使用 `EXPOSE` 指令暴露了正确的端口，并在启动容器时绑定了这些端口。

#### 防火墙或安全组

确保任何外部的防火墙或安全组都允许必要的流量通过。



## 6. 其他问题的排查

当你使用开源项目或任何其他软件时，难免会遇到一些不可预测的问题。如何优雅地排查和解决问题是每个开发者和用户都应该掌握的重要技能。

### 6.1 明确问题描述

首先，要确保你真正理解了问题。随意地尝试各种解决方案，而不首先定义问题是一种时间浪费的策略。

- **收集错误日志**：几乎所有的应用程序或软件都有日志记录功能。始终查看日志以获取有关问题的更多详细信息。
- **重现问题**：在尝试解决问题之前，了解如何重现它是很重要的。如果一个问题不能被可靠地重现，它很难被解决。

### 6.2 分隔排除法

一种有效的故障排除策略是分隔和排除。这意味着你将系统拆分为不同的部分，并单独测试每一部分，以确定问题出在哪里。

- **单独运行组件**：例如，如果你在使用多个服务的系统中遇到问题，尝试单独运行每个服务来看哪个服务出了问题。
- **使用最小化的配置**：如果可能，使用最基本的配置启动应用程序或服务，然后逐渐添加更多的配置选项，直到你可以重现问题。

### 6.3 使用开源社区资源

- **查找已知的问题**：大多数开源项目都有一个issue跟踪器，如GitHub的Issues。首先查看那里，看看你的问题是否已经被其他人报告过。
- **提问的技巧**：如果你决定询问社区，确保你的问题是明确的、具体的，并附带足够的详细信息。包括错误消息、你的环境信息和你已经尝试过的解决方案。

### 6.4 使用调试工具

- **代码调试**：如果你对代码感到舒适，使用调试器来逐步执行代码可以帮助你更快地找到问题。
- **网络调试**：对于网络问题，工具如 `ping`, `traceroute`, `netstat` 和 `wireshark` 可以非常有用。

### 6.5 发现问题后的步骤

一旦你找到了问题，以下是一些建议的下一步：

- **查找现有的修复程序**：可能有人已经为你的问题找到了一个修复程序或解决方案。
- **修复问题**：如果你有技能和资源，你可以尝试自己修复问题。
- **报告问题**：即使你自己解决了问题，也要向开源社区报告它，这样其他人可以从你的发现中受益。

### 6.6 保持耐心

最后但同样重要的是，保持耐心和开放的心态。遇到问题是软件开发的一个普遍现象，学习如何有效地解决它们可以使你成为一个更好的开发者。

总的来说，优雅地排查和解决问题需要时间、实践和耐心，但随着时间的推移，你将发展出自己的策略和技术，使这个过程变得更加容易和直观。





# Common Docker Compose Questions and Solutions

[toc]

## 1. Configuration File Management

When using the new version of OpenIM (version >= 3.2.0), managing configuration files becomes crucial. Configuration files not only provide the necessary runtime parameters for applications but also ensure the stability and reliability of system operation.

### 1.1 Generating Configuration Files

OpenIM offers two methods to generate configuration files. One is via `Makefile` and the other is by directly executing the initialization script.

#### Using Makefile

For developers familiar with Makefile, this is a quick and user-friendly method. Just execute the following command in the project root directory:

```
make init
```

This triggers the relevant commands in `Makefile`, ultimately generating the required configuration files.

#### Using Initialization Script

For those who don't want to use `Makefile` or aren't familiar with it, we offer a more direct way to generate the configuration files. Just execute:

```
./scripts/init-config.sh
```

Whichever method you choose, the same configuration files will be generated. Thus, pick the method that suits your preference and environment.

### 1.2 Verify Configuration File

After generating the configuration file, it's best to validate it to ensure it meets the application's requirements. Signs of validation include:

[Log output...]

These logs ensure that the configuration file has been correctly generated and can be properly parsed by the OpenIM service.

### 1.3 Modifying and Managing the Configuration File

Configuration files typically don't need frequent modifications. However, in some cases, such as changing database connection parameters or adjusting other critical parameters, adjustments might be necessary.

It's recommended to configure and manage using environment variables ~

Before modifying the configuration file, it's advised to back up the original file. This way, if issues arise, it's easy to roll back to the original state.

Additionally, for teams using OpenIM, it's recommended to use version control systems (like Git) to manage configuration files. This ensures team members use the same configurations and can track any changes.

## 2. Docker Compose Doesn't Support `gateway`

Docker Compose is a tool for defining and running multi-container Docker applications. Sometimes, you might encounter issues with unsupported features, such as `gateway`. Here's a detailed guide, including the problem, reasons, solutions, and debugging tips.

### 2.1 Problem Description

When using a Docker Compose file to define a network, attempting to set the gateway parameter might result in the following error:

```bash
ERROR: The Compose file './docker-compose.yaml' is invalid because:
networks.openim-server.ipam.config value Additional properties are not allowed ('gateway' was unexpected)
```

This indicates that Docker Compose doesn't support the `gateway` parameter you're trying to define.

### 2.2 Reason

Some versions of Docker Compose might not support specific network attributes, like `gateway`. This might be due to an outdated version of Docker Compose or syntax errors in the configuration file.

### 2.3 Solution

#### Check the Version

First, ensure your Docker Compose version is the latest. To check the version, run:

```
docker-compose version
```

If you're using an older version, consider updating to the latest version.

#### Validate Configuration File

Verify the syntax of the `docker-compose.yaml` file. Ensure correct indentation, spacing, and formatting. You can use online YAML validation tools for checking.

#### Use Different Network Configurations

If the specific `gateway` setting isn't necessary, consider deleting or changing it. Also, if you want to define a static IP for a container, you can use the `ipv4_address` attribute.

### 2.4 Debugging and Help

If the above solutions don't resolve the issue, here are some debugging tips and guides:

#### Check Docker Documentation

The official Docker documentation is a valuable resource. Ensure you've read the [official documentation on Docker Compose files](https://docs.docker.com/compose/compose-file/).

#### Use More Detailed Logs

Using the `-v` parameter when running `docker-compose` can give more detailed log outputs, which might help identify the root cause.

```bash
docker-compose -v up
```

#### Access the Community and Forums

Docker has a very active community. If you face issues, consider posting your problems on the [Docker forum](https://forums.docker.com/) or search if other users have the same issue.

## 3. MySQL Connection Failure

In applications running on Docker, failing to connect to MySQL is a common issue. This problem can arise for various reasons; here's a comprehensive guide to help you resolve MySQL connection issues.

### 3.1 Problem Description

When your application or service tries to connect to the MySQL container, you might encounter the following error:

```bash
[error] failed to initialize database, got error dial tcp 172.28.0.2:13306: connect: connection refused
```

This indicates that your application can't establish a connection to MySQL.

### 3.2 Common Causes and Solutions

#### MySQL Container Not Running

**Check:** Use the `docker ps` command to view all running containers.

**Solution:** If you don't see the MySQL container, ensure it's started.

```bash
docker-compose up -d mysql
```

#### Wrong MySQL Address or Port

**Check:** Review the application's configuration file and ensure the MySQL address and port settings are correct.

**Solution:** If using the default Docker Compose settings, the address should be `mysql` (container name), and the default port is `3306`.

#### MySQL User Permissions Issue

**Check:** Log into MySQL and inspect user permissions.

**Solution:** Ensure the connecting MySQL user has sufficient permissions. Consider creating a dedicated user for the application and granting necessary permissions.

#### MySQL's `bind-address`

**Check:** If MySQL is bound only to `127.0.0.1`, it can only be accessed from inside the container.

**Solution:** Change MySQL's `bind-address` to `0.0.0.0` to allow external connections.

#### Network Issues

**Check:** Use `docker network inspect` to check the network settings of the container.

**Solution:** Ensure the application and MySQL containers are on the same network.

### 3.3 Debugging Methods and Help

#### View MySQL Logs

Viewing the logs of the MySQL container might provide more information about connection failures.

```bash
docker logs <mysql_container_name>
```

#### Test with MySQL Client

Directly connecting to the database using the MySQL client can help pinpoint the issue.

```bash
mysql -h <mysql_container_ip> -P 3306 -u <username> -p
```

#### Check Firewall Settings

Ensure no firewall or network policies are blocking communication between the application and the MySQL container.

### 3.4 Other Possible Issues

#### Using Older Versions of Docker or Docker Compose

Ensure you're using the latest versions of Docker and Docker Compose. Older versions might have known connection issues.

#### Database Not Initialized

If it's the MySQL container's first start, it might need some time to initialize the database.

#### Time Synchronization Issues Between Containers

Ensure all containers' system times are synchronized, as unsynchronized times might lead to authentication issues.



## 4. Kafka Errors

Kafka is a popular messaging system, but like all technologies, you might encounter some common issues. Here's a detailed guide that provides information on Kafka errors and how to resolve them.

### 4.1 Problem Description

When trying to start or interact with Kafka, you might come across the following error:

```bash
Starting Kafka failed: kafka doesn't contain topic:offlineMsgToMongoMysql: 6000 ComponentStartErr
```

This error suggests that the Kafka service lacks the expected topic, or the component hasn't started correctly.

### 4.2 Common Causes and Solutions

#### Kafka Not Running or Failed to Start

**Check:** Use `docker ps` or `docker-compose ps` to see the status of the Kafka container.

**Solution:** If Kafka isn't running, ensure you start it using the correct command, such as `docker-compose up -d kafka`.

#### Topic Doesn't Exist

**Check:** Use Kafka's command-line tools to view all available topics.

**Solution:** If the topic doesn't exist, you'll need to create it. The `kafka-topics.sh` script can be used to create a new topic.

#### Kafka Configuration Issues

**Check:** Review Kafka's configuration file to ensure all configurations are correctly set.

**Solution:** Adjust the Kafka configuration based on your needs and restart the service.

### 4.3 Debugging Methods and Help

#### View Kafka Logs

Logs from the Kafka container might contain useful information. They can be viewed using:

```
docker logs <kafka_container_name>
```

#### Use Kafka Command-line Tools

Kafka comes with a series of command-line tools that can help manage and debug the service. Ensure you're familiar with how to use them, especially `kafka-topics.sh` and `kafka-console-producer/consumer.sh`.

#### Ensure Zookeeper Is Running Properly

Kafka relies on Zookeeper, so make sure Zookeeper is running correctly.

### 4.4 Other Possible Issues

#### Network Issues

Ensure that Kafka and other services (like Zookeeper) are on the same Docker network and can communicate with each other.

#### Storage Issues

Ensure the Kafka container has enough disk space. If there's insufficient disk space, Kafka might encounter issues.

#### Version Incompatibility

Ensure that the Kafka client version you're using is compatible with the Kafka server version.

## 5. Network Errors

When using Docker and containerized applications, network issues might be one of the most common challenges. From IP address conflicts to connection failures between containers, reasons for and solutions to network errors can be diverse.

### 5.1 Common Network Errors

#### Error 1: Invalid address

**Problem Description:**

```
Error response from daemon: Invalid address 172.28.0.12: It does not belong to any of this network's subnets
```

This error typically suggests you're attempting to assign an IP address to a container that doesn't belong to any of Docker's network subnets.

**Solution:**

1. Use `docker network inspect [network_name]` to check the subnet range of the network.
2. Ensure the IP address you're assigning to the container lies within this range.

#### Error 2: Pool overlaps

**Problem Description:**

```
failed to create network example_openim-server: Error response from daemon: Pool overlaps with another one on this address space
```

This implies you're trying to create a new network with an IP address range that overlaps with an existing network.

**Solution:**

1. Change the IP address range of the new network.
2. Or, delete the existing overlapping network (after ensuring it's no longer needed).

### 5.2 Methods to Debug Network Issues

#### 1. `docker network ls`

List all Docker networks, allowing you to see if there are unexpected or duplicate networks.

#### 2. `docker network inspect [network_name]`

Inspect a specific Docker network's configuration, especially the IP address range and the containers connected to that network.

#### 3. `ping` and `curl`

Ping another container's IP address from inside one container or use curl to attempt a connection to another container's service. This can help pinpoint the location of the network connection issue.

#### 4. View container logs

Use `docker logs [container_name]` to check the container's logs, which might have some network-related errors or warnings.

### 5.3 Other Potential Network Issues

#### DNS Resolution Issues

Containers might not be able to resolve the domain names of other containers. Ensure your containers are using the correct DNS settings and can access the DNS server.

#### Ports Not Exposed or Bound

If your service runs inside a container but can't be accessed externally, ensure you've exposed the right ports in the Dockerfile using the `EXPOSE` directive and bound these ports when starting the container.

#### Firewalls or Security Groups

Ensure that any external firewalls or security groups allow the necessary traffic through.

## 6. Troubleshooting Other Issues

When using open-source projects or any other software, you'll inevitably encounter unpredictable issues. How to elegantly troubleshoot and solve problems is an essential skill every developer and user should possess.

### 6.1 Clearly Define the Issue

First, ensure you truly understand the problem. Randomly trying various solutions without first defining the problem is a waste of time.

- **Collect error logs**: Almost all applications or software have logging features. Always check the logs for more details about the issue.
- **Reproduce the issue**: Knowing how to reproduce it before trying to solve it is crucial. If a problem can't be reliably reproduced, it's hard to solve.

### 6.2 Divide and Conquer

A productive troubleshooting strategy is to divide and conquer. This means breaking the system into different parts and testing each separately to determine where the problem lies.

- **Run components separately**: For instance, if you face issues in a system using multiple services, try running each service separately to see which one has the problem.
- **Use minimal configurations**: If possible, start the application or service with the most basic configuration. Then, gradually add more configuration options until you can reproduce the issue.

### 6.3 Use Open Source Community Resources

- **Look for known issues**: Most open-source projects have an issue tracker, like GitHub's Issues. First, check there to see if someone else has already reported your issue.
- **Art of asking**: If you decide to ask the community, ensure your question is clear, specific, and comes with enough detail. Include error messages, your environment details, and solutions you've already tried.

### 6.4 Use Debugging Tools

- **Code debugging**: If you're comfortable with code, using a debugger to step through the code can help you find the problem faster.
- **Network debugging**: For network issues, tools like `ping`, `traceroute`, `netstat`, and `wireshark` can be very useful.

### 6.5 Steps After Identifying the Issue

Once you've identified the issue, here are some recommended next steps:

- **Look for existing fixes**: Someone might have already found a fix or solution for your issue.
- **Fix the problem**: If you have the skills and resources, try fixing the problem yourself.
- **Report the issue**: Even if you've solved the problem yourself, report it to the open-source community,

















## OpenIM Docker Usage Guide

#### 1. Obtain the Image

You can get the Docker image from the following three sources:

- [GitHub Packages](https://github.com/orgs/OpenIMSDK/packages?repo_name=Open-IM-Server)
- Alibaba Cloud
- Docker Hub

To ensure you get the latest version of the image, please refer to the following documents:

- [OpenIM Version Design](https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/version.md)
- [OpenIM Image Strategy](https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/images.md)



#### 2. Using Docker-compose

**Setting Environment Variables**

> You can set environment variables or use the default ones based on your needs. Configuration options can be found at https://github.com/OpenIMSDK/Open-IM-Server/blob/main/scripts/install/environment.sh

```
export PASSWORD="openIM123" # Set password, default is openIM123
export USER="root" # Set username, default is root
# Choose chat version and server version https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/images.md, eg: main, release-v*.*
export CHAT_BRANCH="main"   # Set chat version, default is main (unstable)
export SERVER_BRANCH="main" # Set server version, default is main (unstable)
# ...... other environment variables
# MONGO_USERNAME: Set MongoDB username
# MONGO_PASSWORD: Set MongoDB password
# MONGO_DATABASE: Set MongoDB database name
# MINIO_ENDPOINT: Set MinIO service address
# API_URL: In a local network environment, set OpenIM Server API address
export API_URL="http://127.0.0.1:10002"
```

**One-click Deployment:**

```
git clone -b feat/test https://github.com/openim-sigs/openim-docker openim/openim-docker && export openim=$(pwd)/openim && cd $openim/openim-docker  && ./scripts/init-config.sh && docker compose up -d
```

**Troubleshooting:**

Common issues are documented in [FAQ.md](https://github.com/OpenIMSDK/openim-docker/blob/main/FAQ-CN.md). If you encounter any issues, you can refer to this document.

**Modify Configuration Files:**

There are three ways to modify the configuration files:

1. Recommended: Use environment variables (as mentioned above).

**For updating configurations:**

```
make init
```

1. Modify the automation script:

```
scripts/install/environment.sh
```

To update the configuration:

```
make init
```

1. Modify the `config.yaml` and `.env` files (but note that reusing `make init` to generate configurations will overwrite them).

**Default Startup Selection:**

```
docker-compose up -d
```

> **Note**: If image fetching is slow, you can choose the image from Alibaba Cloud. For both openim-server and openim-chat, they are interchangeable. You only need to modify the image in the docker-compose.yml file.

```
# image: ghcr.io/openimsdk/openim-server:latest
image: registry.cn-hangzhou.aliyuncs.com/openimsdk/openim-server:latest
# image: openim/openim-server:latest
```

### Custom Startup

Based on your requirements, choose the appropriate Docker-compose file to start:

- **Basic Environment Dependency**:

  ```bash
  docker-compose -f example/basic-openim-server-dependency.yml up -d
  ```

- **Only OpenIM Server**:

  ```bash
  docker-compose -f example/only-openim-server.yml up -d
  ```

- **Both OpenIM Server and Chat**:

  ```bash
  docker-compose -f example/full-openim-server-and-chat.yml up -d
  ```

**Mounting:**

In the Docker Compose file, the "volumes" keyword defines named volumes. Named volumes are a storage concept in Docker that allows you to create persistent storage for a container. This means that even if the container is deleted, the data stored on that volume will not be lost.

For easy management, we use named volumes. These volumes have the same name as the services. For instance, the openim-server service uses the openim-server named volume, and the openim-chat service uses the openim-chat named volume.

View all volumes:

```bash
docker volume ls
```

View a specific volume:

```bash
docker volume inspect <volume-name>
```

Delete a named volume:

```bash
docker volume rm <volume-name>
```

Delete unused volumes:

```bash
docker volume prune
```

**Customizing Your Image**

For easy customization, we provide basic images of various distributions and architectures. The repository address is https://github.com/OpenIMSDK/openim-base-image, for easy customization.

**Test Running Status**

To see if all services have started, you can use:

```bash
docker-compose ps
```

If you find a container that hasn't started, you can view the logs of the specific service to find out the reason. For example, to view the logs of OpenIM Server:

```bash
docker-compose logs openim-server
```

**Stop**

To stop all services running by Docker-compose:

```bash
docker-compose down
```

If you used a specific `docker-compose` file, make sure to specify it in the `down` command as well.

#### 3. Tips

Ensure your Docker and Docker Compose are up-to-date to guarantee the best compatibility and performance.

## Contribution

- Fork this repository to your GitHub account.
- Clone the forked repository to your local environment.
- Create a new branch and name it after your contribution.
- Make changes where needed.
- Commit your changes and push them to your fork.
- Create a new Pull Request on GitHub.

We encourage community contributions and improvements to this project. For the specific contribution process, please refer to [CONTRIBUTING.md](https://chat.openai.com/CONTRIBUTING.md).

## License

This project uses the MIT license. For details, please refer to [LICENSE](https://chat.openai.com/LICENSE).
