#!/usr/bin/env groovy
pipeline {
    agent any
    stages {
        stage('Git Checkout') {
            steps {
                script {
                    git branch: 'main',
                        url: 'https://github.com/ckaruthapandi/gcp.git'
                }
            }
        }
    }
}
