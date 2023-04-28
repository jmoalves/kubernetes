#!/bin/bash

scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd && cd - >/dev/null 2>&1 )"

cd /tmp

curl -L -s https://dlcdn.apache.org/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.tar.gz | tar xz
M2_HOME=$( ls -1d apache-maven-* )
PATH=${M2_HOME}/bin:${PATH}

mvn -f /tmp/build/installFeature.xml \
    io.openliberty.tools:liberty-maven-plugin:install-feature \
    -Dwlp.runtime=${WLP_HOME} \
    -Dwlp.user.dir=${WLP_USER_DIR} \
    -Dwlp.server=appServer

rm -rf ${M2_HOME}
rm -rf $HOME/.m2
