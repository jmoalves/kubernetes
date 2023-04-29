FROM jmoalves/base

LABEL org.opencontainers.image.authors="jmoalves.dev@pobox.com"

### ARGS
ARG jdkVersion=
ARG jdkType=jdk
###

COPY jdkInstall.sh /tmp/jdkInstall.sh
RUN bash /tmp/jdkInstall.sh -v ${jdkVersion} -t ${jdkType}

ENV JAVA_HOME=/usr/local/java
ENV PATH=${JAVA_HOME}/bin:${PATH}
RUN java -version

ENTRYPOINT ["java"]
CMD ["-version"]
