@Library("Shared")_
pipeline{
    agent { label "dev" }
    
    stages{
        stage("Code"){
            steps{
                script{
                    clone("https://github.com/shashank-2310/node-todo-cicd.git", "master")
                }
            }
        }
        stage("Build"){
            steps{
                sh "docker build -t node-app ."
            }
        }
        stage("Push"){
            steps{
                script{
                    docker_push("dockerHubCreds","node-app", "latest")
                }
            }
        }
        stage("Test"){
            steps{
                echo "Testing.......!"
            }
        }
        stage("Deploy"){
            steps{
                sh "docker compose down && docker compose up -d"
            }
        }
    }
}