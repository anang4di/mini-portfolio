pipeline {
    agent any

    environment {
        IMAGE_NAME = 'mini-portfolio'
        TAG = 'latest'
        SSH_KEY_ID = 'ec2-app-server-ssh-key'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('sonarqube') {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }

        stage('Gitleaks Scan') {
            steps {
                sh '''
                    gitleaks detect \
                        --source=. \
                        --report-format=json \
                        --report-path=gitleaks-report.json \
                        --exit-code 1
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$TAG .'
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh '''
                    trivy image \
                        --format json \
                        --output trivy-report.json \
                        --exit-code 1 \
                        --severity HIGH,CRITICAL \
                        $IMAGE_NAME:$TAG
                '''
            }
        }

        stage('Save Docker Image to Tar') {
            steps {
                sh 'docker save -o $IMAGE_NAME.tar $IMAGE_NAME:$TAG'
            }
        }

        stage('Copy Image to EC2') {
            steps {
                withCredentials([
                    string(credentialsId: 'ec2-host', variable: 'EC2_HOST'),
                    string(credentialsId: 'ec2-user', variable: 'EC2_USER')
                ]) {
                    sshagent (credentials: [SSH_KEY_ID]) {
                        sh '''
                            scp -o StrictHostKeyChecking=no $IMAGE_NAME.tar $EC2_USER@$EC2_HOST:/home/$EC2_USER/
                        '''
                    }
                }
            }
        }

        stage('Load and Run on EC2') {
            steps {
                withCredentials([
                    string(credentialsId: 'ec2-host', variable: 'EC2_HOST'),
                    string(credentialsId: 'ec2-user', variable: 'EC2_USER')
                ]) {
                    sshagent (credentials: [SSH_KEY_ID]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST '
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

    }

    post {
        always {
            sh 'rm -f $IMAGE_NAME.tar || true'
            archiveArtifacts artifacts: '*.json', allowEmptyArchive: true
        }
    }
}
