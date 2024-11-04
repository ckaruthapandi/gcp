pipeline {
  agent any
  stages {
    stage('node js check out ') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: '9f3b5fc3-a908-4819-b3e6-0ba71e7c6bcf', url: 'https://github.com/ckaruthapandi/gcp.git']]])
        }
    }
    stage('get_commit_msg') {
    steps {
        script {
            env.GIT_COMMIT_MSG = sh (script: 'git log -1 --pretty=%B ${GIT_COMMIT}', returnStdout: true).trim()
        }
    }
}
    stage('connecting to GCR') {
     steps{  
         script {
                def gcloudServiceAccountKey = credentials('ecbae9ea-2041-4956-a579-74d26beb92c2') // Replace with your credential ID
                    writeFile file: 'gcloud-key.json', text: gcloudServiceAccountKey
                    sh 'gcloud auth activate-service-account --key-file=gcloud-key.json'
                    sh 'gcloud auth configure-docker'
                }
           }
      }
     stage('Build and Push to GCR') {
            steps {
                sh 'docker build -t gcr.io/red-context-436605-p8/nodejs:${env.BUILD_NUMBER} .'
                sh 'docker push gcr.io/red-context-436605-p8/nodejs:latest'
            }
        }
    }
  }
  post 
  {
      always
      {
          sh 'rm -f gcloud-key.json' // Clean up the key file
          slackSend channel: 'kp-devops', message: "pipeline status -${currentBuild.currentResult}"
        }
   }
}
