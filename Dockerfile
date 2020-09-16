FROM centos:8

USER root

RUN yum -y update && \
  yum -y install epel-release which wget zip git \
  python3-pyyaml python3-jinja2 python3-setuptools python3-pip

RUN useradd -u 1000 deployuser

RUN mkdir -p /deploy && chown -R deployuser /deploy
RUN mkdir -p /etc/ansible

#RUN mkdir -p /usr/share/ansible && cd /usr/share && curl -kfsSL https://releases.ansible.com/ansible/ansible-2.9.10.tar.gz -o ansible.tar.gz && \
#  tar -xzf ansible.tar.gz -C ./ansible --strip-components 1 && \
#  rm -rf ansible.tar.gz ansible/docs ansible/examples ansible/packaging

RUN pip3 install boto boto3 ansible==2.9.10 openshift

# Add the following for anisble psdfarm deployment
# apk add --update --no-cache libxslt-dev libxml2-dev
# pip install lxml

RUN cd /tmp && curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
  unzip -q awscliv2.zip && \
  ./aws/install && \
  rm -f awscliv2.zip && rm -rf aws

RUN cd /tmp && curl -skLO https://storage.googleapis.com/kubernetes-release/release/v1.18.4/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && \
  mv ./kubectl /usr/local/bin/kubectl

RUN cd /tmp && curl -sk -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator && \
  chmod +x ./aws-iam-authenticator && \
  mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/0.22.0/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp && \
  mv /tmp/eksctl /usr/local/bin

RUN cd /tmp && curl -sk "https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz" -o "helm.tar.gz" && \
  tar -zxf helm.tar.gz && \
  mv linux-amd64/helm /usr/local/bin/helm && \
  rm -rf helm.tar.gz

RUN helm repo add stable https://kubernetes-charts.storage.googleapis.com/

RUN helm repo add bitnami https://charts.bitnami.com/bitnami

RUN helm repo update

USER deployuser

ENV PATH /usr/share/ansible/bin:$PATH

USER deployuser
WORKDIR /deploy

CMD [ "ansible-playbook", "--version" ]