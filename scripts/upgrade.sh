#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Include shell font styles and some basic information
SCRIPTS_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# OPENIM_ROOT is the root directory of the project
OPENIM_ROOT=$(dirname "${BASH_SOURCE[0]}")/..

echo "Choose whether to overwrite the configuration files:"

# Call the script to initialize configuration
${OPENIM_ROOT}/scripts/init-config.sh

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null && ! command -v docker compose &> /dev/null; then
    echo "Error: docker-compose is not installed."
    exit 1
fi

# Use the available docker compose command to redeploy
compose_command=$(command -v docker-compose || command -v docker)

echo "Redeploying using ${compose_command}..."

pushd ${OPENIM_ROOT}
# Example of a redeploy command adjust as needed
${compose_command} compose down
${compose_command} compose up -d
popd