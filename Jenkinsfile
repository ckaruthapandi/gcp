pipeline {
    agent any

    environment {
        // Set your Docker Hub username and image details here
        DOCKER_HUB_USERNAME = 'karuthapandi'
        DOCKER_HUB_REPO = 'karuthapandi/gcp'
        IMAGE_NAME = 'nodejsapp'
        TAG = 'latest' // You can use dynamic tags like BUILD_NUMBER
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your Git repository
                git 'https://github.com/ckaruthapandi/gcp.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t ${DOCKER_HUB_USERNAME}/${DOCKER_HUB_REPO}:${IMAGE_NAME}-${TAG} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub using Jenkins credentials
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the image to Docker Hub
                    sh "docker push ${DOCKER_HUB_USERNAME}/${DOCKER_HUB_REPO}:${IMAGE_NAME}-${TAG}"
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    // Optionally, remove the local image after pushing
                    sh "docker rmi ${DOCKER_HUB_USERNAME}/${DOCKER_HUB_REPO}:${IMAGE_NAME}-${TAG}"
                }
            }
        }
    }

    post {
        always {
            // This section can be used for cleanup tasks like logging out
            sh 'docker logout'
        }
    }
}

