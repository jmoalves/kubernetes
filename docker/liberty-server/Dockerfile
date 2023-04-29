ARG jdkVersion=
ARG jdkType=jre
ARG libertyVersion=
ARG libertyFlavor=

FROM jmoalves/liberty:${libertyFlavor}-${libertyVersion}-ibm-${jdkType}-${jdkVersion} AS liberty-runtime

LABEL org.opencontainers.image.authors="jmoalves.dev@pobox.com"

COPY build/ /tmp/build/

RUN server create appServer && \
    bash /tmp/build/installLibs.sh && \
    bash /tmp/build/installApp.sh && \
    bash /tmp/build/features.sh && \
    rm -rf /tmp/build/

EXPOSE 9080/tcp
EXPOSE 9443/tcp

ENTRYPOINT [ "server" ]
CMD [ "run", "appServer" ]
