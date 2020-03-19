ARG BUILD_FROM
FROM ${BUILD_FROM}:16.04

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
        libcurl3 \
        libicu55 \
        libunwind8 \
        netcat \
        apt-transport-https \
        software-properties-common \
        gnupg2 \
        ssh \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update && apt-get install -y --no-install-recommends \
        docker-ce \
        docker-ce-cli \
        containerd.io \
    && apt-get purge -y --auto-remove \
        apt-transport-https \
        software-properties-common \
        gnupg2

WORKDIR /azp

COPY ./start.sh .

CMD ["./start.sh"]
