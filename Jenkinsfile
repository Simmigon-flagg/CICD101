// pipeline script to build a simple project and push build to s3 bucket
// depends on credentials being set up in Jenkins ahead of time

def projectName = "cicdsimmigon"
def packageFolder = "${projectName}"
def majVersion = '0'
def minVersion = '0'
def relVersion = '1'

def version = "${majVersion}.${minVersion}.${relVersion}.${env.BUILD_NUMBER}"
def packageName = "${projectName}-${version}.tar.gz"
def packageNameLatest = "${projectName}-latest.tar.gz"

node('master'){
    stage('hello') {
        print "hello"
    }
    stage('cleanup') {
        deleteDir()
    }
    stage ('checkout source') {
        checkout scm
        sh "echo workspace path = ${env.WORKSPACE}"
    }
    stage ('run the script') {
        sh "python ${packageFolder}/app.py"
    }
}
