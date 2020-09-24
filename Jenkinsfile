pipeline {
    agent none
 
   environment {
         HOME_REPO = 'http://192.168.0.71:32600/brandtkeller/Code-Server.git'
         GITHUB_REPO = 'github.com/brandtkeller/Code-Server.git'
         REGISTRY = '192.168.0.128:5000/'
         IMAGE = '192.168.0.128:5000/code-server'
         PROJECT = 'Code-Server'
    }
    options {
        skipStagesAfterUnstable()
        skipDefaultCheckout true
    }
    stages {
        stage('Development Build') {
            agent { node { label 'docker' } }
            when { not { branch 'master' } }
            steps {
                sh 'rm -rf Code-Server'
                sh 'git clone ${HOME_REPO}'
                sh 'cd Code-Server && docker build -t ${IMAGE}:dev-0.0.${BUILD_NUMBER} .'
                sh 'docker push ${IMAGE}:dev-0.0.${BUILD_NUMBER}'
                sh 'docker image rm ${IMAGE}:dev-0.0.${BUILD_NUMBER}'
                sh 'rm -rf Code-Server'
            }
        }

        stage('Master Build') {
            agent { node { label 'docker' } }
            when { branch 'master' }
            steps {
                sh 'rm -rf Code-Server'
                sh 'git clone ${HOME_REPO}'
                // Force the build command to pull a new latest tag image
                sh 'docker image rm codercom/code-server:latest || echo "No image to remove"'
                sh 'cd Code-Server && docker build -t ${IMAGE}:0.0.${BUILD_NUMBER} .'
                sh 'docker push ${IMAGE}:0.0.${BUILD_NUMBER}'
                sh 'docker image rm ${IMAGE}:0.0.${BUILD_NUMBER}'
                sh 'rm -rf Code-Server'
            }
        }

        stage('Rolling Deployment to Cluster') {
            agent { node { label 'docker' } }
            when { branch 'master' }
            steps {
                sh 'kubectl config set-context --current --namespace=development'
                sh 'kubectl set image deployments/coder coder=${IMAGE}:0.0.${BUILD_NUMBER}'
            }
        }

        stage('Mirror to public Github') {
            agent any
            options { skipDefaultCheckout true }
            when { branch 'master' }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                withCredentials([usernamePassword(credentialsId: 'git_creds', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                                sh 'rm -rf *'
                                sh 'git clone --mirror $HOME_REPO'
                }
                withCredentials([usernamePassword(credentialsId: 'github_creds', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                            dir("${PROJECT}.git"){
                                    sh 'git remote add --mirror=fetch github https://$GIT_USERNAME:$GIT_PASSWORD@$GITHUB_REPO'
                                    sh 'git push github --all'
                            }
                    }
                }
            }
      }
    }
}