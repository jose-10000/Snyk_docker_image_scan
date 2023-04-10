pipeline{

	environment {
		DOCKERHUB_CREDENTIALS=credentials('jenkins-dockerhub')
		REGISTRY = "jose10000/devscanned-g3:v1.$BUILD_NUMBER"
		DockerImage = ''
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

		stage('Build') {

			steps {
				echo 'Building..'
				sh 'docker build -t $REGISTRY .'
			}
		}

    stage('Test') {
        steps {
        echo 'Testing...'
        snykSecurity(
            snykInstallation: 'Snyk-grupo3',
            snykTokenId: 'snykID',
			severity: 'high',
			failOnError: 'false',
			failOnIssues: 'false',
          // place other parameters here
			additionalArguments: '--docker jose10000/devscanned-g3:v1.$BUILD_NUMBER'
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
				sh 'docker push jose10000/devscanned-g3:v1.$BUILD_NUMBER'
			}
		}

	}
	}
	post {
        always {
        // Se eliminan las imagenes creadas
            echo 'Se elimina la imagen creada'
            sh "docker rmi jose10000/devscanned-g3:v1.$BUILD_NUMBER"
        }
}
