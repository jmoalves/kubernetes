#!/bin/bash

clear

jdkFlavor=semeru
jdkVersion=
libertyFlavor=openliberty
libertyVersion=

while getopts "J:j:L:l:" o; do
    case "${o}" in
    J) jdkFlavor="${OPTARG}";;
    j) jdkVersion="${OPTARG}";;
    L) libertyFlavor="${OPTARG}";;
    l) libertyVersion="${OPTARG}";;
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
    echo Inform the liberty version with the '-l' option
    exit 1
fi

imageName=liberty:${libertyFlavor}-${libertyVersion}-${jdkFlavor}-${jdkVersion}

echo ==========================================
echo === Liberty - building image ${imageName}
echo

docker build \
    --build-arg jdkFlavor=${jdkFlavor} \
    --build-arg jdkVersion=${jdkVersion} \
    --build-arg libertyFlavor=${libertyFlavor} \
    --build-arg libertyVersion=${libertyVersion} \
    -t jmoalves/${imageName} \
    --progress=plain \
    .
