#!/bin/bash

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

if [ -z "${jdkVersion}" ]; then
    echo Inform the jdk version with the '-j' option
    exit 1
fi

if [ -z "${libertyVersion}" ]; then
    echo Inform the liberty version with the '-l' option
    exit 1
fi

imageName=liberty:${libertyFlavor}-${libertyVersion}-ibmjdk-${jdkVersion}
kubeTag=localhost:32000

clear

echo ==========================================
echo === Liberty - building image ${imageName}
echo

docker build \
    --build-arg jdkVersion=${jdkVersion} \
    --build-arg libertyFlavor=${libertyFlavor} \
    --build-arg libertyVersion=${libertyVersion} \
    --progress=plain \
    -t jmoalves/${imageName} \
    -t ${kubeTag}/${imageName} \
    .

# docker push localhost:32000/${imageName}
