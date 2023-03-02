#!/bin/bash

libertyFlavor=openliberty
libertyVersion=23.0.0.1
jdkVersion=17.0.6.0

jdkUrl=https://github.com/ibmruntimes/semeru17-binaries/releases/download/jdk-17.0.6%2B10_openj9-0.36.0/ibm-semeru-open-jre_x64_linux_17.0.6_10_openj9-0.36.0.tar.gz

docker build \
    --build-arg libertyFlavor=${libertyFlavor} \
    --build-arg jdkMajorVersion=17 \
    --build-arg jdkUrl=${jdkUrl} \
    --build-arg libertyVersion=${libertyVersion} \
    -t jmoalves/${libertyFlavor}:${libertyVersion}-jdk-${jdkVersion} \
    --progress=plain \
    .
