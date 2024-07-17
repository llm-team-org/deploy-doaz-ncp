FROM python:3.10-rc-slim-buster
WORKDIR /
COPY deploy.sh /deploy.sh
RUN apt update -y && apt install -y curl \
    && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl \
    && curl -o ncp-iam-authenticator -L https://github.com/NaverCloudPlatform/ncp-iam-authenticator/releases/latest/download/ncp-iam-authenticator_linux_amd64 \
    && chmod +x ./ncp-iam-authenticator && mkdir -p /usr/local/bin && mv ./ncp-iam-authenticator /usr/local/bin/ncp-iam-authenticator \
    && chmod +x /deploy.sh
CMD ["bash", "./deploy.sh"]