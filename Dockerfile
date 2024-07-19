FROM python:3.12-rc-slim-buster

COPY deploy.sh /usr/local/bin/deploy

# Create the necessary directories
RUN mkdir -p /root/.ncloud

RUN apt -y update && apt -y install curl \
    && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash 

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

RUN curl -o ncp-iam-authenticator -L https://github.com/NaverCloudPlatform/ncp-iam-authenticator/releases/latest/download/ncp-iam-authenticator_linux_amd64 \
    && chmod +x ./ncp-iam-authenticator && mkdir -p /usr/local/bin && mv ./ncp-iam-authenticator /usr/local/bin/ncp-iam-authenticator

CMD deploy