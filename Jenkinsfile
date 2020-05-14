pipeline {
    agent none
 
   environment {
         HOME_REPO = 'http://192.168.0.122:32600/brandtkeller/Code-Server.git'
         GITHUB_REPO = 'github.com/brandtkeller/Code-Server.git'
         REGISTRY = '192.168.0.128:5000/'
         IMAGE = '192.168.0.128:5000/code-Server'
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
                sh 'cd Code-Server && docker build -t ${IMAGE}:0.0.${BUILD_NUMBER} .'
                sh 'docker push ${IMAGE}:0.0.${BUILD_NUMBER}'
                sh 'docker image rm ${IMAGE}:0.0.${BUILD_NUMBER}'
                sh 'rm -rf Code-Server'
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