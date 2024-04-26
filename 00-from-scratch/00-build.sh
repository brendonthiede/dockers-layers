#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "${DIR}" >/dev/null 2>&1 || exit 1

printf "[INFO] Building the following dockerfile as 'docker-layers:00'\n\n"

cat "${DIR}/dockerfile"

_cmd="docker build . -t docker-layers:00 --progress=plain"

printf "\n[INFO] docker command:\n\n%s\n\n" "${_cmd}"
eval "${_cmd}"

printf "\n[INFO] Now we'll use dive to look at the layers:\n\ndive docker-layers:00\n\n"
popd >/dev/null 2>&1 || exit 1
