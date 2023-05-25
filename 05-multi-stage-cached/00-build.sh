#!/usr/bin/env bash

IMAGE_NAME="docker-layers:05"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "${DIR}" >/dev/null 2>&1 || exit 1

# delete all images with the name ${IMAGE_NAME} silently
docker rmi "${IMAGE_NAME}" >/dev/null 2>&1
docker system prune --force >/dev/null

printf "[INFO] Building the following dockerfile as '%s'\n\n" "${IMAGE_NAME}"

cat "${DIR}/dockerfile"

_cmd="docker build . -t ${IMAGE_NAME} --progress=plain --no-cache"
printf "\n[INFO] docker command:\n\n%s\n\n" "${_cmd}"
time eval "${_cmd}"

printf "\n[INFO] Message file contents: %s\n\n" "$(docker run --rm docker-layers:04 cat message.txt)"

_cmd="docker build . -t ${IMAGE_NAME} --progress=plain --build-arg MESSAGE2='Now it caches!'"
printf "\n[INFO] docker command:\n\n%s\n\n" "${_cmd}"
time eval "${_cmd}"

printf "\n[INFO] Message file contents: %s\n\n" "$(docker run --rm docker-layers:04 cat message.txt)"

_cmd="docker build . -t ${IMAGE_NAME} --progress=plain --build-arg MESSAGE2='Sooooo much cache!'"
printf "\n[INFO] docker command:\n\n%s\n\n" "${_cmd}"
time eval "${_cmd}"

printf "\n[INFO] Message file contents: %s\n\n" "$(docker run --rm docker-layers:04 cat message.txt)"

popd >/dev/null 2>&1 || exit 1