pipeline{

	environment {
		DOCKERHUB_CREDENTIALS=credentials('jenkins-dockerhub')
		REGISTRY = "jose10000/dev-grupo3-scanned:v1.$BUILD_NUMBER"
		DockerImage = ''
		SNYK_TOKEN=credentials('snykID')
	}

	agent any

	stages {
		stage('gitclone') {

			steps {
				git branch: 'main', url: 'https://github.com/jose-10000/dev-grupo3.git'
			}
		}

		stage('Build') {

			steps {
				echo 'Building..'
				sh 'docker build -t $REGITRY .'
			}
		}

		stage('Scan') {

			steps {
				echo 'Scanning..'
				script {
					snykSecurity severity: 'critical', snykInstallation: 'snyk', snykToken: snykID
					def snykReport = sh(
						script: 'snyk container test $REGISTRY --severity-threshold=critical',
						returnStatus: true)

				echo "Snyk report: ${snykReport}"
				if (snykReport != 0) {
					error('Snyk found critical vulnerabilities')
				}
			}
		}

		stage('Login') {

			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}

		stage('Push') {

			steps {
				sh 'docker push REGISTRY'
			}
		}

	}
	post {
        always {
        // Se eliminan las imagenes creadas
            echo 'Se elimina la imagen creada'
            sh "docker rmi $REGISTRY"
        }
    }
}