
# Solution: Task 1 - Jenkins CI/CD: Pipeline Basics

Objective: Create a basic Jenkins pipeline that builds, tests, and deploys a simple application. Document the pipeline, how to run it, and answer core interview questions for Week 1.

Summary:
- Created a declarative pipeline with stages: Checkout, Build, Test, Deploy.
- Used a simple Docker-based build for the sample Node.js app.
- Verified run by checking Jenkins console output and container status with `docker ps` on the agent.


What I did / How to run:
- Commit the `Jenkinsfile` to the repository root.
- Create a Pipeline job (or Multibranch) in Jenkins pointing at the repo.
- Trigger a build; watch console logs for each stage. On the agent, run `docker ps` to confirm the running container.

Notes and troubleshooting:
- Ensure the Jenkins agent has Docker available and proper permissions (Docker socket or service).
- If using credentials for image push, configure Jenkins credentials and use `withCredentials` or the Docker pipeline steps.

Interview Qs (Week 1):
- Q: How do declarative pipelines streamline CI/CD vs scripted pipelines?  
    A: Declarative pipelines provide a structured, opinionated syntax, clearer stage visualization, simpler error handling, and easier adoption for teams; scripted pipelines offer more flexibility but are more complex.
- Q: What are the benefits of splitting the pipeline into stages?  
	A: Stages give clear separation of concerns, easier parallelization, better visibility in UI, and simpler failure isolation and retries.
