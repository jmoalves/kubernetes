#!/bin/bash

scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd && cd - >/dev/null 2>&1 )"

jdkType=jre

while getopts "t:" o; do
    case "${o}" in
    t) jdkType="${OPTARG}";;
    *)
        echo Invalid options
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

jdkVersion=$1
if [ -z "${jdkVersion}" ]; then
    echo Inform the jdk version
    exit 1
fi

imageName=java:ibm-${jdkType}-${jdkVersion}

echo
echo ==========================================
echo === Java - building image ${imageName}
echo

docker build \
    --build-arg jdkVersion=${jdkVersion} \
    --build-arg jdkType=${jdkType} \
    --progress=plain \
    -t jmoalves/${imageName} \
    ${scriptPath}
