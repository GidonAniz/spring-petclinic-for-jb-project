pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'gidonan/k8s'
        APP_NAME = 'myapp'
        HELM_CHART_DIR = './my-app-chart'
    }

    stages {
        stage('Install Helm and kubectl') {
            steps {
                script {
                    // Install kubectl
                    sh 'curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl'
                    sh 'chmod +x ./kubectl'
                    sh 'mv ./kubectl /usr/local/bin/kubectl'

                    // Install Helm
                    sh 'curl -LO https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz'
                    sh 'tar -zxvf helm-v3.7.0-linux-amd64.tar.gz'
                    sh 'mv linux-amd64/helm /usr/local/bin/helm'
                }
            }
        }

        stage('Install Minikube') {
            steps {
                script {
                    sh 'curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64'
                    sh 'install minikube-linux-amd64 /usr/local/bin/minikube'
                }
            }
        }

        stage('Start Minikube') {
            steps {
                script {
                    sh 'minikube start --memory=4096 --cpus=2'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    withCredentials([usernamePassword(credentialsId: '3b1907ec-9652-465c-9403-a8778041867d', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                            export MAVEN_OPTS="-X"
                            echo \${DOCKER_PASSWORD} | docker login -u \${DOCKER_USERNAME} --password-stdin
                            docker build -t \${DOCKER_HUB_REPO}:${BUILD_NUMBER} -f Dockerfile .
                        """
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    withCredentials([usernamePassword(credentialsId: '3b1907ec-9652-465c-9403-a8778041867d', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                            echo \${DOCKER_PASSWORD} | docker login -u \${DOCKER_USERNAME} --password-stdin
                            docker push \${DOCKER_HUB_REPO}:${BUILD_NUMBER}
                        """
                    }
                }
            }
        }

        stage('Create Deployment Manifests') {
            steps {
                script {
                    // Add Helm repository
                    sh 'helm repo add stable https://charts.helm.sh/stable --force-update'

                    // Create application deployment manifest
                    sh "helm template ${APP_NAME} ${HELM_CHART_DIR} --set app.image.name=${DOCKER_HUB_REPO}/${APP_NAME}:${BUILD_NUMBER} --set app.replicaCount=1 --output-dir ./manifests"
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Apply manifests to Minikube cluster
                    sh 'kubectl apply -f ./manifests'
                }
            }
        }

        stage('Stop Minikube') {
            steps {
                script {
                    sh 'minikube stop'
                }
            }
        }
    }
}
