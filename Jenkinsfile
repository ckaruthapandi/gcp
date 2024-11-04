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
    stage('Docker image build ') {
      steps {
        sh 'docker build -t aatmaaniproject .'
      }
    }
    stage('Pushing to ECR') {
     steps{  
         script {
                sh 'gcloud auth configure-docker us-central1-docker.pkg.dev'
                sh 'docker push gcr.io/red-context-436605-p8/aatmaaniproject:latest'
                }
           }
      }
    stage('helm repo check out ') {
      steps {
        git branch: 'main', url: 'https://github.com/ckaruthapandi/ap_helm_node_js.git'
      }
    }
     stage('deploy to helm ') {
      steps {
            sh 'kubectl apply -f my-namespace.yaml'
            sh 'helm upgrade --install nodejsdev nodejsapp --values nodejsapp/values.yaml -n dev --set image.tag="$BUILD_NUMBER"'
            sh 'cat nodejsapp/values.yaml'
           }
    }
  }
  post 
  {
      always
      {
          slackSend channel: 'kp-devops', message: "pipeline status -${currentBuild.currentResult}"
        }
   }
}
