
def projectName = "cicdsimmigon"
def packageFolder = "${projectName}"
def majVersion = '0'
def minVersion = '0'
def relVersion = '1'

def version = "${majVersion}.${minVersion}.${relVersion}.${env.BUILD_NUMBER}"
def packageName = "${projectName}-${version}.tar.gz"
def packageNameLatest = "${projectName}-latest.tar.gz"
def bucketPath = "${projectName}/"
def dkrWorkdir = "/app"
def versionedFile = "app.py"
def slackChannel = "#cloudpod-feed-dev"

try {
    node('master'){
        withCredentials([string(credentialsId: 'cloudpod-slack-token', variable: 'SLACKTOKEN'),
                         string(credentialsId: 'cloudpod-slack-org', variable: 'SLACKORG'),
                         string(credentialsId: 's3-bucket-general-COPS-builds', variable: 'S3BUCKET')]) 
        {
            stage('hello') {
                print "hello"
            }
            try {
                stage('cleanup') {
                    deleteDir()
                }
            } catch (error){
                print "Error deleting existing workspace"
                print error
            }
            stage ('checkout source') {
                checkout scm
                sh "echo workspace path = ${env.WORKSPACE}"
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
} catch (error) {
    withCredentials([string(credentialsId: 'cloudpod-slack-token', variable: 'SLACKTOKEN'),
                     string(credentialsId: 'cloudpod-slack-org', variable: 'SLACKORG')])
    {
        stage ('notify failure') {
            slackSend channel: "${slackChannel}", color: 'bad', message: "${projectName} build FAILED ${env.BUILD_URL}. Error was: ${error}", teamDomain: "${SLACKORG}", token:"${SLACKTOKEN}"   
        }
    }
}
