Deployment Notes for java-spring-project -
High-Level Documentation of the Solution Architecture
Solution Overview
This solution is a containerized Java Spring Boot application with a React frontend packaged as a deployable JAR file. The application is designed for deployment in the Azure Cloud, leveraging a fully managed infrastructure.

Architecture Components (Resource Visualization)
Architecture flow


Deployment Flow
Fork and Prepare Repository:
Code is stored in a GitHub repository, ready for CI/CD.
CI/CD Integration:
Two Major Azure DevOps pipelines manage deployment:
IaC Pipelines: Provisions cloud infrastructure using Terraform.
Build and Deployment Pipeline: Tests, builds, pushes Docker images, and deploys the container to Azure App Service.
Azure Infrastructure:
Provisioned infrastructure includes a Container Registry, App Service Plan, App Service, and Application Insights and were created using terraform.
Runtime Execution:
The application runs as a Docker container within Azure App Service, with metrics monitored via Application Insights.
Step-by step
1. Repository Setup
Clone the GitLab repository provided:
git clone
Move the cloned repository to your GitHub:
Create a new GitHub repository named java-spring-project.
Push the code to GitHub:
cd <cloned-repo-directory> git remote set-url origin https://github.com/Dev-Olawale/spring-boot-react-example.git
push -u origin main

2. Local Testing
Environment Setup:
Ensure all dependencies are installed:
mvn -v # Check Maven installation node -v # Check Node.js version npm -v # Check npm version docker -v # Verify Docker installation
Update Node.js to v16.20.0 and npm to 8.19.4 if required.
Build and Package:
Make Maven wrapper scripts executable:
chmod +x ./mvnw ./mvnw.cmd
Build the project:
./mvnw clean package
Verify the JAR file in the target directory.
Dockerize Application:
Build Docker image:
docker build -t springboot-react-app .
Run the container:
docker run -d -p 8080:8080 --name springboot-react-container springboot-react-app
Testing:
Frontend: Verify the app at http://localhost:8080.

3. Azure DevOps Integration
Azure DevOps Project Setup:
Create a project in Azure DevOps named java-spring-project.
Variable Group Configuration:
Navigate to Pipelines > Library in Azure DevOps.
Create a Variable Group named springboot-react and add the following environment variables:
clientId: The application ID of the Azure Service Principal.
clientSecret: The secret key of the Azure Service Principal.
tenantId: The tenant ID from Azure Active Directory.
subscriptionId: The Azure subscription ID.
Ensure all pipelines have permissions to access the variable group:
Navigate to the Variable Group settings and grant pipeline access.
4. Pipeline Configuration
Infrastructure as Code (IaC) Pipeline:
Add iac-pipeline.yml in the repository.
Configure the pipeline:
Navigate to Pipelines > New Pipeline.
Select GitHub repository and choose the YAML file.
Reference the variable group in the pipeline:
variables: - group: springboot-react
Use the project variables in Terraform deployment commands:
terraform init \-backend-config="storage_account_name=$(storageAccountName)" \ -backend-config="container_name=$(containerName)" \ -backend-config="key=$(backendKey)" \ -backend-config="access_key=$(storageAccountKey)"
terraform apply \ -var "client_id=$(clientId)" \ -var "client_secret=$(clientSecret)" \ -var "tenant_id=$(tenantId)" \ -var "subscription_id=$(subscriptionId)"
Queue the pipeline manually to provision:
Azure Storage Account
Container Registry
App Service Plan
App Service
Application Insights
Build and Deployment Pipeline:
Add azure-pipeline.yml in the repository.
Configure the pipeline:
Reference the springboot-react variable group in the pipeline.
Use Docker commands to build and push the image:
docker login $(registryLoginServer) --username $(clientId) --password $(clientSecret) docker build -t $(registryLoginServer)/springboot-react-app:$(Build.BuildId) . docker push $(registryLoginServer)/springboot-react-app:$(Build.BuildId)
Deploy the container to Azure App Service:
- task: AzureCLI@2 inputs: azureSubscription: $(subscriptionId) scriptType: bash scriptLocation: inlineScript inlineScript: | az webapp create --name $(webAppName) \ --resource-group $(resourceGroupName) \ --plan $(appServicePlan) \ --deployment-container-image-name $(registryLoginServer)/springboot-react-app:$(Build.BuildId)

5. Validation
Monitor the IaC pipeline to confirm infrastructure provisioning.
Validate the Build and Deployment pipeline to:
Test the application.
Package with Maven.
Build and push the Docker image to Azure Container Registry.
Deploy the container to the App Service.







Here is the Cloud Architecture Resources and Considerations

6. Troubleshooting f
Review logs in Azure DevOps for pipeline issues.
For local issues:
Check container logs:
docker logs springboot-react-container
Verify port conflicts:
lsof -i :8080

Instructions to Fork, Configure, and Deploy the Solution
1. Fork the Repository
Navigate to the source GitHub repository containing the solution.
Click the Fork button at the top-right corner of the page.
Choose the account (personal or organization) where you want to fork the repository.
Confirm that the forked repository is now available under your GitHub account.

