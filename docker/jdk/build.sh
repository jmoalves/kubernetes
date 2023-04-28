#!/bin/bash

scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd && cd - >/dev/null 2>&1 )"

jdkVersion=$1
if [ -z "${jdkVersion}" ]; then
    echo Inform the jdk version
    exit 1
fi

imageName=java:ibmjdk-${jdkVersion}

echo
echo ==========================================
echo === Java - building image ${imageName}
echo

docker build \
    --build-arg jdkVersion=${jdkVersion} \
    --progress=plain \
    -t jmoalves/${imageName} \
    ${scriptPath}
