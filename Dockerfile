FROM codercom/code-server:latest

# Apt cleanup procedures
RUN sudo apt clean && sudo rm -rf /var/lib/apt/lists/* && sudo apt clean

RUN sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
RUN sudo apt-get update

# Install JDK & Maven
RUN sudo apt install -y default-jdk maven --fix-missing

# Install CLI tools
RUN sudo apt-get install -y kubectl iputils-ping

# Install npm related items (Node, )
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && [ -s "$NVM_DIR/bash_completion" ] \
&& \. "$NVM_DIR/bash_completion" && nvm install --lts && npm install -g ember-cli

# Install extensions
RUN code-server --install-extension vscjava.vscode-maven || echo "Problem installing Maven extension"
RUN code-server --install-extension redhat.java || echo "Problem installing redhat java extension"
RUN code-server --install-extension redhat.vscode-xml || echo "Problem installating redhat xml extension"

# Install local binariesk
ADD ./binaries/helm /usr/local/bin/helm
RUN sudo chmod +x /usr/local/bin/helm
RUN helm init --client-only

# Hardcoded git configuration - parameterize this
RUN git config --global user.email info@brandtkeller.net && git config --global user.name brandtkeller