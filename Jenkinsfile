// pipeline script to build a simple project and push build to s3 bucket
// depends on credentials being set up in Jenkins ahead of time

def projectName = "cicdsimmigon"
def packageFolder = "${projectName}"
def majVersion = '0'
def minVersion = '0'
def relVersion = '1'
def dkrWorkdir = "/app"
def versionedFile = "app.py"

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
    stage ('build the build docker') {
        sh "docker build --build-arg PACKAGENAME=${packageFolder} . -t ${projectName}"
    }
    stage ('test and build code in docker') {
        sh "docker run --rm -v \"${env.WORKSPACE}/dist\":${dkrWorkdir}/dist:Z ${projectName} ${dkrWorkdir}/build.sh ${versionedFile} ${version} ${packageName} ${packageFolder}"
    }
}
