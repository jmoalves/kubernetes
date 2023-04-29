ARG jdkVersion=
ARG jdkType=jre

FROM jmoalves/java:ibm-${jdkType}-${jdkVersion}

LABEL org.opencontainers.image.authors="jmoalves.dev@pobox.com"

ARG libertyVersion=
ARG libertyFlavor=openliberty
ARG libertyRepositoryUrl=

################
### Liberty install

COPY libertyInstall.sh /tmp/libertyInstall.sh

ENV WLP_HOME=/usr/local/wlp
ENV WLP_USER_DIR ${WLP_HOME}/usr
RUN bash /tmp/libertyInstall.sh -f "${libertyFlavor}" -v "${libertyVersion}" -r "${libertyRepositoryUrl}"

ENV PATH=${WLP_HOME}/bin:${PATH}
