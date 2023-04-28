ARG jdkVersion=

FROM jmoalves/java:ibmjdk-${jdkVersion}

LABEL org.opencontainers.image.authors="jmoalves.dev@pobox.com"

ARG libertyVersion=
ARG libertyFlavor=openliberty
ARG libertyRepositoryUrl=https://public.dhe.ibm.com/ibmdl/export/pub/software

################
### Liberty install

# https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/23.0.0.1/openliberty-kernel-23.0.0.1.zip
# https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/23.0.0.1/wlp-kernel-23.0.0.1.zip

COPY libertyInstall.sh /tmp/libertyInstall.sh

ENV WLP_HOME=/usr/local/wlp
ENV WLP_USER_DIR ${WLP_HOME}/usr
RUN bash /tmp/libertyInstall.sh -f ${libertyFlavor} -v ${libertyVersion}

ENV PATH=${WLP_HOME}/bin:${PATH}
