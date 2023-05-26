#!/bin/bash
version_checker() {
  LATEST_RUNNER_VERSION=$(curl --silent https://api.github.com/repos/actions/runner/releases/latest | grep '"tag_name":' | cut -d'"' -f4|sed 's/^.//')
  echo "Latest version of actions runner - ${LATEST_RUNNER_VERSION}"
  if [[ ! -e ${WORKDIR}/actions-runner-linux-x64-${LATEST_RUNNER_VERSION}.tar.gz ]]; then
    echo "Updating Runner..."
    echo "Remove old tar.gz file"
    rm -rf ${WORKDIR}/*.tar.gz

    echo "Install latest actions runner - ${LATEST_RUNNER_VERSION}"
    wget https://github.com/actions/runner/releases/download/v${LATEST_RUNNER_VERSION}/actions-runner-linux-x64-${LATEST_RUNNER_VERSION}.tar.gz
    tar xzf ${WORKDIR}/actions-runner-linux-x64-${LATEST_RUNNER_VERSION}.tar.gz -C ${WORKDIR}

    #FIXME 의존성 모듈 문제 생겼을 때 installdepdencies.sh 실행 커멘드를 Dockerfile에 추가해야합니다. (sudo 로만 실행가능)
  fi
}

env_checker() {
  if [[ -z "${DOCKER_HOST}" ]]; then
    echo "ERROR: DOCKER_HOST is null"
    exit 1;
  fi
  if [[ -z "${HAECHI_GITHUB_ORG}" ]]; then
    echo "ERROR: HAECHI_GITHUB_ORG is null"
    exit 1;
  fi
  if [[ -z "${HAECHI_GITHUB_PAT}" ]]; then
    echo "ERROR: HAECHI_GITHUB_PAT is null"
    exit 1;
  fi
  if [[ -z "${RUNNER_GROUP}" ]]; then
    echo "ERROR: RUNNER_GROUP is null"
    exit 1;
  fi
  if [[ -z "${RUNNER_LABEL}" ]]; then
    echo "ERROR: RUNNER_LABEL is null"
    exit 1;
  fi
}

token_generator() {
  RUNNER_TOKEN="$(curl -XPOST -fsSL \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token ${HAECHI_GITHUB_PAT}" \
  "https://api.github.com/orgs/${HAECHI_GITHUB_ORG}/actions/runners/registration-token" \
  | jq -r '.token')"
}

cleanup_runner() {
  echo "Cleanup Runner (${RUNNER_TOKEN})"
  ${WORKDIR}/config.sh remove --token "${RUNNER_TOKEN}"
  exit 1
}

echo "Check environment variable"
env_checker

echo "Check actions runner version"
version_checker

echo "Generate RUNNER_TOKEN"
token_generator

#export RUNNER_ALLOW_RUNASROOT="1"

echo "Configuring..."
${WORKDIR}/config.sh \
  --url "https://github.com/${HAECHI_GITHUB_ORG}" \
  --labels "haechi,${RUNNER_LABEL}" \
  --name "${RUNNER_NAME}" \
  --runnergroup "${RUNNER_GROUP}" \
  --token "${RUNNER_TOKEN}" \
  --unattended \
  --replace

unset RUNNER_TOKEN

trap 'cleanup_runner; exit 130' INT
trap 'cleanup_runner; exit 143' TERM

echo "Start actions runner"
${WORKDIR}/run.sh "$*"