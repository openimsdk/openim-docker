# OpenIM Docker Deployment Guide

Welcome to the world of OpenIM Docker! To make it easier for you to deploy OpenIM, we offer a stable and convenient Docker solution. With just Docker and Docker Compose, you can easily launch or manage the entire service.

## A Glimpse at the Project Structure

```bashOpenIM Docker Deployment
│
├── 📁 **build/**
│   ├── 📄 Dockerfile-server
│   └── 📄 Dockerfile-chat
│
├── 📁 **openim-server/**
│   ├── 📄 docker-compose.yml
│   └── 📁 **configs/**
│       ├── 📄 server-config.yaml
│       └── 📄 other-config.yaml
│
├── 📁 **openim-chat/**
│   ├── 📄 docker-compose.yml
│   └── 📁 **configs/**
│       ├── 📄 chat-config.yaml
│       └── 📄 other-config.yaml
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

- `build/`: Files required for Docker builds reside here.
- `openim-server/`: Everything you need to deploy the OpenIM service can be found here.
- `openim-chat/`: This is where the OpenIM chat service is deployed.
- `env/`: The home of environment variables that Docker-compose needs.
- `example/`: Want real Docker-compose examples? Look no further!

Next, we'll delve into the operational guide detailing how to use these files.

### How to Use OpenIM Docker

#### 1. Acquire the Image

First, choose one of the following platforms to download the Docker image:

- [GitHub Packages](https://github.com/orgs/OpenIMSDK/packages?repo_name=Open-IM-Server)
- Alibaba Cloud
- Docker Hub

To ensure that you download the latest image, please refer to these two documents:

- [openim version introduction](https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/version.md)
- [openim image selection guide](https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/images.md)

#### 2. Launch the Service with Docker-compose

**One-click launch:**

```bash
docker-compose up -d
```

**Customized launches based on needs:**

- **Launch basic environment only**:

  ```
  bashCopy code
  docker-compose -f basic-openim-server-dependency.yml up -d
  ```

- **Launch OpenIM Server only**:

  ```
  bashCopy code
  docker-compose -f only-openim-server.yml up -d
  ```

- **Launch both OpenIM Server and chat functionality**:

  ```
  bashCopy code
  docker-compose -f full-openim-server-and-chat.yml up -d
  ```

**Check operational status**

To confirm all services are up and running:

```bash
docker-compose ps
```

If a particular service isn't running, you can inspect its logs, for instance:

```bash
docker-compose logs openim-server
```

**Shut down the service**

To stop all services run by Docker-compose:

```bash
docker-compose down
```

When using a specific `docker-compose` file, remember to specify it in the `down` command.

#### 3. A Little Tip

Please ensure that both your Docker and Docker Compose are updated to the latest versions for the best compatibility and performance.

## Contribute Your Strength

If you're interested in our project, we warmly welcome you to participate and contribute to it! Please refer to [CONTRIBUTING.md](https://github.com/openim-sigs/openim-docker/tree/main/CONTRIBUTING.md) for more details.

## License

This project is licensed under the MIT license. For specific content, please check [LICENSE](https://github.com/openim-sigs/openim-docker/tree/main/LICENSE).