2. Configure the Forked Repository
Clone the Forked Repository:
git clone https://USERNAME:TOKEN@github.com/USERNAME/REPO
Set Up Azure DevOps Pipelines:
Create an Azure DevOps Project:
Log in to Azure DevOps and create a new project (e.g., java-spring-project).
Create a Variable Group:
Navigate to Pipelines > Library.
Create a Variable Group named springboot-react and add environment variables:
clientId, clientSecret, tenantId, and subscriptionId from your Azure Service Principal.

Variables were chosen because:
Custom Authentication Requirements: The  Azure infrastructure uses a Service Principal, and its credentials (clientId, clientSecret, etc.) need to be passed explicitly in commands (e.g., az login or Terraform scripts).
Environment-Specific Configuration: The variable group allows easy swapping of credentials for different environments (e.g., Dev, Prod) without changing the pipeline configuration.
Granular Permissions: By using variables, I ensured each pipeline has access only to the specific credentials it needs.
Grant Permissions:
Ensure all pipelines have permission to use the variable group.
Update the Repository for Your Environment:
Adjust Terraform configuration (variables.tf) with your Azure resource details:
Azure Storage Account, Container Registry, App Service Plan, etc.
Update the pipeline YAML files (iac/azure-pipeline.yml and azure-pipeline.yml) if necessary, to reflect your environment names and configurations.

3. Deploy the Solution
Run the Infrastructure as Code (IaC) Pipeline:
Navigate to Pipelines > New Pipeline.
Navigate to Pipelines to create the build and deployment pipeline
Select where your code is, that is GitHub
Authenticate with your GitHub account
Select the GitHub target repository,
Select “Existing Azure Pipelines YAML file”
Store other necessary pipeline variables
Then save and queue.
Select the repository and the iac/azure-pipeline.yml file.
Queue the pipeline to provision:
Azure Storage Account
Azure Container Registry
App Service Plan
App Service
Application Insights
Run the Build and Deployment Pipeline for the application:
Navigate to Pipelines > New Pipeline.
Select the repository and the azure-pipeline.yml file.
Queue the pipeline to:
Test and package the application using Maven.
Build and push the Docker image to the Container Registry.
Deploy the containerized application to Azure App Service.


Additional Note
1. Using Linux Self-Hosted Agents
Instead of using the default Microsoft-hosted agents, I chose to use Linux self-hosted agents for running your Azure DevOps pipelines. This allowed me to have full control over the environment and install custom dependencies as required for your deployment.
How It Was Done:
I installed and configured a Linux machine to act as the self-hosted agent.
The agent was registered with my Azure DevOps organization, ensuring it was part of the pipeline pool and available for tasks.
2. Manually Installing Dependencies (Maven, Docker, Terraform, Azure CLI)
To ensure the pipeline had all the necessary tools for the deployment, I manually installed the required dependencies on the self-hosted Linux agent. This is important for custom environments where the Microsoft-hosted agents may not have all the necessary software pre-installed.
How It Was Done:
Maven:
Installed Maven to manage Java-based projects.
Typically done using the package manager:
sudo apt update
sudo apt install maven
Docker:
Docker was installed to build and push Docker images to Azure Container Registry (ACR).
Installed Docker on the self-hosted agent with:
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
Terraform:
Installed Terraform to manage infrastructure as code (IaC) for provisioning resources on Azure.
Downloaded Terraform from the official site and installed:
sudo apt-get update
sudo apt-get install terraform
Azure CLI:
Azure CLI was installed to interact with Azure resources from the command line.
Installation on Linux:
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
These tools were installed manually on the Linux self-hosted agent, ensuring that the pipeline runs on an environment tailored for the deployment requirements.

3. Adding Approval and Checks to the Variable Group
I added approval and checks to the variable group to ensure that no pipeline could run without proper approval from the designated approvers, adding an extra layer of control over the deployment process.
How It Was Done:
In Azure DevOps, I configured Approvals and Checks on the variable group.
Set up myself (Olawale) as the approver for all approval steps.
Configured the pipeline so that all approvers must explicitly approve the pipeline before it could be executed, ensuring controlled deployment to production.
To configure approvals in Azure DevOps:
Go to Pipelines → Library.
Select the variable group you want to add approvals to.
Under the Approvals and Checks section, click Add Check and choose Approval.
Set the approvers (yourself, in this case) and enable the option for all approvers to approve before the pipeline runs.

4. Enabling HTTPS for the Web App
To ensure your web application runs securely, you enabled HTTPS. This ensures that the app is served over a secure connection, providing encryption for data in transit.
How It Was Done:
You configured the web app to ensure HTTPS is enabled. This could involve configuring the web server or setting up a valid SSL certificate for the app.
This is typically done either through Azure App Service settings or within the infrastructure as code (Terraform) by adding an appropriate configuration to enforce HTTPS.
I made use of terraform by adding   “https_only  = true”

Screenshots
My self-host Agent


Waiting for review


Infra deployment

Pipeline Deployment Status





Portal view

App is secured


