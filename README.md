# Code Server

A docker instance of VS Code for remote development within a containerized environment.
This repository is for custom baking the image for use in a kubernetes environment to which the nodes have access to the .kube resources in order to run 'kubectl' from the nodes and then inherently the vscode instance. 

## Purpose
Browser accessible VSCode instances that break-down the development environment to suit the needs of the human operator.
Leveraging larger infrastrcture such as servers instead of consuming resources on individual laptops/desktops.
Multiple instances can be deployed to a cluster/environment for many operators. Any one instance can be accessed by multiple operators if allowed. 

## Jenkins Automated Builds

This repository is setup to automatically build and push a new code-server docker image to a private registry at commit.

## Extensions pre-installation

Extensions will be pre-installed during the image build. Code server has a CLI for installing extensions.

### TODO
* Parameterize the Dockerfile and Jenkinsfile for any hardcoded values