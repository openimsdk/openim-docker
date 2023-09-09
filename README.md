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
# Choose chat version and server version https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/images.md, eg: main, release-v*.*
export CHAT_BRANCH="main"   # Set chat version, default is release-v3.3 (unstable)
export SERVER_BRANCH="main" # Set server version, default is release-v3.3 (unstable)
# ...... other environment variables
# MONGO_USERNAME: Set MongoDB username
# MONGO_PASSWORD: Set MongoDB password
# MONGO_DATABASE: Set MongoDB database name
# MINIO_ENDPOINT: Set MinIO service address
# API_URL: In a local network environment, set OpenIM Server API address
export API_URL="http://127.0.0.1:10002"
```

These are just a few common configuration options. If you don't need them, you can read through our [config center instructions](https://github.com/openimsdk/open-im-server/blob/main/docs/contrib/environment.md).

Render the required configuration via './scripts/init-config.sh 'or' make init '. It can be modified directly https://github.com/openimsdk/openim-docker/blob/main/scripts/install/environment.sh or set linux environment variables. For example, above `PASSWORD` and `USER`. The latter method works only on the current terminal

 

**One-click Deployment:**

```bash
git clone https://github.com/openim-sigs/openim-docker openim/openim-docker && export openim=$(pwd)/openim && cd $openim/openim-docker && ./scripts/init-config.sh && docker compose up -d
```

**Troubleshooting:**

Common issues are documented in [FAQ.md](https://github.com/OpenIMSDK/openim-docker/blob/main/FAQ.md). If you encounter any issues, you can refer to this document.

It's also possible to find [issues](https://github.com/OpenIMSDK/openim-docker/issues) that have been encountered before, if not, please provide us with an [issue description](https://github.com/openimsdk/openim-docker/issues/new/choose)



**Modify Configuration Files:**

There are three ways to modify the configuration files:

1. Recommended: Use environment variables (as mentioned above).

**For updating configurations:**

```bash
make init
```

1. Modify the automation script:

```bash
scripts/install/environment.sh
```

To update the configuration:

```bash
make init
```

1. Modify the `config.yaml` and `.env` files (but note that reusing `make init` to generate configurations will overwrite them).

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
