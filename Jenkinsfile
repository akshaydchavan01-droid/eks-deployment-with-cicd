pipeline {
    agent any
    parameters {
        choice(
            name: 'ACTION', 
            choices: ['apply', 'destroy'], 
            description: 'Choose action: apply to create resources, destroy to delete resources'
        )
    }
    environment {
        AWS_REGION = 'ap-south-1'
        CLUSTER_NAME = 'akshay-cluster-v01'
        DOCKER_IMAGE = 'akshay1280/devops-integration'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Maven') {
            steps {
                sh 'chmod +x mvnw'
                sh './mvnw clean package'
            }
        }
        stage('Build docker image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} -t ${DOCKER_IMAGE}:latest .'
                }
            }
        }
        stage('Push image to Hub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'akshay1280', variable: 'akshay1280')]) {
                        sh 'echo ${dockerhubpwd} | docker login -u akshay1280 --password-stdin'
                    }
                    sh 'docker push ${DOCKER_IMAGE}:${IMAGE_TAG}'
                    sh 'docker push ${DOCKER_IMAGE}:latest'
                }
            }
        }
        stage('EKS Creation') {
            steps {
                script {
                    dir('infra') {
                        sh 'terraform init'
                        if (params.ACTION == 'apply') {
                            echo 'Executing Apply...'
                            sh 'terraform apply --auto-approve'
                        } else if (params.ACTION == 'destroy') {
                            echo 'Executing Destroy...'
                            sh 'terraform destroy --auto-approve'
                        } else {
                            error 'Unknown action'
                        }
                    }
                }
            }
        }
        stage('EKS and Kubectl configuration') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    sh 'aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}'
                }
            }
        }
        stage('Deploy to k8s') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    sh 'kubectl apply -f deploymentservice.yaml'
                    sh 'kubectl set image deployment/spring-boot-k8s-deployment spring-boot-k8s=${DOCKER_IMAGE}:${IMAGE_TAG}'
                }
            }
        }
    }
}
