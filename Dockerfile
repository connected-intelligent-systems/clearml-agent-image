ARG TAG=3.7.17-alpine3.18

FROM python:${TAG} as build

RUN apk add --no-cache \
    gcc \
    musl-dev \
    libffi-dev

RUN python3 \
    -m pip \
    install \
    --prefix=/install \
    --no-cache-dir \
    -U \
    clearml-agent \
    cryptography>=2.9

FROM python:${TAG} as target

WORKDIR /app

ARG KUBECTL_VERSION=1.29.3

COPY --from=build /install /usr/local

ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/bin/

RUN chmod +x /usr/bin/kubectl

RUN apk add --no-cache \
    bash

COPY k8s_glue_example.py .
COPY build_resources/clearml.conf .
COPY build_resources/entrypoint.sh .
COPY build_resources/setup.sh .
COPY build_resources/provider_entrypoint.sh .

RUN chmod +x entrypoint.sh
RUN chmod +x setup.sh
RUN chmod +x provider_entrypoint.sh
RUN touch /root/.bashrc

FROM target

WORKDIR /

RUN apk --no-cache add \
        curl \
        python3 \
        py3-crcmod \
        py3-openssl \
        bash \
        libc6-compat \
        openssh-client \
        git \
        gnupg 

WORKDIR /app