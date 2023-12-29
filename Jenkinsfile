pipeline {
    agent {
        docker {
            // Use the pre-built image from Docker Hub
            image 'gidonan/k8s:latest'
            registryUrl 'https://index.docker.io/v1/'
        }
    }

    environment {
        DOCKER_HUB_REPO = 'gidonan/k8s'
        APP_NAME = 'myapp'
        HELM_CHART_DIR = './helm-chart'
    }

    stages {
        stage('Push Docker Image') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    withCredentials([usernamePassword(credentialsId: '3b1907ec-9652-465c-9403-a8778041867d', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo \${DOCKER_PASSWORD} | docker login -u \${DOCKER_USERNAME} --password-stdin && docker push \${DOCKER_HUB_REPO}:latest"
                    }
                }
            }
        }

        stage('Create Deployment Manifests') {
            steps {
                script {
                    // Create application deployment manifest
                    sh "helm template ${APP_NAME} ${HELM_CHART_DIR} --set app.image.name=${DOCKER_HUB_REPO}:latest --output-dir ./manifests"

                    // Create MySQL deployment manifest
                    sh 'helm template mysql stable/mysql --set image.tag=5.7,mysqlRootPassword=petclinic,mysqlUser=petclinic,mysqlPassword=petclinic,mysqlDatabase=petclinic --output-dir ./manifests'
                }
            }
        }

        // Add more stages as needed
    }
}
