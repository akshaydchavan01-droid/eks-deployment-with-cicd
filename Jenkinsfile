
---

## ✅ Correct Jenkinsfile (clean version)

Use this EXACT code 👇 (no backticks)

```groovy id="goodcode"
pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('infra') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                dir('infra') {
                    sh 'terraform destroy --auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo 'Infrastructure destroyed successfully'
        }
        failure {
            echo 'Destroy failed - check logs'
        }
    }
}
