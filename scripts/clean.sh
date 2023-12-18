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

if [ -z "$DATA_DIR" ]; then
    echo "DATA_DIR is not set or is empty"
    rm -rf $components_file
    exit 1
fi

pushd $OPENIM_ROOT
rm -rf "$DATA_DIR/components"
rm -rf "$DATA_DIR/openim-server/config"
rm -rf "$DATA_DIR/openim-chat/config"
docker network prune -f
popd