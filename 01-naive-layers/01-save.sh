#!/usr/bin/env bash

IMAGE_NAME="docker-layers:01"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
rm -rf "${DIR}/layers"
mkdir -p "${DIR}/layers"
pushd "${DIR}/layers" >/dev/null 2>&1 || exit 1

_cmd="docker image save ${IMAGE_NAME} -o layers.tar; tar -xf layers.tar"
printf "\n[INFO] Save the image layers as a tarball, then extract it:\n\n%s\n\n" "${_cmd}"
eval "${_cmd}"

printf "\n[INFO] Contents of 'repositories'\n\n"
jq . ./repositories

printf "\n[INFO] Contents of 'manifest.json'\n\n"
jq . ./manifest.json

CONFIG_FILE=$(jq -r '.[0].Config' ./manifest.json)
printf "\n[INFO] Contents of '%s'\n\n" "${CONFIG_FILE}"
read -p "(continue)" -n 1 -r

jq . "${CONFIG_FILE}" -C | less -R


SECRET_LAYER=$(jq -r '.[0].Layers[3]' ./manifest.json)
printf "\n[INFO] 4th layer (when the secret was added): %s\n" "${SECRET_LAYER}"

_cmd="tar -axf ${SECRET_LAYER} secret.txt -O"
printf "[INFO] Contents of secret.txt\n\n%s\n\n" "${_cmd}"
eval "${_cmd}"

popd >/dev/null 2>&1 || exit 1