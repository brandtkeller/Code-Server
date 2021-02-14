pipeline {
    agent none
 
   environment {
         GITHUB_REPO = 'github.com/brandtkeller/Code-Server.git'
    }
    options {
        skipStagesAfterUnstable()
        skipDefaultCheckout false
    }
    stages {
        stage('Build Stages') {
            agent { label 'jenkins-buildah-agent' }
            stages {
                stage('Feature Branch') {
                    when { not { branch 'master' } }
                    steps {
                        sh 'VER=$(cat VERSION) && echo ${VER} && \
                            buildah bud --build-arg BASE_TAG=${VER} -t registry.home.local:8443/dev/code-server:${VER}-${BUILD_NUMBER} && \
                            buildah push registry.home.local:8443/dev/code-server:${VER}-${BUILD_NUMBER}'
                    }
                }
                stage('Master Branch') {
                    when { branch 'master' }
                    steps {
                        sh 'VER=$(cat VERSION) && echo ${VER} && \
                            buildah bud --build-arg BASE_TAG=${VER} -t registry.home.local:8443/test/code-server:${VER} && \
                            buildah push registry.home.local:8443/test/code-server:${VER}'
                    }
                }
                stage('Mirror to public Github') {
                    when { branch 'master' }
                        steps {
                            catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                            withCredentials([usernamePassword(credentialsId: 'git_token', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                                    sh 'git fetch --prune'
                                    sh 'git push --prune https://$GIT_USERNAME:$GIT_PASSWORD@$GITHUB_REPO +refs/remotes/origin/*:refs/heads/* +refs/tags/*:refs/tags/*'
                                }
                            }
                        }

                }
            }
        }
    }
}