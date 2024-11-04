pipeline {
    agent any

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = 'gcloud-key.json' // Change this to match the cleanup step
    }

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

        stage('Authenticate with Google Cloud') {
            steps {
                script {
                    // Load Google Cloud credentials from Jenkins credentials store
                    def gcloudServiceAccountKey = credentials('d182c445-296a-4a3c-a6b8-c9f5ccf7ee3f') // Your Jenkins credential ID
                    writeFile file: GOOGLE_APPLICATION_CREDENTIALS, text: gcloudServiceAccountKey

                    // Authenticate with Google Cloud
                    sh 'gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}'
                    sh 'gcloud auth configure-docker'
                    sh 'gcloud config set project red-context-436605-p8'
                }
            }
        }
    }

    post {
        always {
            // Clean up the key file
            sh 'rm -f ${GOOGLE_APPLICATION_CREDENTIALS}'
            slackSend channel: 'kp-devops', message: "Pipeline status: ${currentBuild.currentResult}"
        }
    }
}

