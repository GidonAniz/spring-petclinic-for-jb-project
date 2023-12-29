pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'gidonan/k8s'
        APP_NAME = 'myapp'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: '3b1907ec-9652-465c-9403-a8778041867d', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        // Set MAVEN_OPTS to enable Maven debug logging during the build
                        sh 'export MAVEN_OPTS="-X" && echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin && docker build -t ${DOCKER_HUB_REPO}:${BUILD_NUMBER} -f Dockerfile .'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: '3b1907ec-9652-465c-9403-a8778041867d', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo \${DOCKER_PASSWORD} | docker login -u \${DOCKER_USERNAME} --password-stdin && docker push \${DOCKER_HUB_REPO}:${BUILD_NUMBER}"
                    }
                }
            }
        }

    }
}
