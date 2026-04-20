pipeline {
    agent any

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

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} -t ${DOCKER_IMAGE}:latest .'
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'akshay1280', variable: 'DOCKER_PASS')]) {
                        sh 'echo ${DOCKER_PASS} | docker login -u akshay1280 --password-stdin'
                    }
                }
                sh 'docker push ${DOCKER_IMAGE}:${IMAGE_TAG}'
                sh 'docker push ${DOCKER_IMAGE}:latest'
            }
        }

        stage('Configure EKS') {
            steps {
                sh 'aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deploymentservice.yaml'
                sh 'kubectl set image deployment/spring-boot-k8s-deployment spring-boot-k8s=${DOCKER_IMAGE}:${IMAGE_TAG}'
            }
        }
    }
}
