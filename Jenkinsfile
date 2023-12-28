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
                    withCredentials([usernamePassword(credentialsId: '34c72964-7467-451d-ab87-b76aa17b895a', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                        echo \${DOCKER_PASSWORD} | docker login -u \${DOCKER_USERNAME} --password-stdin
                        docker build -t gidonan/k8s:${BUILD_NUMBER} -f Dockerfile .
                        """
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: '34c72964-7467-451d-ab87-b76aa17b895a', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                        echo \${DOCKER_PASSWORD} | docker login -u \${DOCKER_USERNAME} --password-stdin
                        docker push gidonan/k8s:${BUILD_NUMBER}
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
