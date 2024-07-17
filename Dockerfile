FROM amd64/python:3.12.0b1-slim-buster

COPY deploy.sh /usr/local/bin/deploy
RUN chmod +x /usr/local/bin/deploy

RUN apt -y update && apt -y install curl \
    && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl \
    && curl -o ncp-iam-authenticator -L https://github.com/NaverCloudPlatform/ncp-iam-authenticator/releases/latest/download/ncp-iam-authenticator_linux_amd64 \
    && chmod +x ./ncp-iam-authenticator && mkdir -p /usr/local/bin && mv ./ncp-iam-authenticator /usr/local/bin/ncp-iam-authenticator

RUN if [ -f /usr/local/bin/ncp-iam-authenticator ]; then echo "ncp-iam-authenticator is installed."; else echo "ncp-iam-authenticator is NOT installed."; exit 1; fi

RUN ncp-iam-authenticator 

RUN if [ -f /usr/local/bin/deploy ]; then echo "deploy is present."; else echo "deploy is NOT present."; exit 1; fi
RUN if [ -x /usr/local/bin/deploy ]; then echo "deploy is executable."; else echo "deploy is NOT executable."; exit 1; fi

CMD ["/usr/local/bin/deploy"]