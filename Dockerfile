FROM codercom/code-server:latest

RUN sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
RUN sudo apt-get update

# Install languages
RUN sudo apt install -y default-jdk openjdk-8-jdk maven

# Install CLI tools
RUN sudo apt-get install -y kubectl iputils-ping

# Install extensions
RUN code-server --install-extension vscjava.vscode-maven && \
    code-server --install-extension redhat.java && \
    code-server --install-extension redhat.vscode-xml

ADD ./binaries/helm /usr/local/bin/helm
RUN sudo chmod +x /usr/local/bin/helm
RUN helm init

RUN git config --global user.email info@brandtkeller.net && git config --global user.name brandtkeller