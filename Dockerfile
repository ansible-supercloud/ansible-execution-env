FROM registry.redhat.io/ansible-automation-platform-23/ee-29-rhel8:1.0.0-255

USER root

# Install yum
RUN microdnf install yum

# Install Terraform, Azure CLI, Ansible Galaxy Collections, and OPA
RUN yum clean all && yum update -y && \
    yum install -y yum-utils && \
    # yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
    yum -y install terraform && \
    # curl -L -o opa https://openpolicyagent.org/downloads/v0.40.0/opa_linux_amd64_static && \
    # chmod 755 ./opa && cp opa /bin && \
    # yum -y install wget && \
    # yum -y install tar && \
    # LATEST_VERSION=$(wget -O - "https://api.github.com/repos/open-policy-agent/conftest/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c 2-) && \
    # wget "https://github.com/open-policy-agent/conftest/releases/download/v${LATEST_VERSION}/conftest_${LATEST_VERSION}_Linux_x86_64.tar.gz" && \
    # tar xzf conftest_${LATEST_VERSION}_Linux_x86_64.tar.gz && \
    # mv conftest /usr/local/bin && \
    rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/azure-cli.repo && \
    yum install -y dnf && \
    yum install -y unzip && \
    dnf install -y azure-cli && \
    python3 -m ensurepip --upgrade && \
    ansible-galaxy collection install community.general && \
    ansible-galaxy collection install community.crypto && \
    ansible-galaxy collection install awx.awx:21.12.0

COPY requirements.txt .

RUN pip3 install -r requirements.txt