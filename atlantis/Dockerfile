FROM ghcr.io/runatlantis/atlantis:v0.26.0

ENV KUBECTL_VERSION "1.28.1"
ENV GCLOUD_CLI_VERSION "450.0.0"

# Base
RUN apk add --update \
  python3 \
  python3-dev \
  py3-pip \
  build-base \
  curl \
  jq \
  && apk --purge -v del \
  && rm -rf /var/cache/apk/* \
  && mkdir ~/.aws \
  && mkdir ~/.gcloud

# Kubectl
RUN curl -Lo /bin/kubectl https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && chmod +x /bin/kubectl

# GCLOUD CLI
RUN curl -Lo /opt/gcloud-cli.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_CLI_VERSION}-linux-x86_64.tar.gz
RUN tar -xf /opt/gcloud-cli.tar.gz -C /opt
RUN /opt/google-cloud-sdk/install.sh
RUN ln -s /opt/google-cloud-sdk/bin/gcloud /bin/gcloud

ARG GCP_PRJ_D_DEVOPS
RUN echo $GCP_PRJ_D_DEVOPS | base64 -d > ~/.gcloud/prj-d-devops.json

WORKDIR /root

COPY repos.yaml repos.yaml
COPY atlantis.sh atlantis.sh
RUN chmod +x atlantis.sh

CMD ["./atlantis.sh"]
