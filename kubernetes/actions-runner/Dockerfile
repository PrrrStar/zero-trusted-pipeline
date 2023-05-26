FROM ubuntu:20.04

# apt-get 설치 시 불필요한 인터렉션을 없애기 위함
ENV DEBIAN_FRONTEND=noninteractive
ENV WORKDIR "/usr/src/actions-runner"

RUN echo "export TMOUT=600;" >> /etc/profile && \
    sed -i '/sync/s/bin\/sync/sbin\/nologin/g' /etc/passwd && \
    sed -i '/shutdown/s/sbin\/shutdown/sbin\/nologin/g' /etc/passwd && \
    sed -i '/halt/s/sbin\/halt/sbin\/nologin/g' /etc/passwd && \
    chown root:root /etc/shadow && \
    chmod 400 /etc/shadow && \
    echo "불법적이거나 비인가적인 접근 시 법적 처벌을 받습니다" > /etc/motd

RUN addgroup docker && \
    adduser --shell /bin/bash --gid 1000 user

# 기본 패키지 설치
RUN apt-get update -y && apt-get install -y \
      apt-transport-https ca-certificates curl wget gnupg lsb-release git jq sudo build-essential \
      openjdk-11-jdk

# Docker 설치
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo \
      "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y docker-ce docker-ce-cli docker-compose

# Helm 설치
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# NodeJS, TypeScript 설치
RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
    apt install nodejs && \
    npm install -g npm && \
    npm install -g yarn && \
    npm install -g typescript

RUN npm i -g ts-node && \
    npm install @playwright/test --global && \
    npx playwright install && \
    npx playwright install-deps

WORKDIR ${WORKDIR}

RUN chown -hR user:docker ${WORKDIR}