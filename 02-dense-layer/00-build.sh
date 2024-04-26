#!/usr/bin/env bash

IMAGE_NAME="docker-layers:02"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "${DIR}" >/dev/null 2>&1 || exit 1

printf "[INFO] Building the following dockerfile as '%s'\n\n" "${IMAGE_NAME}"

cat "${DIR}/dockerfile"

_cmd="docker build . -t ${IMAGE_NAME} --progress=plain"
printf "\n[INFO] docker command:\n\n%s\n\n" "${_cmd}"
eval "${_cmd}"

printf "\n[INFO] Now we'll use dive to look at the layers:\n\ndive %s\n\n" "${IMAGE_NAME}"

popd >/dev/null 2>&1 || exit 1
