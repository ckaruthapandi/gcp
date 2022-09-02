pipeline {
  agent any
  stages {
    stage('node js check out ') {
      steps {
        sh 'rm -rf "${WORKSPACE}"/.[a-z]*'
        git branch: 'main', url: 'https://github.com/ckaruthapandi/ap_Node_js_app.git'
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
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 581962848636.dkr.ecr.us-east-1.amazonaws.com'
                sh 'docker tag aatmaaniproject:latest 581962848636.dkr.ecr.us-east-1.amazonaws.com/aatmaaniproject:$BUILD_NUMBER'
                sh 'docker push 581962848636.dkr.ecr.us-east-1.amazonaws.com/aatmaaniproject:$BUILD_NUMBER'
                    
         }
        }
      }
    stage('helm repo check out ') {
      steps {
        git branch: 'main', url: 'https://github.com/ckaruthapandi/ap_helm_node_js_dev.git'
      }
    }
     stage('deploy to helm ') {
      steps {
            sh 'kubectl apply -f my-namespace.yaml'
            sh 'sed -i s/latest/$BUILD_NUMBER/g nodejsapp/values.yaml'
            sh 'cat nodejsapp/values.yaml'
            sh 'helm upgrade --install nodejsdev nodejsapp --values nodejsapp/values.yaml -n dev'
      }
    }
  }
  post 
  {
      always
      {
          slackSend channel: 'kp-devops', message: "pipeline status -${currentBuild.currentResult}"
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true,
                    patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                               [pattern: '.propsfile', type: 'EXCLUDE']])
        }
   }
}
