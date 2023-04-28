#!/bin/bash

scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd && cd - >/dev/null 2>&1 )"

libertyVersion=
libertyRepositoryUrl=https://public.dhe.ibm.com/ibmdl/export/pub/software
libertyFlavor=openliberty
list=false

while getopts "f:v:r:l" o; do
    case "${o}" in
    f) libertyFlavor="${OPTARG}";;
    v) libertyVersion="${OPTARG}";;
    r) libertyRepositoryUrl="${OPTARG}";;
    l) list=true;;
    *)
        echo Invalid options
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

case "${libertyFlavor}" in
    "openliberty") export libertyRootUrl=${libertyRepositoryUrl}/openliberty/runtime/release;;
    "wlp") export libertyRootUrl=${libertyRepositoryUrl}/websphere/wasdev/downloads/wlp;;
    *) echo ERROR && exit 1;;
esac

if ${list}; then
    curl -ks ${libertyRootUrl}/ | grep -o 'href=".*/">' | sed 's/.*href="\(.*\)\/".*/\1/g' | grep '[0-9]\{2\}\.[0-9]\+\.[0-9]\+\.[0-9]\+$'
    exit 0
fi

libertyZip=${libertyFlavor}-kernel-${libertyVersion}.zip
libertyUrl=${libertyRootUrl}/${libertyVersion}/${libertyZip}

echo === Liberty install - ${libertyUrl}
mkdir -p /usr/local && cd /usr/local
curl -L -s ${libertyUrl} -o ${libertyZip}
unzip -qq ${libertyZip}
rm ${libertyZip}

################
### Liberty usr

echo === Liberty USR - ${WLP_USER_DIR}
mkdir -p ${WLP_USER_DIR}
