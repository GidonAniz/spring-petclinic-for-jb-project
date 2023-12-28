pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'your-docker-hub-repo'
        APP_NAME = 'your-app-name'
    }

           stage('Build Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'c92d3aa8-67ab-4cf2-b3c6-a5e67285ed2d', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                        echo \${DOCKER_PASSWORD} | docker login -u \${DOCKER_USERNAME} --password-stdin
                        docker build -t gidonan/cicd:${BUILD_NUMBER} -f Dockerfile .
                        """
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'c92d3aa8-67ab-4cf2-b3c6-a5e67285ed2d', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                        echo \${DOCKER_PASSWORD} | docker login -u \${DOCKER_USERNAME} --password-stdin
                        docker push gidonan/cicd:${BUILD_NUMBER}
                        """
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
