pipeline {
    agent any

    stages {
        stage('Node.js Check Out') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [
                        [
                            credentialsId: '9f3b5fc3-a908-4819-b3e6-0ba71e7c6bcf',
                            url: 'https://github.com/ckaruthapandi/gcp.git'
                        ]
                    ]
                ])
            }
        }
        
        stage('Get Commit Message') {
            steps {
                script {
                    env.GIT_COMMIT_MSG = sh(
                        script: 'git log -1 --pretty=%B',
                        returnStdout: true
                    ).trim()
                }
            }
        }
        
        stage('Connect to GCR') {
            steps {
                script {
                    // Retrieve the service account key and write it to a file
                    def gcloudServiceAccountKey = credentials('ecbae9ea-2041-4956-a579-74d26beb92c2')
                    writeFile file: 'gcloud-key.json', text: gcloudServiceAccountKey
                    sh 'gcloud auth activate-service-account --key-file=gcloud-key.json'
                    sh 'gcloud auth configure-docker'
                }
            }
        }
        
        stage('Build and Push to GCR') {
            steps {
                script {
                    def imageTag = "gcr.io/red-context-436605-p8/nodejs:${env.BUILD_NUMBER}"
                    sh "docker build -t ${imageTag} ."
                    sh "docker push ${imageTag}"
                    sh 'docker push gcr.io/red-context-436605-p8/nodejs:latest' // Pushing the "latest" tag
                }
            }
        }
    }
    
    post {
        always {
            sh 'rm -f gcloud-key.json' // Clean up the key file
            slackSend channel: 'kp-devops', message: "Pipeline status: ${currentBuild.currentResult}"
        }
    }
}

