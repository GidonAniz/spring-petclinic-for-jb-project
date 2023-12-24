pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'your-docker-hub-repo'
        APP_NAME = 'your-app-name'
    }


        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Step 2: Build and push Docker image
                    docker.build("${DOCKER_HUB_REPO}/${APP_NAME}:${env.BUILD_NUMBER}")
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        docker.image("${DOCKER_HUB_REPO}/${APP_NAME}:${env.BUILD_NUMBER}").push()
                        docker.image("${DOCKER_HUB_REPO}/${APP_NAME}:${env.BUILD_NUMBER}").push('latest')
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Helm installation and deployment
                    sh 'helm upgrade --install --wait --set app.image.name=${DOCKER_HUB_REPO}/${APP_NAME}:${env.BUILD_NUMBER} myapp ./helm-chart'
                }
            }
        }
    }
}
