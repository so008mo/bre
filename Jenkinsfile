def KEY_ID = env.AWS_ACCESS_KEY;
def ACCESS_KEY = env.AWS_SECRET_ACCESS_KEY;

node('docker'){
    stage('checkout'){
        deleteDir()
        git changelog: false, credentialsId: 'gcs-cicd-s', poll: false, url: 'https://gitlab.pitneycloud.com/gcs/inkubator.git'
    }
    stage('build'){
        withCredentials([[$class          : 'UsernamePasswordMultiBinding',
                            credentialsId   : 'gcs-cicd-s',
                            usernameVariable: 'GIT_USERNAME',
                            passwordVariable: 'GIT_PASSWORD']]) {
            sh "git init"
            sh "git config credential.username ${env.GIT_USERNAME}"
            sh "git config credential.helper '!echo password=\$GIT_PASSWORD; echo'"
        }
    }
    stage('deploy'){
	    def dockerEnv = docker.build 'gcs/eks-utils'
        def workspace = WORKSPACE
		
                    dockerEnv.inside("-u 0"){
                        sh 'cp -r . /tmp/deploy'
                        sh "cd /tmp/deploy && AWS_ACCESS_KEY_ID=$KEY_ID AWS_SECRET_ACCESS_KEY=$ACCESS_KEY ansible-playbook eks.yml --extra-vars \"region=${env.REGION} env=${env.ENVIRONMENT}\" -vvv"
                    }
                }
            }