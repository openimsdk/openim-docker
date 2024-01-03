# OpenIM Docker


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