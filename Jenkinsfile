pipeline {
    agent any

    environment {
        timestamp = "${new Date().format('yyyyMMddHHmmss')}" 
    }

    stages {
        stage('Authenticate with Docker Hub') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-account', url: 'https://index.docker.io/v1/') {
                    echo 'Logged in to Docker Hub'
                }
            }
        }

        stage('Build image') {
            steps {
                sh '''
                docker build  ./api_gateway --file ./api_gateway/Dockerfile --tag chucthien03/gateway-service:${timestamp}
                docker build  ./auth_service --file ./auth_service/Dockerfile --tag chucthien03/auth-microservice:${timestamp}
                docker build  ./comment_service --file ./comment_service/Dockerfile --tag chucthien03/comment-service:${timestamp}
                docker build  ./frontend --file ./frontend/Dockerfile --tag chucthien03/mern-stack-frontend:${timestamp}
                docker build  ./post_service --file ./post_service/Dockerfile --tag chucthien03/post-microservice:${timestamp}
                '''
            }
        }

        stage('Scan images with Trivy') {
            steps {
                sh '''
                    # Ensure the file exists and is writable
                    touch ${WORKSPACE}/trivy-report.txt
                    chmod +w ${WORKSPACE}/trivy-report.txt

                    # Remove the file if it exists
                    if [ -f ${WORKSPACE}/trivy-report.txt ]; then
                        rm ${WORKSPACE}/trivy-report.txt
                    fi
                    trivy image --severity HIGH,CRITICAL chucthien03/gateway-service:${timestamp} >> ${WORKSPACE}/trivy-report.txt
                    trivy image --severity HIGH,CRITICAL chucthien03/auth-microservice:${timestamp} >> ${WORKSPACE}/trivy-report.txt
                    trivy image --severity HIGH,CRITICAL chucthien03/comment-service:${timestamp} >> ${WORKSPACE}/trivy-report.txt
                    trivy image --severity HIGH,CRITICAL chucthien03/mern-stack-frontend:${timestamp} >> ${WORKSPACE}/trivy-report.txt
                    trivy image --severity HIGH,CRITICAL chucthien03/post-microservice:${timestamp} >> ${WORKSPACE}/trivy-report.txt
                '''
            }
        }

        stage('Push images to Docker Hub') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-account', url: 'https://index.docker.io/v1/') {
                    echo 'Pushing images to Docker Hub...'
                    sh '''
                        docker push chucthien03/gateway-service:${timestamp}
                        docker push chucthien03/auth-microservice:${timestamp}
                        docker push chucthien03/comment-service:${timestamp}
                        docker push chucthien03/mern-stack-frontend:${timestamp}
                        docker push chucthien03/post-microservice:${timestamp}
                    '''
                }
            }
        }

        stage('Clean up Docker images') {
            steps {
                echo 'Removing local Docker images...'
                sh '''
                    docker rmi chucthien03/gateway-service:${timestamp} || true
                    docker rmi chucthien03/auth-microservice:${timestamp} || true
                    docker rmi chucthien03/comment-service:${timestamp} || true
                    docker rmi chucthien03/mern-stack-frontend:${timestamp} || true
                    docker rmi chucthien03/post-microservice:${timestamp} || true
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning...'
            sh 'docker logout'
        }
        success {
            echo 'Deployment to Dev Environment is successful!'
            emailext from: 'tranchucthienmt@gmail.com',
                     to: 'tranchucthienmt@gmail.com',
                     subject: "Pipeline Success: ${currentBuild.fullDisplayName}",
                     body: "Pipeline completed successfully. Find attached Trivy report.",
                     attachmentsPattern: 'trivy-report.txt'
        }
        failure {
            echo 'Deployment to Dev Environment failed!'
            emailext from: 'tranchucthienmt@gmail.com',
                     to: 'tranchucthienmt@gmail.com',
                     subject: "Pipeline Failure: ${currentBuild.fullDisplayName}",
                     body: "Pipeline failed. Please check the logs for details.",
                     attachmentsPattern: 'trivy-report.txt'
        }
        unstable {
            echo 'Deployment to Dev Environment is unstable!'
            emailext from: 'tranchucthienmt@gmail.com',
                     to: 'tranchucthienmt@gmail.com',
                     subject: "Pipeline Unstable: ${currentBuild.fullDisplayName}",
                     body: "Pipeline completed but unstable."
        }
        changed {
            echo 'Deployment to Dev Environment is changed!'
            emailext from: 'tranchucthienmt@gmail.com',
                     to: 'tranchucthienmt@gmail.com',
                     subject: "Pipeline Changed: ${currentBuild.fullDisplayName}",
                     body: "Pipeline state changed."
        }
    }
}
