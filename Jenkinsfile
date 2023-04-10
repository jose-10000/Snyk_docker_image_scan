pipeline{

	environment {
		DOCKERHUB_CREDENTIALS=credentials('jenkins-dockerhub')
		REGISTRY = "jose10000/devscanned-g3"
		DockerImage = ''
		SKYK_TOKEN = credentials('snykID')
	}

	agent any

	stages {
		stage('gitclone') {

			steps {
				git branch: 'main', url: 'https://github.com/jose-10000/Snyk_docker_image_scan.git'
			}
		}

		stage('Build') {

			steps {
				echo 'Building..'
				sh 'docker build -t jose10000/devscanned-g3:v1.$BUILD_NUMBER .'
			}
		}

		stage('Scan') {

			steps {
				echo 'Scanning..'
				script {
					snykSecurity severity: 'critical', snykInstallation: 'Snyk-grupo3', snykTokenId: '$SKYK_TOKEN', targetFile: 'jose10000/devscanned-g3:v1.$BUILD_NUMBER'
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
				sh 'docker push jose10000/devscanned-g3:v1.$BUILD_NUMBER'
			}
		}

	}
//	post {
//        always {
//        // Se eliminan las imagenes creadas
//            echo 'Se elimina la imagen creada'
//            sh "docker rmi jose10000/devscanned-g3:v1.$BUILD_NUMBER"
//        }
// //   }
}