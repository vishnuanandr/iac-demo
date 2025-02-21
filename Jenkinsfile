pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }

    agent any

    tools {
        terraform 'terraform-11'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    wrap([$class: 'AnsiColor', 'colorMapName': 'xterm']) {
                        dir("terraform") {
                            git branch: 'main', credentialsId: 'GitHub_PAT', url: 'https://github.com/vishnuanandr/iac-demo.git'
                        }
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                script {
                    wrap([$class: 'AnsiColor', 'colorMapName': 'xterm']) {
                        dir("terraform") {
                            sh 'terraform init'
                            sh 'terraform plan -out=tfplan'
                            sh 'terraform show -no-color tfplan > tfplan.txt'
                        }
                    }
                }
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    wrap([$class: 'AnsiColor', 'colorMapName': 'xterm']) {
                        def plan = readFile 'terraform/tfplan.txt'
                        input message: "Do you want to apply the plan?",
                        parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                    }
                }
            }
        }

        stage('Apply') {
            steps {
                script {
                    wrap([$class: 'AnsiColor', 'colorMapName': 'xterm']) {
                        dir("terraform") {
                            sh 'terraform apply -input=false tfplan'
                        }
                    }
                }
            }
        }
    }
}
