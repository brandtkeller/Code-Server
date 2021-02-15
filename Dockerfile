ARG BASE_REGISTRY=docker.io
ARG BASE_IMAGE=codercom/code-server
ARG BASE_TAG=3.8.0
FROM $BASE_REGISTRY/$BASE_IMAGE:$BASE_TAG

# Apt cleanup procedures
RUN sudo apt clean && sudo rm -rf /var/lib/apt/lists/* && sudo apt clean
RUN sudo apt-get update && sudo apt-get install -y libpq-dev apt-transport-https gnupg build-essential manpages-dev software-properties-common
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list && \
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
RUN sudo apt-get update

# Install npm related items (NodeJS, EmberJS) - Removed for specific installation
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
# RUN export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && [ -s "$NVM_DIR/bash_completion" ] \
# && \. "$NVM_DIR/bash_completion" && nvm install --lts && npm install -g ember-cli

# Install CLI tools
RUN sudo apt-get install -y kubectl helm python3-pip

# Install extensions
# RUN code-server --install-extension vscjava.vscode-maven || echo "Problem installing Maven extension"

# Hardcoded git configuration - parameterize this
RUN git config --global user.email info@brandtkeller.net && git config --global user.name brandtkeller
RUN sudo echo "source /usr/share/bash-completion/completions/git" >> ~/.bashrc  

# Bake in the update-ca-certs command
RUN LASTLINE=$(awk 'END{print}' /usr/bin/entrypoint.sh) && sudo sed -i "s:$LASTLINE:sudo update-ca-certificates\n$LASTLINE:g" /usr/bin/entrypoint.sh