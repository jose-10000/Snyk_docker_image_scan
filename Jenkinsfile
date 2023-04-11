pipeline{

	environment {
		DOCKERHUB_CREDENTIALS=credentials('jenkins-dockerhub')
		REGISTRY = "jose10000/devscanned-g3:v1.$BUILD_NUMBER"
		DockerImage = ''
		GITHUB_CREDENTIALS=credentials('github-jenkins')
		ISSUE_TITLE = "$JOB_NAME $BUILD_DISPLAY_NAME falló"
		NPM_REPORT_FILE = "npm_audit_report.txt"
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


		stage('NPM-test'){
            steps {
				// Se instala nodeJS desde el plugin nodeJS
                nodejs(nodeJSInstallationName: 'node-18-15'){
                    echo 'Realizando test antes de crear la imagen'
                    sh """
                    npm install
                    npm run test
                    """
                }
            }

        }

        stage('NPM-audit') {
            steps {
				echo 'Realizando npm audit'
				// Catcherror es para que, si encuentra fallos, el pipeline no se detenga
				// y se pueda seguir con el resto de las fases
				// https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#catcherror-catch-error-and-set-build-result-to-failure
				// Aqui si se produce un error, el estado del build pasa a ser UNSTABLE
                catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
					// Y ejecuta sin parar el resto de las fases
					sh 'npm audit > ${NPM_REPORT_FILE}'
                }
            }
        }

		// Se crea la imagen
		// Dockek se instalo en el servidor de Jenkins
		stage('Docker-build') {

			steps {
				echo 'Building..'
				sh 'docker build -t $REGISTRY .'
			}
		}

	// Para poder usar snyk, hay que instalar el plugin de snyk
    stage('Snyk-Security-Scan') {
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
		echo $? // 0 si no hay fallos, 1 si hay fallos
        }
    }

		stage('Docker-login') {

			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}
		
		stage('Push2DockerHub') {

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
        }
		unstable{
			echo 'npm audit falló'
                sh """
                echo ${GITHUB_CREDENTIALS_PSW} | gh auth login --with-token
                gh issue create -t '${ISSUE_TITLE}' -F ${NPM_REPORT_FILE} -R ${URL_REPO}
				echo 'Se ha creado un issue en el repositorio'
                """
}

}
}