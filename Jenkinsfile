pipeline {
    agent any

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
                   docker build ./api_gateway --file Dockerfile --tag my-image-name:$(date +%s)
                '''
            }
        }

    
        stage('Build front-end application image') {
            steps {
                sh '''
                    cp class-management-fe/Dockerfile .
                    docker compose -f docker-compose.yml build class-mangement-fe
                '''
            }
        }

       
        
        stage('Push images to Docker Hub') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-account', url: 'https://index.docker.io/v1/') {
                    echo 'Pushing images to Docker Hub...'
                    sh 'docker compose push'
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
