// pipeline script to build a simple project and push build to s3 bucket
// depends on credentials being set up in Jenkins ahead of time

def projectName = "cicdsimmigon"
def packageFolder = "${projectName}"
def majVersion = '0'
def minVersion = '0'
def relVersion = '1'
def dkrWorkdir = "/app"
def versionedFile = "app.py"
def bucketPath = "${projectName}/"y

def version = "${majVersion}.${minVersion}.${relVersion}.${env.BUILD_NUMBER}"
def packageName = "${projectName}-${version}.tar.gz"
def packageNameLatest = "${projectName}-latest.tar.gz"

node('master'){
 withCredentials([string(credentialsId: 'cloudpod-slack-token', variable: 'SLACKTOKEN'),
                         string(credentialsId: 'cloudpod-slack-org', variable: 'SLACKORG'),
                         string(credentialsId: 's3-bucket-general-COPS-builds', variable: 'S3BUCKET')]) 
        {
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
    stage ('artifact upload') {
                awsIdentity()
                sh "/usr/bin/aws s3 cp ./dist/${packageName} s3://${S3BUCKET}/${bucketPath}${packageName}"
                sh "/usr/bin/aws s3 cp ./dist/${packageName} s3://${S3BUCKET}/${bucketPath}${packageNameLatest}"
            }
    stage ('build and run packaging tester') {
                dir("./package-testing") {
                    sh "docker build . -t ${projectName}-tester"
                }
                sh "docker run ${projectName}-tester ./test.sh ${S3BUCKET}/${bucketPath} ${packageName}"
            }
     stage ('notify') {
                slackSend channel: "${slackChannel}", color: 'good', message: "${projectName} build SUCCESS. Package: https://s3.amazonaws.com/${S3BUCKET}/${bucketPath}${packageName}", teamDomain: "${SLACKORG}", token:"${SLACKTOKEN}"  
            }
}
}
