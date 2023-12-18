#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Include shell font styles and some basic information
SCRIPTS_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# OpenIM_ROOT 是项目的根目录
OPENIM_ROOT=$(dirname "${BASH_SOURCE[0]}")/..

