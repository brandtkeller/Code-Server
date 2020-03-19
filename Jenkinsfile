pipeline {
    agent any
    options {
        skipStagesAfterUnstable()
        skipDefaultCheckout true
    }
    stages {
        stage('build') {
            
            agent { node { label 'docker' } }
            steps {
                sh 'git clone http://192.168.0.122:32600/brandtkeller/Code-Server.git'
                sh 'cd Code-Server && docker build -t 192.168.0.128:5000/code-server:${BUILD_NUMBER} .'
                sh 'docker push 192.168.0.128:5000/code-server:${BUILD_NUMBER}'
                sh 'docker image rm 192.168.0.128:5000/code-server:${BUILD_NUMBER}'
                sh 'rm -rf Code-Server/'
            }
        }
    }
}