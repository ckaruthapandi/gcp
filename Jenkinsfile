pipeline {
    agent any

    environment {
        IMG_NAME = 'nodejs'
        DOCKER_REPO = 'karuthapandi/gcp'
        GOOGLE_CREDENTIALS = credentials('gke-service-account-key')  // Use the Jenkins credential ID
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your Git repository
                git branch: 'main', url: 'https://github.com/ckaruthapandi/gcp.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t ${IMG_NAME} .'
                    // Tag the Docker image for the repository
                    sh 'docker tag ${IMG_NAME} ${DOCKER_REPO}:${IMG_NAME}'
                }
            }
        }

        stage('Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerHub-LG', passwordVariable: 'PSWD', usernameVariable: 'LOGIN')]) {
                    script {
                        // Login to DockerHub and push the image
                        sh 'echo ${PSWD} | docker login -u ${LOGIN} --password-stdin'
                        sh 'docker push ${DOCKER_REPO}:${IMG_NAME}'
                    }
                }
            }
        }

        stage('Checkout for Helm Deployment') {
            steps {
                // Checkout the code from your Git repository for Helm deployment
                git branch: 'main', url: 'https://github.com/ckaruthapandi/gcphelm.git'
            }
        }

        stage('Authenticate with GKE') {
            steps {
                script {
                    // Authenticate with Google Cloud using the service account
                    withCredentials([file(credentialsId: 'gke-service-account-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}'
                        sh 'gcloud config set project red-context-436605-p8'
                        sh 'gcloud container clusters get-credentials autopilot-cluster-2 --region us-central1 --project red-context-436605-p8'
                    }
                }
            }
        }

        stage('Deploy to Helm') {
            steps {
                script {
                    // Apply the namespace configuration and deploy using Helm
                    sh 'kubectl apply -f my-namespace.yaml'
                    sh 'helm upgrade --install nodejsdev nodejsapp --values nodejsapp/values.yaml -n dev --set image.tag="$BUILD_NUMBER"'
                    sh 'cat nodejsapp/values.yaml'
                }
            }
        }
    }
}

