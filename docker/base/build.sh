#!/bin/bash

scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd && cd - >/dev/null 2>&1 )"

imageName=base

echo
echo ==========================================
echo === Base - building image ${imageName}
echo

docker build \
    --progress=plain \
    -t jmoalves/${imageName} \
    ${scriptPath}
