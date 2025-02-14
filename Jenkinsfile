pipeline{
    agent any
    tools {
        terraform 'terraform-11'
    }
    stages{
        stage('Git Checkout'){
            steps{
                git branch: 'main', credentialsId: 'GitHub', url: 'https://github.com/vishnuanandr/iac-demo'
            }
        }
        stage('Terraform Init'){
            steps{
                ansiColor('xterm'){
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Refresh') {
            steps {
                ansiColor('xterm') {
                    sh 'terraform refresh'
                }
            }
        }
        stage('Terraform Apply'){
            steps{
                ansiColor('xterm'){
                sh 'terraform destroy --auto-approve'
                }
            }
        }
    }
}
