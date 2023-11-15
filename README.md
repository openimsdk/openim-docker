# OpenIM Docker Deployment

- [OpenIM Docker Deployment](#openim-docker-deployment)
  - [Directory Structure](#directory-structure)
    - [Project Structure Explanation](#project-structure-explanation)
  - [OpenIM Docker Usage Guide](#openim-docker-usage-guide)
      - [1. Obtain the Image](#1-obtain-the-image)
      - [2. Using Docker-compose](#2-using-docker-compose)
    - [One-click Deployment:](#one-click-deployment)
      - [Troubleshooting:](#troubleshooting)
      - [Modify Configuration Files:](#modify-configuration-files)
        - [1. Recommended: Use environment variables (as mentioned above).](#1-recommended-use-environment-variables-as-mentioned-above)
        - [2. Modify the automation script:](#2-modify-the-automation-script)
        - [3. Modify the `config.yaml` and `.env` files (but note that reusing `make init` to generate configurations will overwrite them).](#3-modify-the-configyaml-and-env-files-but-note-that-reusing-make-init-to-generate-configurations-will-overwrite-them)
  - [OpenIM Data Storage Architecture Guide](#openim-data-storage-architecture-guide)
    - [**II. OpenIM Default Data Storage Structure**](#ii-openim-default-data-storage-structure)
    - [III. Customizing OpenIM's Data Storage](#iii-customizing-openims-data-storage)
    - [IV. Docker Volume Storage: An Advanced Approach](#iv-docker-volume-storage-an-advanced-approach)
    - [Custom Startup](#custom-startup)
      - [3. Tips](#3-tips)
  - [Contribution](#contribution)
    - [Conclusion](#conclusion)
  - [License](#license)


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

```bash
export PASSWORD="openIM123" # Set password, default is openIM123
export USER="root" # Set username, default is root
# Choose chat version and server version https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/images.md, eg: release-v*.*
export CHAT_BRANCH="release-v1.4"   # Set chat version, default is release-v1.4 (unstable)
export SERVER_BRANCH="release-v3.4" # Set server version, default is release-v3.4 (unstable)
# ...... other environment variables
# MONGO_USERNAME: Set MongoDB username
# MONGO_PASSWORD: Set MongoDB password
# MONGO_DATABASE: Set MongoDB database name
# MINIO_ENDPOINT: Set MinIO service address
# OPENIM_IP: In a local network environment, set OpenIM Server API address
export OPENIM_IP="127.0.0.1"
# DOCKER_BRIDGE_SUBNET: Set Docker bridge network address, default is 172.28.0.0/16
export DOCKER_BRIDGE_SUBNET=172.28.0.0/16
# For Prometheus, it is not enabled by default. To enable it
export PROMETHEUS_ENABLE=true   # Default is false
```

These are just a few common configuration options. If you don't need them, you can read through our [config center instructions](https://github.com/openimsdk/open-im-server/blob/main/docs/contrib/environment.md).

Render the required configuration via './scripts/init-config.sh 'or' make init '. It can be modified directly https://github.com/openimsdk/openim-docker/blob/main/scripts/install/environment.sh or set linux environment variables. For example, above `PASSWORD` and `USER`. The latter method works only on the current terminal


### One-click Deployment:

```bash
git clone https://github.com/openim-sigs/openim-docker openim/openim-docker && export openim=$(pwd)/openim && cd $openim/openim-docker && ./scripts/init-config.sh && docker compose up -d
```

#### Troubleshooting:

Common issues are documented in [FAQ.md](https://github.com/OpenIMSDK/openim-docker/blob/main/FAQ.md). If you encounter any issues, you can refer to this document.

It's also possible to find [issues](https://github.com/OpenIMSDK/openim-docker/issues) that have been encountered before, if not, please provide us with an [issue description](https://github.com/openimsdk/openim-docker/issues/new/choose)



#### Modify Configuration Files:

There are three ways to modify the configuration files:

##### 1. Recommended: Use environment variables (as mentioned above).

**For updating configurations:**

```bash
make init
```

##### 2. Modify the automation script:

```bash
scripts/install/environment.sh
```

To update the configuration:

```bash
make init
```

##### 3. Modify the `config.yaml` and `.env` files (but note that reusing `make init` to generate configurations will overwrite them).

**Default Startup Selection:**

```bash
docker-compose up -d
```

> **Note**: If image fetching is slow, you can choose the image from Alibaba Cloud. For both openim-server and openim-chat, they are interchangeable. You only need to modify the image in the docker-compose.yml file.

```bash
# image: ghcr.io/openimsdk/openim-server:latest
image: registry.cn-hangzhou.aliyuncs.com/openimsdk/openim-server:latest
# image: openim/openim-server:latest
```


## OpenIM Data Storage Architecture Guide

### **II. OpenIM Default Data Storage Structure**

**A. Overview**

At the heart of OpenIM's data storage are the essential components: Kafka, MNT, MongoDB, MySQL, and Redis. Each serves a distinct purpose and requires specific configuration and data directories for optimal performance.

**B. Directory Structure**

```bash
$ tree components/ -d -L 2
components/
├── kafka
│   ├── config
│   └── data
├── mnt
│   ├── config
│   └── data
├── mongodb
│   └── data
├── mysql
│   └── data
└── redis
    ├── config
    └── data
```


### III. Customizing OpenIM's Data Storage

**A. Setting a Custom Directory**

For organizations with specific storage directory requirements, OpenIM offers the flexibility to specify a custom directory. Follow these steps:

1. Define your custom directory path by setting the `DATA_DIR` environment variable:

```bash
$ export DATA_DIR="/path/to/your/directory"
```

1. Refresh OpenIM's configuration to reflect this change:

```bash
$ make init
```

**Note:** This action will update the configuration to point to the directory you've specified.


### IV. Docker Volume Storage: An Advanced Approach

**A. Why Docker Volumes?**

Docker volumes offer isolated storage solutions, optimizing data persistence and performance. When scaling services in Docker, using volumes ensures that data remains consistent and protected.

**B. Using Docker Volumes with OpenIM**

To launch OpenIM with Docker volume support, execute:

```bash
$ docker compose -f example/volume-all-server.yml up -d
```

With this setup, your OpenIM data is securely mounted onto Docker's volumes, providing added resilience and scalability.

**C. Managing Docker Volumes**

1. **Listing OpenIM Docker Volumes**

Retrieve a list of Docker volumes associated with OpenIM using:

```bash
$ docker volume ls | grep open-im-server
```

1. **Removing Data**

- For **locally mapped data**: Simply navigate to the appropriate directory and delete the desired files or folders.
- For **Docker volume data**: If you wish to clear data from Docker volumes, employ the command below:

```bash
$ docker volume ls | grep open-im-server | awk '{print $2}' | xargs docker volume rm
```

**Warning:** This action will permanently erase the data. Always ensure you have backups before proceeding.


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

### Conclusion

OpenIM's flexible storage solutions empower organizations to configure their infrastructure in alignment with their specific needs. Whether through default directories, custom paths, or Docker volumes, OpenIM guarantees efficient and secure data management.

For further assistance or advanced configurations, please consult our technical support team or refer to OpenIM's comprehensive documentation.

## License

This project uses the MIT license. For details, please refer to [LICENSE](https://chat.openai.com/LICENSE).
