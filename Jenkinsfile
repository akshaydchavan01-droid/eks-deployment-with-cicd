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

        stage('Terraform Destroy') {
            steps {
                script {
                    dir('infra') {
                        sh 'terraform init'

                        // Safety confirmation
                        input message: 'Are you sure you want to DESTROY all infrastructure?', ok: 'Yes, Destroy'

                        sh 'terraform destroy --auto-approve'
                    }
                }
            }
        }
    }
}
