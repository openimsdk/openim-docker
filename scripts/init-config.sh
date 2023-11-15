#!/usr/bin/env bash
# Copyright © 2023 OpenIM. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script automatically initializes the various configuration files
# Read: https://github.com/OpenIMSDK/Open-IM-Server/blob/main/docs/contrib/init_config.md

set -o errexit
set -o nounset
set -o pipefail

OPENIM_ROOT=$(dirname "${BASH_SOURCE[0]}")/..

source "${OPENIM_ROOT}/scripts/install/common.sh"

echo "++ The initialized version selected CHAT_BRANCH: ${CHAT_BRANCH}"
echo "++ The initialized version selected SERVER_BRANCH: ${SERVER_BRANCH}"

openim::log::info "🤲 Get and overwrite the configuration file by diff"

file1_path="${OPENIM_ROOT}/openim-server/${SERVER_BRANCH}/scripts/install/environment.sh"
file2_path="${OPENIM_ROOT}/scripts/install/environment.sh"

echo "++++ file1_path: ${file1_path}"
echo "++++ file2_path: ${file2_path}"

status_file1=$(git status --porcelain $file1_path | awk '{print $1}')
status_file2=$(git status --porcelain $file2_path | awk '{print $1}')

echo "++++ status_file1: ${status_file1}"
echo "++++ status_file2: ${status_file2}"

if [[ "$status_file1" == "M" && "$status_file2" != "M" ]]; then
    cp $file1_path $file2_path
    echo "$file1_path was copied over $file2_path because $file1_path has uncommitted changes."
elif [[ "$status_file1" != "M" && "$status_file2" == "M" ]]; then
    cp $file2_path $file1_path
    echo "$file2_path was copied over status_file1 because $file2_path has uncommitted changes."
elif [[ "$status_file1" == "M" && "$status_file2" == "M" ]]; then
    echo "Both files have uncommitted changes."
    echo "++++ file1_path: ${file1_path}"
    echo "++++ file2_path: ${file2_path}"
else
    echo "Both files have no uncommitted changes."
    commit_file1_data=$(git log -1 --pretty=format:"%ad" --date=short $file1_path | tr -d '-')
    commit_file2_data=$(git log -1 --pretty=format:"%ad" --date=short $file2_path | tr -d '-')
    if [[ "$commit_file1_data" > "$commit_file2_data" ]]; then
        cp $file1_path $file2_path
        echo "$file1_path was copied over $file2_path"
    elif [[ "$commit_file1_data" < "$commit_file2_data" ]]; then
        cp $file2_path $file1_path
        echo "$file2_path was copied over $file1_path"
    else
        echo "Both files were modified at the same time. No copying required."
    fi
fi

# 定义关联数组，其中键是模板文件，值是对应的输出文件 
# (en: Defines an associative array where the keys are the template files and the values are the corresponding output files.)
declare -A TEMPLATES=(
  ["${OPENIM_ROOT}/templates/env_template.yaml"]="${OPENIM_ROOT}/.env;${OPENIM_ROOT}/example/.env"
  ["${OPENIM_ROOT}/templates/openim.yaml"]="${OPENIM_ROOT}/openim-server/${SERVER_BRANCH}/config/config.yaml"
  ["${OPENIM_ROOT}/templates/chat.yaml"]="${OPENIM_ROOT}/openim-chat/${CHAT_BRANCH}/config/config.yaml"
  ["${OPENIM_ROOT}/templates/prometheus.yml"]="${OPENIM_ROOT}/openim-server/${SERVER_BRANCH}/config/prometheus.yml"
)

for template in "${!TEMPLATES[@]}"; do
  if [[ ! -f "${template}" ]]; then
    openim::log::error_exit "template file ${template} does not exist..."
  fi

  IFS=';' read -ra OUTPUT_FILES <<< "${TEMPLATES[$template]}"
  for output_file in "${OUTPUT_FILES[@]}"; do
    openim::log::info "⌚  Working with template file: ${template} to ${output_file}..."
    "${OPENIM_ROOT}/scripts/genconfig.sh" "${file1_path}" "${template}" > "${output_file}" || {
      openim::log::error "Error processing template file ${template}"
      exit 1
    }
  done
  sleep 0.5
done

openim::log::success "✨  All configuration files have been successfully generated!"