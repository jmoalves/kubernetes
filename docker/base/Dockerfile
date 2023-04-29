FROM redhat/ubi8

LABEL org.opencontainers.image.authors="jmoalves.dev@pobox.com"

RUN yum -y install unzip jq && \
    yum clean all

ENTRYPOINT ["bash"]
