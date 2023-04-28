#!/bin/bash

scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd && cd - >/dev/null 2>&1 )"

jdkList=$( bash $scriptPath/jdk/jdkInstall.sh -l )
for jdk in ${jdkList}; do
    echo bash ${scriptPath}/jdk/build.sh ${jdk}
done

for flavor in openliberty wlp; do
    for jdk in ${jdkList}; do
        for version in $( bash $scriptPath/liberty/libertyInstall.sh -l -f ${flavor} ); do
            echo bash ${scriptPath}/liberty/build.sh -j ${jdk} -f ${flavor} -v ${version}
        done
    done
done
