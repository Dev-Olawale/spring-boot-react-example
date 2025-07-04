# Deployment Notes for `java-spring-project`

## High-Level Documentation of the Solution Architecture

### Solution Overview
This solution is a containerized Java Spring Boot application with a React frontend, packaged as a deployable JAR file. The application is designed for deployment in the Azure Cloud, leveraging a fully managed infrastructure.

---

### Architecture Components

| **Component**            | **Description**                                                                                                                                 |
|---------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| **Azure Storage Account** | A dedicated account for storing the Terraform state file. Ensures reliable state management and infrastructure provisioning for IaC pipelines. |
| **Azure Container Registry** | Stores Docker images of the application, providing secure and scalable image management. Integrates seamlessly with Azure DevOps and Azure App Service. |
| **App Service Plan**      | Manages the compute resources required to host the application. Configured for cost efficiency and scalability based on expected traffic.       |
| **Azure App Service**     | Hosts the containerized web application. Offers features like auto-scaling, high availability, and built-in monitoring and logging services.    |
| **Application Insights**  | Monitors the application's performance and usage. Provides telemetry data for debugging and optimizing the solution.                           |

---

## Deployment Flow

### Fork and Prepare Repository
1. The code is stored in a GitHub repository, ready for CI/CD.

### CI/CD Integration
1. **IaC Pipeline**: Provisions cloud infrastructure using Terraform.
2. **Build and Deployment Pipeline**: Tests, builds, pushes Docker images, and deploys the container to Azure App Service.

### Azure Infrastructure
- The infrastructure includes:
  - Azure Container Registry
  - App Service Plan
  - App Service
  - Application Insights
- All resources are created using Terraform.

### Runtime Execution
- The application runs as a Docker container within Azure App Service.
- Metrics are monitored via Application Insights.

---

## Step-by-Step Instructions

### 1. Repository Setup
1. Clone the GitLab repository:
   ```bash
   git clone https://gitlab.com/Dev-Olawale/spring-boot-react-example.git


2. Move the cloned repository to GitHub:
Create a new GitHub repository named java-spring-project.
Push the code to GitHub:
cd <cloned-repo-directory>
git remote set-url origin https://github.com/Dev-Olawale/spring-boot-react-example.git
git push -u origin main


3. Local Testing
Environment Setup
Ensure all dependencies are installed:
mvn -v    # Check Maven installation
node -v   # Check Node.js version
npm -v    # Check npm version
docker -v # Verify Docker installation

3. Update Node.js to v16.20.0 and npm to 8.19.4 if required.
Build and Package
Make Maven wrapper scripts executable

chmod +x ./mvnw ./mvnw.cmd

4. Build the project:
./mvnw clean package
Verify the JAR file in the target directory.

Dockerize Application

Build Docker image:

docker build -t springboot-react-app .

Run the container:
docker run -d -p 8080:8080 --name springboot-react-container springboot-react-app

Testing
Frontend: Verify the app at http://localhost:8080.

3. Azure DevOps Integration
Azure DevOps Project Setup
Create a project in Azure DevOps named java-spring-project.
Variable Group Configuration
Navigate to Pipelines > Library in Azure DevOps.
Create a Variable Group named springboot-react and add the following environment variables:
clientId: The application ID of the Azure Service Principal.
clientSecret: The secret key of the Azure Service Principal.
tenantId: The tenant ID from Azure Active Directory.
subscriptionId: The Azure subscription ID.
Grant pipeline permissions to the variable group.

4. Pipeline Configuration1
Infrastructure as Code (IaC) Pipeline
Add iac-pipeline.yml to the repository.
Configure the pipeline:
Reference the variable group in the pipeline:
variables:
- group: springboot-react
Use Terraform commands for deployment:
terraform init \
  -backend-config="storage_account_name=$(storageAccountName)" \
  -backend-config="container_name=$(containerName)" \
  -backend-config="key=$(backendKey)" \
  -backend-config="access_key=$(storageAccountKey)"

terraform apply \
  -var "client_id=$(clientId)" \
  -var "client_secret=$(clientSecret)" \
  -var "tenant_id=$(tenantId)" \
  -var "subscription_id=$(subscriptionId)"
Queue the pipeline to provision:
Azure Storage Account
Azure Container Registry
App Service Plan
App Service
Application Insights
Build and Deployment Pipeline
Add azure-pipeline.yml to the repository.
Configure the pipeline:
Reference the springboot-react variable group in the pipeline.
Use Docker commands:
docker login $(registryLoginServer) --username $(clientId) --password $(clientSecret)
docker build -t $(registryLoginServer)/springboot-react-app:$(Build.BuildId) .
docker push $(registryLoginServer)/springboot-react-app:$(Build.BuildId)
Deploy the container:
- task: AzureCLI@2
  inputs:
    azureSubscription: $(subscriptionId)
    scriptType: bash
    scriptLocation: inlineScript
    inlineScript: |
      az webapp create --name $(webAppName) \
      --resource-group $(resourceGroupName) \
      --plan $(appServicePlan) \
      --deployment-container-image-name $(registryLoginServer)/springboot-react-app:$(Build.BuildId)

5. Validation
Monitor the IaC pipeline to confirm infrastructure provisioning.
Validate the Build and Deployment pipeline:
Test the application.
Package with Maven.
Build and push the Docker image.
Deploy the container.

6. Troubleshooting
Check container logs:
docker logs springboot-react-container
Verify port conflicts:
lsof -i :8080