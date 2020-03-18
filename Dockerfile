ARG BUILD_FROM
FROM ${BUILD_FROM}:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ARG AZURE_ARCH
ENV \
    DEBIAN_FRONTEND=noninteractive \
    AZURE_ARCH=${AZURE_ARCH}
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu60 \
        libunwind8 \
        netcat

WORKDIR /azp

COPY ./start.sh .

CMD ["./start.sh"]
