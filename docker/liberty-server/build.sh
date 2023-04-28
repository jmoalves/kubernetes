#!/bin/bash

scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd && cd - >/dev/null 2>&1 )"

jdkVersion=
libertyFlavor=openliberty
libertyVersion=

while getopts "j:f:v:" o; do
    case "${o}" in
    j) jdkVersion="${OPTARG}";;
    f) libertyFlavor="${OPTARG}";;
    v) libertyVersion="${OPTARG}";;
    *)
        echo Invalid options
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

imageName=$1

if [ -z "${jdkVersion}" ]; then
    echo Inform the jdk version with the '-j' option
    exit 1
fi

if [ -z "${libertyVersion}" ]; then
    echo Inform the liberty version with the '-v' option
    exit 1
fi

if [ -z "${imageName}" ]; then
    echo Inform the image name
    exit 1
fi

echo
echo ==========================================
echo === Liberty - ${imageName} - prerequisites
echo

bash ${scriptPath}/../jdk/build.sh ${jdkVersion}
bash ${scriptPath}/../liberty/build.sh -j ${jdkVersion} -f ${libertyFlavor} -v ${libertyVersion}

echo
echo ==========================================
echo === Liberty - building image ${imageName}
echo

docker build \
    --build-arg jdkVersion=${jdkVersion} \
    --build-arg libertyFlavor=${libertyFlavor} \
    --build-arg libertyVersion=${libertyVersion} \
    --progress=plain \
    -t jmoalves/${imageName} \
    ${scriptPath}
