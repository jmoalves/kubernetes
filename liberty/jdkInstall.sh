#!/bin/bash

jdkVersion=
jdkFlavor=semeru
jdkRepositoryUrl=

while getopts "v:f:r:" o; do
    case "${o}" in
    v) jdkVersion="${OPTARG}";;
    f) jdkFlavor="${OPTARG}";;
    r) jdkRepositoryUrl="${OPTARG}";;
    *)
        echo Invalid options
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

if [ -z "${jdkVersion}" ]; then
    echo Inform the jdk version with the '-v' option
    exit 1
fi

# echo jdkVersion=${jdkVersion}
# echo jdkFlavor=${jdkFlavor}
# echo jdkRepositoryUrl=${jdkRepositoryUrl}

semeruInstall() {
    echo
    echo === JDK - Semeru install - ${jdkVersion} - MAJOR = ${jdkMajor}

    jdkUrl=$(
        curl -s -L \
            -H "Accept: application/vnd.github+json" \
            https://api.github.com/repos/ibmruntimes/semeru${jdkMajor}-binaries/releases \
        | jq -r '.[]|select(.prerelease == false)| .assets[].browser_download_url ' \
        | grep 'x64_linux' \
        | grep jdk-${adjustedVersion} \
        | grep 'tar\.gz$' \
        | grep jre
    )

    if [ -z "$jdkUrl" ]; then
        echo Semeru JDK version ${jdkVersion} not found
        exit 1
    fi

    if [ ! -z "${jdkRepositoryUrl}" ]; then
        jdkUrl=$( echo ${jdkUrl} | sed "s@^https://github.com@${jdkRepositoryUrl}@g" )
    fi

    # https://github.com/ibmruntimes/semeru8-binaries/releases/download/jdk8u362-b09_openj9-0.36.0/ibm-semeru-open-jre_x64_linux_8u362b09_openj9-0.36.0.tar.gz
    # https://github.com/ibmruntimes/semeru11-binaries/releases/download/jdk-11.0.18%2B10_openj9-0.36.1/ibm-semeru-open-jre_x64_linux_11.0.18_10_openj9-0.36.1.tar.gz
    # https://github.com/ibmruntimes/semeru17-binaries/releases/download/jdk-17.0.6%2B10_openj9-0.36.0/ibm-semeru-open-jre_x64_linux_17.0.6_10_openj9-0.36.0.tar.gz

    echo = JDK from ${jdkUrl}
    mkdir -p /usr/local && cd /usr/local
    curl -L -s ${jdkUrl} | tar xz
    mv $( ls -1d jdk* ) /usr/local/java
}

ibmInstall() {
    echo
    echo === JDK - IBM install - ${jdkVersion} - MAJOR = ${jdkMajor}


    jdkDirUrl=https://public.dhe.ibm.com/ibmdl/export/pub/systems/cloud/runtimes/java/${jdkVersion}/linux/x86_64

    jdkFile=$(
        curl -L --list-only -s ${jdkDirUrl} \
        | grep 'ibm-java' \
        | sed "s/.*<a href[^>]\+>\([^<]\+\).*/\1/g" \
        | grep archive \
        | grep jre
    )

    if [ -z "$jdkFile" ]; then
        echo IBM JDK version ${jdkVersion} not found
        exit 1
    fi

    jdkUrl=${jdkDirUrl}/${jdkFile}

    # https://public.dhe.ibm.com/ibmdl/export/pub/systems/cloud/runtimes/java/8.0.7.20/linux/x86_64/ibm-java-jre-8.0-7.20-x86_64-archive.bin

    echo = JDK from ${jdkUrl}
    #./ibm-java-sdk-8.0-7.20-x86_64-archive.bin -i silent -DLICENSE_ACCEPTED=TRUE -DUSER_INSTALL_DIR=/java
    mkdir -p /usr/local && cd /usr/local
    curl -L -s ${jdkUrl} -O
    chmod +x ${jdkFile}
    ./${jdkFile} -i silent -DLICENSE_ACCEPTED=TRUE -DUSER_INSTALL_DIR=/usr/local/java
    rm ${jdkFile}
}

my_arr=($( echo ${jdkVersion} | tr "." "\n" ))
if [ "${my_arr[3]}" == "" -o "${my_arr[3]}" == "0" ]; then
    adjustedVersion=${my_arr[0]}.${my_arr[1]}.${my_arr[2]}
else
    adjustedVersion=$jdkVersion
fi
jdkMajor=${my_arr[0]}
unset my_arr

case $jdkFlavor in 
    semeru) semeruInstall;;
    ibm) ibmInstall;;
    *) error;;
esac
