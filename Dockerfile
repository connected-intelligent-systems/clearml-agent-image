FROM ubuntu:22.04

USER root
WORKDIR /root

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV PYTHONIOENCODING=UTF-8

ARG KUBECTL_VERSION=1.29.3
ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/bin/
RUN chmod +x /usr/bin/kubectl

COPY ./build_resources/entrypoint.sh /root/entrypoint.sh
COPY ./build_resources/provider_entrypoint.sh /root/provider_entrypoint.sh
RUN chmod +x /root/provider_entrypoint.sh
COPY ./build_resources/k8s_glue_example.py /root/k8s_glue_example.py
COPY ./build_resources/clearml.conf /root/clearml.conf
RUN touch /root/.bashrc

ENTRYPOINT ["/root/entrypoint.sh"]