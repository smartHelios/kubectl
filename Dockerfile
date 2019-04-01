FROM ruby:2.3-slim

RUN apt-get update && apt-get install -y curl

ARG KUBECTL_VERSION="1.12.7"
ARG KUBECTL_BUILD_DATE="2019-03-27"
ARG HELM_VERSION="2.11.0"

RUN curl -L https://amazon-eks.s3-us-west-2.amazonaws.com/${KUBECTL_VERSION}/${KUBECTL_BUILD_DATE}/bin/linux/amd64/kubectl > /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

# install aws-iam-authenticator
RUN curl -L "https://amazon-eks.s3-us-west-2.amazonaws.com/${KUBECTL_VERSION}/${KUBECTL_BUILD_DATE}/bin/linux/amd64/aws-iam-authenticator" > /usr/local/bin/aws-iam-authenticator \
    && chmod +x /usr/local/bin/aws-iam-authenticator

# install Helm
RUN curl -L "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz" > helm.tar.gz \
    && tar xvf helm.tar.gz \
    && cp ./linux-amd64/helm /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

COPY env_var_helper_client.sh env_var_helper_client.rb ./
RUN chmod +x env_var_helper_client.sh

ENTRYPOINT ["./env_var_helper_client.sh"]

