#!/bin/bash

scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd && cd - >/dev/null 2>&1 )"

jdkVersion=
jdkRepositoryUrl=
list=false

while getopts "v:r:l" o; do
    case "${o}" in
    v) jdkVersion="${OPTARG}";;
    r) jdkRepositoryUrl="${OPTARG}";;
    l) list=true;;
    *)
        echo Invalid options
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

#certifiedJDK='' # Non certified
certifiedJDK='-certified' # certified

if ${list}; then
    # JDK 8
    curl -ks https://public.dhe.ibm.com/ibmdl/export/pub/systems/cloud/runtimes/java/ | grep -o 'href=".*/">' | sed 's/.*href="\(.*\)\/".*/\1/g' | grep '^8.'

    # JDK 17
    curl -s -L \
            -H "Accept: application/vnd.github+json" \
            https://api.github.com/repos/ibmruntimes/semeru17${certifiedJDK}-binaries/releases \
    | jq -r '.[]|select(.prerelease == false)| .assets[].browser_download_url ' \
    | grep 'jdk_x64_linux' \
    | grep 'tar\.gz$' \
    | sed 's/.*jdk_x64_linux_\(.*\).tar.gz.*/\1/g'

    exit 0
fi

if [ -z "${jdkVersion}" ]; then
    echo Inform the jdk version with the '-v' option
    exit 1
fi

semeruInstall() {
    echo
    echo === JDK - Semeru install - ${jdkVersion} - MAJOR = ${jdkMajor}

    jdkUrl=$(
        curl -s -L \
            -H "Accept: application/vnd.github+json" \
            https://api.github.com/repos/ibmruntimes/semeru${jdkMajor}${certifiedJDK}-binaries/releases \
        | jq -r '.[]|select(.prerelease == false)| .assets[].browser_download_url ' \
        | grep 'jdk_x64_linux' \
        | grep jdk-${adjustedVersion} \
        | grep 'tar\.gz$'
    )

    if [ -z "$jdkUrl" ]; then
        echo Semeru JDK version ${jdkVersion} not found
        exit 1
    fi

    if [ ! -z "${jdkRepositoryUrl}" ]; then
        jdkUrl=$( echo ${jdkUrl} | sed "s@^https://github.com@${jdkRepositoryUrl}@g" )
    fi

    # https://github.com/ibmruntimes/semeru11-binaries/releases/download/jdk-11.0.18%2B10_openj9-0.36.1/ibm-semeru-open-jdk_x64_linux_11.0.18_10_openj9-0.36.1.tar.gz
    # https://github.com/ibmruntimes/semeru17-binaries/releases/download/jdk-17.0.6%2B10_openj9-0.36.0/ibm-semeru-open-jdk_x64_linux_17.0.6_10_openj9-0.36.0.tar.gz
    # https://github.com/ibmruntimes/semeru17-certified-binaries/releases/download/jdk-17.0.6%2B10_openj9-0.36.0/ibm-semeru-certified-jdk_x64_linux_17.0.6.0.tar.gz

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
        | grep 'ibm-java-sdk' \
        | sed "s/.*<a href[^>]\+>\([^<]\+\).*/\1/g" \
        | grep archive
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

case $jdkMajor in 
    8) ibmInstall;;
    *) semeruInstall;;
esac
