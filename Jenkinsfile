#!groovy



pipeline {
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        disableConcurrentBuilds()
    }
    triggers {
        cron('H * * * *')
        pollSCM('*/5 * * * *')
    }
    agent {
        kubernetes {
            label 'terratest'
            defaultContainer 'jnlp'
            yamlFile '.ci/dind.yml'
        }
    }
    stages {
        stage('Pre flight check') {
            steps {
                container('terragrunt') {
                    sh 'terragrunt --version'
                    sh 'terraform version'
                }
            }
        }

        stage('Terragrunt init') {
            steps {
                timeout(time: 3, unit: 'MINUTES') {
                    retry(5) {
                        container('terragrunt') {
                            sshagent (credentials: ['']) {
                                sh 'cd code/eu-west-2/guardduty && terragrunt init -input=false'
                            }
                        }
                    }
                }
            }
        }

        stage('Terragrunt plan') {
                steps {
                    timeout(time: 3, unit: 'MINUTES') {
                        retry(5) {
                            container('terragrunt') {
                                sshagent (credentials: ['']) {
                                    sh 'cd code/eu-west-2/guardduty && terragrunt plan --terragrunt-source-update'
                            }
                        }
                    }
                }
            }
        }

        stage('Terragrunt apply') {
            steps {
                timeout(time: 3, unit: 'MINUTES') {
                    retry(5) {
                        container('terragrunt') {
                            sshagent (credentials: ['']) {
                                sh 'cd code/eu-west-2/guardduty && terragrunt apply --auto-approve'
                            }
                        }
                    }
                }
            }
        }
    }
}