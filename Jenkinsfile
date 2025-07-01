pipeline {
    agent any

    environment {
        IMAGE_NAME = 'mini-portfolio'
        TAG = 'latest'
        EC2_USER = 'ubuntu'
        EC2_HOST = '54.179.246.50'
        SSH_KEY_ID = 'ec2-app-server-ssh-key'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Save Docker Image to Tar') {
            steps {
                sh "docker save -o ${IMAGE_NAME}.tar ${IMAGE_NAME}:${TAG}"
            }
        }

        stage('Copy Image to EC2') {
            steps {
                sshagent (credentials: ["${SSH_KEY_ID}"]) {
                    sh """
                        scp -o StrictHostKeyChecking=no ${IMAGE_NAME}.tar ${EC2_USER}@${EC2_HOST}:/home/${EC2_USER}/
                    """
                }
            }
        }

        stage('Load and Run on EC2') {
            steps {
                sshagent (credentials: ["${SSH_KEY_ID}"]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
                            docker load -i ${IMAGE_NAME}.tar &&
                            docker stop ${IMAGE_NAME} || true &&
                            docker rm ${IMAGE_NAME} || true &&
                            docker run -d --name ${IMAGE_NAME} -p 80:80 ${IMAGE_NAME}:${TAG}
                        '
                    """
                }
            }
        }
    }

    post {
        always {
            sh "rm -f ${IMAGE_NAME}.tar"
        }
    }
}
