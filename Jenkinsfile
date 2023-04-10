pipeline{

	environment {
		DOCKERHUB_CREDENTIALS=credentials('jenkins-dockerhub')
		REGISTRY = "jose10000/devscanned-g3:v1.$BUILD_NUMBER"
		DockerImage = ''
		GITHUB_CREDENTIALS=credentials('github-jenkins')
		ISSUE_TITLE = "$JOB_NAME $BUILD_DISPLAY_NAME falló"
		NPM_ISSUE_FILE = "npm_audit_report.txt"
		URL_REPO = "https://github.com/jose-10000/Snyk_docker_image_scan.git"
	//	SNYK_TOKEN=credentials('snykID') si usas esto da error
	}

	agent any


	stages {
		stage('gitclone') {
			steps {
				echo 'Cloning..'
				git branch: 'main', url: 'https://github.com/jose-10000/Snyk_docker_image_scan.git'
			}
		}

		stage('Test'){
            steps {
                nodejs(nodeJSInstallationName: 'node-18-15'){
                    echo 'Realizando test antes de crear la imagen'
                    sh """
                    npm install
                    npm run test
                    """
                                    }
            }
//            post{
//                failure {
//                    nodejs(nodeJSInstallationName: 'node-18-15'){
//                        sh 'npm audit > ${NPM_REPORT_FILE}'
//                        withCredentials([
//                            usernamePassword(credentialsId: '$GITHUB_CREDENTIALS', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')
//                        ]){
//                            sh """
//                            echo ${GIT_TOKEN} | gh auth login --with-token
//                            gh issue create -t '${ISSUE_TITLE}' -F ${NPM_REPORT_FILE} -R ${URL_REPO}
//							echo 'Se ha creado un issue en el repositorio'
//                            """
//                        }    
//                    }
//                }
//        }
        }
		stage('NPM_Audit'){
			
		steps{
			nodejs (nodeJSInstallationName: 'node-18-15'){
            sh 'npm audit > ${NPM_REPORT_FILE}'
            withCredentials([
                usernamePassword(credentialsId: '$GITHUB_CREDENTIALS', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')
            ]){
                sh """
                echo ${GIT_TOKEN} | gh auth login --with-token
                gh issue create -t '${ISSUE_TITLE}' -F ${NPM_REPORT_FILE} -R ${URL_REPO}
				echo 'Se ha creado un issue en el repositorio'
                """
			}
		}
		}
		}
		stage('Build') {

			steps {
				echo 'Building..'
				sh 'docker build -t $REGISTRY .'
			}
		}

    stage('Scan') {
        steps {
        echo 'Testing...'
        snykSecurity(
            snykInstallation: 'Snyk-grupo3',
            snykTokenId: 'snykID',
			severity: 'high',
			failOnError: 'false',
			failOnIssues: 'false',
          // place other parameters here
			additionalArguments: '--docker $REGISTRY'
        )
        }
    }

		stage('Login') {

			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}
		
		stage('Push') {

			steps {
				sh 'docker push $REGISTRY'
			}
		}

	}

	post {
        always {
        // Se eliminan las imagenes creadas
            echo 'Se elimina la imagen creada'
            sh "docker rmi $REGISTRY"

//		script {
//                   properties([[$class: 'GithubProjectProperty',
//                   projectUrlStr: 'https://github.com/clarity-h2020/simple-table-component']])
//               }
//               step([$class: 'GitHubIssueNotifier',
//                   issueAppend: true,
//                   issueReopen: false,
//                   issueLabel: 'CI',
//                   issueTitle: '$JOB_NAME $BUILD_DISPLAY_NAME failed'])
        }
}
}


// {
//		nodejs(nodeJSInstallationName: 'node-18-15'){
//       sh 'npm audit > ${NPM_REPORT_FILE}'
//       withCredentials([
//           usernamePassword(credentialsId: '$GITHUB_CREDENTIALS', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')
//       ]){
//           sh """
//           echo ${GIT_TOKEN} | gh auth login --with-token
//           gh issue create -t '${ISSUE_TITLE}' -F ${NPM_REPORT_FILE} -R ${URL_REPO}
//			echo 'Se ha creado un issue en el repositorio'
//           """
//		}
//	}
//