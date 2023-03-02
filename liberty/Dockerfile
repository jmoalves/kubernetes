###################
## Liberty image
###################
LABEL org.opencontainers.image.authors="jmoalves.dev@pobox.com"

FROM centos7

###################
### ARGS

ARG libertyDownloadRootUrl=https://public.dhe.ibm.com/ibmdl/export/pub/software

# Options: openliberty or wlp
ARG libertyFlavor=openliberty

ARG jdkDownloadRootUrl=https://github.com/ibmruntimes/semeru17-binaries/releases/download


###################
### Main ENV variables

ENV openLibertyDownloadPath ${libertyDownloadRootUrl}/openliberty/runtime/release
ENV wlpDownloadPath ${libertyDownloadRootUrl}/websphere/wasdev/downloads/wlp
ENV jdkRpmUrl=${jdkDownloadRootUrl}/jdk-17.0.6%2B10_openj9-0.36.0/ibm-semeru-open-17-jdk-17.0.6.10_0.36.0-1.x86_64.rpm

################
### JDK install
RUN curl ${jdkRpmUrl} && ls -l
