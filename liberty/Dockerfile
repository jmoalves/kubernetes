###################
## Liberty image
###################
FROM centos:centos7

LABEL org.opencontainers.image.authors="jmoalves.dev@pobox.com"

###################
### ARGS

# Options: openliberty or wlp
ARG libertyVersion=

ARG libertyFlavor=openliberty
ARG libertyRepositoryUrl=https://public.dhe.ibm.com/ibmdl/export/pub/software
ARG jdkRepositoryUrl=https://github.com/ibmruntimes
ARG jdkMajorVersion=17

## Remove
ARG jdkUrl

RUN echo && \
    echo === ARGs && \
    echo libertyFlavor=${libertyFlavor} && \
    echo libertyRepositoryUrl=${libertyRepositoryUrl} && \
    echo libertyRoot=${libertyRoot} && \
    echo jdkRepositoryUrl=${jdkRepositoryUrl} && \
    echo jdkMajorVersion=${jdkMajorVersion}

###################
### Main ENV variables

ENV jdkDownloadRootUrl ${jdkRepositoryUrl}/semeru${jdkMajorVersion}-binaries/releases/download
#ENV jdkUrl ${jdkDownloadRootUrl}/jdk-17.0.6%2B10_openj9-0.36.0/ibm-semeru-open-jre_x64_linux_17.0.6_10_openj9-0.36.0.tar.gz

################
### Show vars

RUN echo && \
    echo === VARs && \
    echo jdkDownloadRootUrl=${jdkDownloadRootUrl} && \
    echo jdkUrl=${jdkUrl}

################
### Utilities

RUN yum -y install unzip

################
### JDK install

# https://github.com/ibmruntimes/semeru8-binaries/releases/download/jdk8u362-b09_openj9-0.36.0/ibm-semeru-open-jre_x64_linux_8u362b09_openj9-0.36.0.tar.gz
# https://github.com/ibmruntimes/semeru11-binaries/releases/download/jdk-11.0.18%2B10_openj9-0.36.1/ibm-semeru-open-jre_x64_linux_11.0.18_10_openj9-0.36.1.tar.gz
# https://github.com/ibmruntimes/semeru17-binaries/releases/download/jdk-17.0.6%2B10_openj9-0.36.0/ibm-semeru-open-jre_x64_linux_17.0.6_10_openj9-0.36.0.tar.gz

RUN echo && \
    echo === JDK install - ${jdkUrl} && \
    mkdir -p /usr/local && cd /usr/local && \
    curl -L -s ${jdkUrl} | tar xz && \
    mv $( ls -1d jdk* ) /usr/local/java

ENV JAVA_HOME=/usr/local/java
ENV PATH=${JAVA_HOME}/bin:${PATH}
RUN java -version

################
### Liberty install

# https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/23.0.0.1/openliberty-kernel-23.0.0.1.zip
# https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/23.0.0.1/wlp-kernel-23.0.0.1.zip

ENV WLP_ROOT=/usr/local/liberty

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
### Liberty install

CMD ["/bin/bash"]
