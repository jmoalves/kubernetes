###################
## Liberty image
###################
FROM centos:centos7

LABEL org.opencontainers.image.authors="jmoalves.dev@pobox.com"

###################
### ARGS

ARG jdkVersion=
ARG jdkFlavor=semeru
ARG libertyFlavor=openliberty
ARG libertyVersion=

ARG libertyRepositoryUrl=https://public.dhe.ibm.com/ibmdl/export/pub/software
ARG jdkRepositoryUrl=

################
### Utilities

RUN yum -y install unzip
RUN curl -L -s https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/local/bin/jq && \
    chmod a+x /usr/local/bin/jq

################
### JDK install

COPY jdkInstall.sh /tmp/jdkInstall.sh
# RUN bash /tmp/jdkInstall.sh -f ${jdkFlavor} -v ${jdkVersion} -r "${jdkRepositoryUrl}"
RUN bash /tmp/jdkInstall.sh -f ${jdkFlavor} -v ${jdkVersion}

ENV JAVA_HOME=/usr/local/java
ENV PATH=${JAVA_HOME}/bin:${PATH}
RUN java -version

################
### Liberty install

# https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/23.0.0.1/openliberty-kernel-23.0.0.1.zip
# https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/23.0.0.1/wlp-kernel-23.0.0.1.zip

RUN echo && \
    case "${libertyFlavor}" in \
        "openliberty") export libertyRootUrl=${libertyRepositoryUrl}/openliberty/runtime/release;; \
        "wlp") export libertyRootUrl=${libertyRepositoryUrl}/websphere/wasdev/downloads/wlp;; \
        *) echo ERROR && exit 1;; \
    esac && \
    \
    libertyZip=${libertyFlavor}-kernel-${libertyVersion}.zip && \
    libertyUrl=${libertyRootUrl}/${libertyVersion}/${libertyZip} && \
    \
    echo === Liberty install - ${libertyUrl} && \
    mkdir -p /usr/local && cd /usr/local && \
    curl -L -s ${libertyUrl} -o ${libertyZip} && \
    unzip -qq ${libertyZip} && \
    rm ${libertyZip}

ENV WLP_HOME=/usr/local/wlp
ENV PATH=${WLP_HOME}/bin:${PATH}

################
### Liberty usr

ENV WLP_USER_DIR ${WLP_HOME}/usr
RUN echo === Liberty USR - ${WLP_USER_DIR} && \
    mkdir -p ${WLP_USER_DIR}

################
### Liberty server

RUN server create defaultServer

COPY installFeature.xml /tmp/installFeature.xml

RUN cd /tmp && \
    curl -L -s https://dlcdn.apache.org/maven/maven-3/3.9.0/binaries/apache-maven-3.9.0-bin.tar.gz | tar xz && \
    M2_HOME=$( ls -1d apache-maven-* ) && \
    PATH=${M2_HOME}/bin:${PATH} && \
    mvn -f /tmp/installFeature.xml \
	    io.openliberty.tools:liberty-maven-plugin:install-feature \
	    -Dwlp.runtime=${WLP_HOME} \
	    -Dwlp.user.dir=${WLP_USER_DIR} \
	    -Dwlp.server=defaultServer && \
    rm -rf ${M2_HOME} /tmp/installFeature.xml

EXPOSE 9080/tcp
EXPOSE 9443/tcp

CMD server run defaultServer
