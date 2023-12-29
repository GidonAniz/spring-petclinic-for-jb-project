pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'gidonan/k8s'
        APP_NAME = 'myapp'
        HELM_CHART_DIR = './helm-chart'  // Define HELM_CHART_DIR here
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: '3b1907ec-9652-465c-9403-a8778041867d', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
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

        stage('Create Deployment Manifests') {
            steps {
                script {
                    // Create application deployment manifest
                    sh "helm template ${APP_NAME} ${HELM_CHART_DIR} --set app.image.name=${DOCKER_HUB_REPO}/${APP_NAME}:${BUILD_NUMBER} --output-dir ./manifests"

                    // Create MySQL deployment manifest
                    sh 'helm template mysql stable/mysql --set image.tag=5.7,mysqlRootPassword=petclinic,mysqlUser=petclinic,mysqlPassword=petclinic,mysqlDatabase=petclinic --output-dir ./manifests'
                }
            }
        }
    }
}
