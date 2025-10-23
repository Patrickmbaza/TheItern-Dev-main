pipeline {
    tools {
        jdk 'myjava'
        maven 'mymaven'
    }
    
    agent any
    
    stages {
        stage('Checkout on master') {
            agent {
                label 'master'
            }
            steps {
                echo 'Cloning...'
                git 'https://github.com/Patrickmbaza/masterproject.git'
            }
        }
        
        stage('Compile on slave1') {
            agent {
                label 'slave1'
            }
            steps {
                echo 'Compiling...'
                sh 'mvn compile'
            }
        }
        
        stage('CodeReview on slave2') {
            agent {
                label 'master'
            }
            steps {
                echo 'Code Review...'
                sh 'mvn pmd:pmd'
            }
        }
        
        stage('UnitTest on slave1') {
            agent {
                label 'master'
            }
            steps {
                echo 'Testing...'
                sh 'mvn test'
            }
            post {
                success {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Package on master') {
            agent {
                label 'master'
            }
            steps {
                echo 'Packaging...'
                sh 'mvn package'
            }
        }
    }
}

