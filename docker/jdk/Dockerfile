FROM jmoalves/base

LABEL org.opencontainers.image.authors="jmoalves.dev@pobox.com"

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
