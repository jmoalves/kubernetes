#!/bin/bash

scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd && cd - >/dev/null 2>&1 )"

jdkVersion=
jdkType=jre
libertyFlavor=openliberty
libertyVersion=

while getopts "j:f:v:t:" o; do
    case "${o}" in
    j) jdkVersion="${OPTARG}";;
    f) libertyFlavor="${OPTARG}";;
    v) libertyVersion="${OPTARG}";;
    t) jdkType="${OPTARG}";;
    *)
        echo Invalid options
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

if [ -z "${jdkVersion}" ]; then
    echo Inform the jdk version with the '-j' option
    exit 1
fi

if [ -z "${libertyVersion}" ]; then
    echo Inform the liberty version with the '-v' option
    exit 1
fi

imageName=liberty:${libertyFlavor}-${libertyVersion}-ibm-${jdkType}-${jdkVersion}

echo
echo ==========================================
echo === Liberty - building image ${imageName}
echo

docker build \
    --build-arg jdkVersion=${jdkVersion} \
    --build-arg jdkType=${jdkType} \
    --build-arg libertyFlavor=${libertyFlavor} \
    --build-arg libertyVersion=${libertyVersion} \
    --progress=plain \
    -t jmoalves/${imageName} \
    ${scriptPath}
