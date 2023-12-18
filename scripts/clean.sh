#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Include shell font styles and some basic information
SCRIPTS_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
OPENIM_ROOT=$(dirname "${BASH_SOURCE[0]}")/..

config_file="${OPENIM_ROOT}/.env"
components_file="${OPENIM_ROOT}/components/"

source $config_file

# Function to delete directory with confirmation
delete_dir() {
    read -p "Are you sure you want to delete $1? [Y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        rm -rf "$1"
        echo "$1 has been deleted."
    else
        echo "Deletion aborted."
    fi
}

# Function to display help
display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  --help                  Display this help message"
    echo "  --components            Delete the components directory"
    echo "  --openim-server-config  Delete the OpenIM server configuration"
    echo "  --openim-chat-config    Delete the OpenIM chat configuration"
}

# Check arguments
if [[ $# -gt 0 ]]; then
    case $1 in
        --help)
            display_help
            exit 0
            ;;
        --components)
            delete_dir "$DATA_DIR/components"
            exit 0
            ;;
        --openim-server-config)
            delete_dir "$DATA_DIR/openim-server/config"
            exit 0
            ;;
        --openim-chat-config)
            delete_dir "$DATA_DIR/openim-chat/config"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            display_help
            exit 1
            ;;
    esac
fi

if [ -z "$DATA_DIR" ]; then
    echo "DATA_DIR is not set or is empty"
    rm -rf $components_file
    exit 1
fi

pushd $OPENIM_ROOT
delete_dir "$DATA_DIR/components"
delete_dir "$DATA_DIR/openim-server/config"
delete_dir "$DATA_DIR/openim-chat/config"
docker network prune -f
popd
