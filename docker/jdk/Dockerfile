FROM centos:centos7 AS jdk-base

LABEL org.opencontainers.image.authors="jmoalves.dev@pobox.com"

RUN yum -y install unzip && \
    yum clean all && \
    curl -L -s https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/local/bin/jq && \
    chmod a+x /usr/local/bin/jq
ENV PATH=/usr/local/bin/jq:${PATH}


################

FROM jdk-base AS jdk-install

### ARGS
ARG jdkVersion=
###

COPY jdkInstall.sh /tmp/jdkInstall.sh
RUN bash /tmp/jdkInstall.sh -v ${jdkVersion}

ENV JAVA_HOME=/usr/local/java
ENV PATH=${JAVA_HOME}/bin:${PATH}
RUN java -version

ENTRYPOINT ["java"]
CMD ["-version"]
