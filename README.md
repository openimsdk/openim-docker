# OpenIM Docker

<!-- vscode-markdown-toc -->
* 1. [Environment Preparation](#EnvironmentPreparation)
* 2. [OpenIM Docker Usage Guide](#OpenIMDockerUsageGuide)
	* 2.1. [Project Structure Explanation](#ProjectStructureExplanation)
	* 2.2. [Obtain the Image](#ObtaintheImage)
* 3. [Repository Setup](#RepositorySetup)
* 4. [Basic Configuration](#BasicConfiguration)
* 5. [Advanced Configuration](#AdvancedConfiguration)
* 6. [Configuration Reading Priority](#ConfigurationReadingPriority)
* 7. [Starting the Service](#StartingtheService)
* 8. [Verification](#Verification)
* 9. [Directory Structure](#DirectoryStructure)
* 10. [Deploying with example](#Deployingwithexample)
* 11. [Configuration File Modification](#ConfigurationFileModification)
* 12. [Common Configurations](#CommonConfigurations)
* 13. [OpenIM Docker Upgrade](#OpenIMDockerUpgrade)
* 14. [Cleaning Up Deployment](#CleaningUpDeployment)
* 15. [Additional Information](#AdditionalInformation)
* 16. [Common Issues](#CommonIssues)
	* 16.1. [Troubleshooting](#Troubleshooting)
* 17. [Contribution](#Contribution)
	* 17.1. [Conclusion](#Conclusion)
* 18. [License](#License)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

This guide provides detailed instructions for deploying OpenIM v3.6 using Docker Compose. It covers all steps from preparing the environment to verifying the deployment.

> [!WARNING]
> Note that this guide is only applicable to OpenIM v3.6. If you want to use older versions, please refer to other `release-*` branches.

**Documentation**

+ [https://docs.openim.io/zh-Hans/guides/gettingStarted/dockerCompose](https://docs.openim.io/zh-Hans/guides/gettingStarted/dockerCompose)

##  1. <a name='EnvironmentPreparation'></a>Environment Preparation

- Ensure a clean server environment. For details, visit [OpenIM Environment Setup](https://www.notion.so/OpenIM-v3-5-Docker-Compose-9e94fc1fec3a4bc28c54db0c629301f8?pvs=21).
- Install Docker on the server.


##  2. <a name='OpenIMDockerUsageGuide'></a>OpenIM Docker Usage Guide

###  2.1. <a name='ProjectStructureExplanation'></a>Project Structure Explanation

\- For changes to `openim-server` and `openim-chat`, please contribute separately at https://github.com/OpenIMSDK/Open-IM-Server/ and https://github.com/OpenIMSDK/chat.

\- To synchronize scripts and configuration files of the two projects, we use automation tools. Just ensure that the files are synchronized with the original repository.

\- For environment variable files and Docker-compose examples, make changes under `env/` and `example/`.

###  2.2. <a name='ObtaintheImage'></a>Obtain the Image

You can get the Docker image from the following three sources:

- [GitHub Packages](https://github.com/orgs/OpenIMSDK/packages?repo_name=Open-IM-Server)
- Alibaba Cloud
- Docker Hub

To ensure you get the latest version of the image, please refer to the following documents:

- [OpenIM Version Design](https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/version.md)
- [OpenIM Image Strategy](https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/conversions/images.md)

docker deployments currently support both `linux/arm64` and `linux/amd64` architectures

###  2.3. <a name='OpenIMDockerVersion'></a>OpenIM Docker Version Management Strategy

The OpenIM Docker version management strategy is designed to maintain consistency and reliability in the deployment of OpenIM services using Docker. This strategy is focused on the synchronization of version tags between the `openim-server` and `chat` repositories and the `openim-docker` repository. The process ensures that `openim-docker` always runs the most current and stable versions of both OpenIM components.

#### Version Tagging Convention

The version tags for `openim-docker` follow a specific format that reflects the versions of both `openim-server` and `chat`. The tag format is `${OPENIM_SERVER_TAG}-${CHAT_TAG}`, where:

- `${OPENIM_SERVER_TAG}` is the latest tag from the `openim-server` repository.
- `${CHAT_TAG}` is the latest tag from the `chat` repository.

This convention allows users to easily identify the versions of both `openim-server` and `chat` that are included in each `openim-docker` release.

#### Automated Synchronization Process

An automated GitHub Actions workflow runs daily and upon specific triggers (e.g., manual dispatch or pushes to the main branch). The workflow performs the following tasks:

1. **Check for New Tags**: The workflow fetches the latest tags from both the `openim-server` and `chat` repositories. If either repository has a new tag that is not yet reflected in `openim-docker`, the workflow proceeds with the synchronization process.

2. **Update `.env.example`**: The workflow updates the `.env.example` file in the `openim-docker` repository, setting the `SERVER_IMAGE_VERSION` and `CHAT_IMAGE_VERSION` variables to the latest tags fetched in the previous step.

3. **Commit and Push Changes**: If there are changes in the `.env.example` file, the workflow commits these changes with a clear message indicating the new versions of `openim-server` and `chat`, and then pushes the commit to the `openim-docker` repository.

4. **Test the Setup**: Before proceeding to create a new version tag for `openim-docker`, the workflow initiates a test deployment using `docker-compose` to ensure the updated configuration functions correctly. This step includes running `make init` followed by `docker-compose up -d`.

5. **Create and Push New Tag**: Upon successful testing, the workflow creates a new tag for `openim-docker` using the format described above and pushes this tag to the repository. This final step concludes the synchronization process.

#### Version Management Best Practices

- **Stability and Reliability**: Before tagging new versions, extensive testing is recommended to ensure compatibility and stability across the `openim-server`, `chat`, and `openim-docker` components.
- **Clear Documentation**: Each release should be accompanied by clear documentation outlining the changes, improvements, or fixes included in the new versions of `openim-server` and `chat`.
- **Community Feedback**: Engage with the user community to gather feedback on the release process and any issues encountered with new versions. This feedback loop is vital for continuous improvement.

The OpenIM Docker version management strategy is crucial for maintaining a reliable and efficient deployment mechanism for users and developers of the OpenIM platform. By automating the synchronization of version tags and enforcing a clear version tagging convention, we ensure that `openim-docker` remains up-to-date with the latest developments in `openim-server` and `chat`.

##  3. <a name='RepositorySetup'></a>Repository Setup

Clone the repository and select the appropriate branch:

```bash
git clone -b refactor/openim-docker https://github.com/openimsdk/openim-docker openim-docker && cd openim-docker && make init
```

##  4. <a name='BasicConfiguration'></a>Basic Configuration

- Use `curl http://ifconfig.me` to determine your external service IP.
- Set your IP address in the environment:

```bash
export OPENIM_IP="Your IP Address"
```

- If you forget this step, refer to [Configuration File Modification](#Configuration File Modification) later.

##  5. <a name='AdvancedConfiguration'></a>Advanced Configuration

For complex configurations:

- Copy the `.env` file and perform necessary configurations using `make init`.
- Refer to the [OpenIM Server Environment Documentation](https://github.com/openimsdk/open-im-server/blob/main/docs/contrib/environment.md) for detailed guidance.

##  6. <a name='ConfigurationReadingPriority'></a>Configuration Reading Priority

The highest priority is values read from environment variables, followed by values in the `.env` file, and lastly, default values in the `docker-compose.yaml` file.

##  7. <a name='StartingtheService'></a>Starting the Service

- Start the OpenIM service:

```bash
docker compose up -d
```

##  8. <a name='Verification'></a>Verification

- **OpenIM Server:** Check logs with `docker compose logs -f openim-server`.
- **OpenIM Chat:** Validate logs with `docker compose logs -f openim-chat`.
- **OpenIM Web:** Visit http://127.0.0.1:11001, register, and verify sending pictures and text between accounts.
- **OpenIM Management:** Visit https://127.0.0.1:11002, use the default credentials `admin1, admin1`.

##  9. <a name='DirectoryStructure'></a>Directory Structure

```bash
smile@openim-docker$ tree 
.
├── 📝 `docker-compose.yaml` - *Docker Compose configuration file for defining and running multi-container Docker applications.*
├── 📂 `example` - *Contains various example configuration files and scripts showing how to configure and use OpenIM services.*
│   ├── 📄 `basic-openim-server-dependency.yml` - *Basic OpenIM server dependency configuration.*
│   ├── 📄 `full-openim-server-and-chat.yml` - *Complete configuration for OpenIM server and chat services.*
│   ├── 📄 `full-openim-server-chat-web-admin.yml` - *Comprehensive configuration including server, chat, web interface, and admin tools.*
│   ├── 📄 `only-openim-server.yml` - *Configuration for only the OpenIM server.*
│   └── 📄 `volume-all-server.yml` - *Volume configuration file for the server.*
├── 📄 `FAQ-CN.md` - *Frequently asked questions document in Chinese.*
├── 📄 `FAQ.md` - *Frequently asked questions document in English.*
├── 📄 `LICENSE` - *Project license file.*
├── 📄 `Makefile` - *Automated build tool configuration file.*
├── 📂 `openim-server` - *Related files for the OpenIM server.*
│   └── 📂 `_output`
│       └── 📂 `logs`
│           └── 📄 `openim_20240102.log` - *Server log file.*
├── 📄 `README.md` - *Project's English documentation.*
├── 📄 `README_zh-CN.md` - *Project's Chinese documentation.*
└── 📂 `scripts` - *Initialization, configuration, and upgrade scripts for the project.*
    ├── 📄 `clean.sh` - *Cleaning script.*
    ├── 📄 `create-topic.sh` - *Script for creating message topics.*
    ├── 📄 `init-config.sh` - *Initialization script for configuration.*
    ├── 📄 `mongo-init.sh` - *Script for initializing MongoDB.*
    ├── 📄 `README.md`

 - *Documentation for scripts.*
    ├── 📂 `template` - *Template files for the project.*
    │   ├── 📄 `boilerplate.txt`
    │   ├── 📄 `footer.md.tmpl`
    │   ├── 📄 `head.md.tmpl`
    │   ├── 📄 `LICENSE`
    │   ├── 📄 `LICENSE_TEMPLATES`
    │   └── 📄 `project_README.md`
    └── 📄 `upgrade.sh` - *Script for upgrading the project.*
```

1. `docker-compose.yaml`: A Docker Compose file for defining and running multi-container Docker applications. It describes the services, networks, and volumes required by the application.
2. `example` directory: Contains multiple example configuration files for showcasing the use and deployment of OpenIM services.
    - `basic-openim-server-dependency.yml`: Basic configuration for OpenIM server dependencies.
    - `full-openim-server-and-chat.yml`: Complete configuration including OpenIM server and chat services.
    - `full-openim-server-chat-web-admin.yml`: Full set of configurations including server, chat, web interface, and admin tools.
    - `only-openim-server.yml`: Configuration for only the OpenIM server.
    - `volume-all-server.yml`: Used to configure volumes for the server, mounted to containers in Volume format.
3. `FAQ-CN.md` and `FAQ.md`: Frequently asked questions documents in Chinese and English, respectively, providing answers to common questions from OpenIM users.
4. `Makefile`: A build automation tool configuration file to simplify the compiling and installation process.
5. `openim-server` directory: Contains related files for the OpenIM server, all generated by mapping out from the openim-server service after startup.
    - `_output/logs`: Stores log files, like `openim_20240102.log` recording logs for a specific date.
6. `_output` directory: Typically contains outputs from the build process, such as binary files, temporary files, and tools.
    - `bin`: Compiled binary files.
    - `tmp`: Temporary files.
    - `tools`: Tools used by the project.
7. `README.md` and `README_zh-CN.md`: Project's documentation files in English and Chinese, providing an overview and basic information about the project.
8. `scripts` directory: Contains multiple script files for project initialization, configuration, and upgrade.
    - `clean.sh`: Cleaning script for removing temporary files or build outputs.
    - `create-topic.sh` and `mongo-init.sh`: Scripts for initializing databases and message queues.
    - `init-config.sh`: Initialization script for configuration.
    - `README.md`: Description of the scripts directory.
    - `template` subdirectory: Contains project template files, like license templates and README templates.
    - `upgrade.sh`: Script for upgrading the project.

##  10. <a name='Deployingwithexample'></a>Deploying with example

Note that if deploying using example, the `DATA_DIR` variable needs to be set to specify the location for data storage.

```bash
export DATA_DIR="/test/test"
```

`DATA_DIR` will store configuration information, data, and logs for middleware, as well as configuration information and logs for openim-server and openim-chat.

For example, when deploying openim-server, openim-chat, openim-admin, and openim-web, use:

```bash
docker-compose -f example/full-openim-server-chat-web-admin.yml up -d 
```

To check the logs:

```bash
docker-compose -f example/full-openim-server-chat-web-admin.yml logs -f openim-server
docker-compose -f example/full-openim-server-chat-web-admin.yml logs -f openim-chat
```

To check the data storage location:

```bash
cat example/.env |grep DATA_DIR
```

To clear data:

```bash
docker-compose -f example/full-openim-server-chat-web-admin.yml down
rm -rf "Data Storage Location"
```

**Directory Structure:**

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

##  11. <a name='ConfigurationFileModification'></a>Configuration File Modification

Before modifying the configuration file, use `docker compose down` to stop the service.

- To modify the configuration, mainly focus on the `.env` file.
- Use `make init` to initialize the configuration file.
- In Docker, for shared variables in `.env`, `openim-server/config/config.yaml`, and `openim-chat/config/config.yaml`, follow steps for completely regenerating configuration or partial updates.
- For specific updates such as `OPENIM_IP`, `API_OPENIM_PORT`, `MINIO_PORT`, etc., ensure they are updated in `openim-server/config/config.yaml`.

```bash
object:
  apiURL: "http://$OPENIM_IP:$API_OPENIM_PORT"
  minio:
    endpoint: "http://$DOCKER_BRIDGE_GATEWAY:$MINIO_PORT"
    signEndpoint: "http://$OPENIM_IP:$MINIO_PORT"

grafanaUrl: http://$OPENIM_IP:$GRAFANA_PORT
```

##  12. <a name='CommonConfigurations'></a>Common Configurations

- Set `OPENIM_IP`, `DATA_DIR`, and `IMAGE_REGISTRY` according to your needs.
- For database configurations like MySQL, Redis, Kafka, MongoDB, MinIO, and Zookeeper, update the respective ports and credentials.

##  13. <a name='OpenIMDockerUpgrade'></a>OpenIM Docker Upgrade

- Upgrading from V3.4 to V3.6 involves code changes and deployment structure reconfiguration, currently not supporting automatic upgrades.
- For minor updates (and those after v3.6), which do not involve adding or removing configuration files, modify `SERVER_IMAGE_VERSION` and `CHAT_IMAGE_VERSION` in the `.env` file.
- Use `git pull` and `make upgrade` to update the repository.

##  14. <a name='CleaningUpDeployment'></a>Cleaning Up Deployment

- Use `docker compose down` to stop the service.
- Use `sudo make clean` to clean up configurations.
- Optionally clean data and prune unused networks: `docker network prune -f`

##  15. <a name='AdditionalInformation'></a>Additional Information

- Ensure the IP and port environment variables for chat are consistent.
- For quick verification, management backend, monitoring system, and more detailed configuration instructions, refer to the OpenIM documentation.

##  16. <a name='CommonIssues'></a>Common Issues

+ The new version of Docker integrates `docker-compose`. Older versions may not support the gateway feature. It's recommended to upgrade to a newer version, such as 23.0.1.

+ For deployment issues, search or raise an issue at [https://github.com/openimsdk/openim-docker/issues](https://github.com/openimsdk/openim-docker/issues). If the issue doesn't exist, please help us by raising it.

###  16.1. <a name='Troubleshooting'></a>Troubleshooting

Common issues are documented in [FAQ.md](https://github.com/OpenIMSDK/openim-docker/blob/main/FAQ.md). If you encounter any issues, you can refer to this document.

It's also possible to find [issues](https://github.com/OpenIMSDK/openim-docker/issues) that have been encountered before, if not, please provide us with an [issue description](https://github.com/openimsdk/openim-docker/issues/new/choose)


##  17. <a name='Contribution'></a>Contribution

- Fork this repository to your GitHub account.
- Clone the forked repository to your local environment.
- Create a new branch and name it after your contribution.
- Make changes where needed.
- Commit your changes and push them to your fork.
- Create a new Pull Request on GitHub.

We encourage community contributions and improvements to this project. For the specific contribution process, please refer to [CONTRIBUTING.md](https://chat.openai.com/CONTRIBUTING.md).

###  17.1. <a name='Conclusion'></a>Conclusion

OpenIM's flexible storage solutions empower organizations to configure their infrastructure in alignment with their specific needs. Whether through default directories, custom paths, or Docker volumes, OpenIM guarantees efficient and secure data management.

For further assistance or advanced configurations, please consult our technical support team or refer to OpenIM's comprehensive documentation.

##  18. <a name='License'></a>License

This project uses the MIT license. For details, please refer to [LICENSE](https://chat.openai.com/LICENSE).
