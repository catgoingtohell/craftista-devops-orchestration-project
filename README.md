Craftista DevOps Orchestration Project
Project Overview
The Craftista DevOps Orchestration Project is a modern web application built with React, designed to demonstrate efficient DevOps practices. It leverages containerization, orchestration, CI/CD pipelines, and infrastructure as code (IaC) to streamline development, deployment, and management processes. This project serves as a reference for building scalable, maintainable applications using industry-standard tools.
Getting Started
Prerequisites

Node.js and npm: Install using nvm.
Docker: For containerization (installation guide).
kubectl: For Kubernetes management (installation guide).
Terraform: For IaC (installation guide).
GitHub account: For repository access and CI/CD configuration.
Cloud provider account: AWS, GCP, or Azure for Kubernetes cluster deployment.

Editing the Code
You can modify the application code in several ways:
Using Your Preferred IDE
Clone the repository and work locally:
# Clone the repository
git clone https://github.com/catgoingtohell/craftista-devops-orchestration-project.git

# Navigate to the project directory
cd craftista-devops-orchestration-project

# Install dependencies
npm install

# Start the development server with auto-reloading
npm run dev

Editing Directly in GitHub

Navigate to the desired file in the repository.
Click the "Edit" button (pencil icon) at the top right.
Make changes and commit them.

Using GitHub Codespaces

Go to the repository's main page.
Click the green "Code" button and select the "Codespaces" tab.
Click "New codespace" to launch a cloud-based development environment.
Edit files and commit/push changes.

Technologies Used
The project is built with:

Frontend:

Vite: Fast build tool for modern web development.
TypeScript: Static typing for enhanced developer experience.
React: JavaScript library for building user interfaces.
shadcn-ui: Accessible UI component library.
Tailwind CSS: Utility-first CSS framework for styling.


DevOps:

Docker: Containerization of the application.
Kubernetes: Orchestration and deployment management.
GitHub Actions: CI/CD pipeline automation.
Terraform: Infrastructure as code provisioning.



DevOps Documentation
The following sections outline the DevOps processes for building, testing, deploying, and managing the application, as detailed in the project's DevOps documentation.
Project Structure
The repository is organized as follows:
├── .github/workflows/        # GitHub Actions workflows for CI/CD
├── k8s/                      # Kubernetes manifests
├── terraform/                # Terraform configurations for IaC
├── src/                      # React application source code
├── Dockerfile                # Docker configuration for the app
├── package.json              # Node.js dependencies and scripts
├── vite.config.ts            # Vite configuration
└── README.md                 # Project documentation

Continuous Integration and Continuous Deployment (CI/CD)
The project uses GitHub Actions to automate the CI/CD pipeline. The workflows are defined in .github/workflows/.
CI Pipeline

Trigger: Pull requests or pushes to the main branch.
Steps:
Linting: Runs npm run lint to enforce code quality.
Testing: Executes npm test for unit and integration tests.
Build: Runs npm run build to create a production-ready artifact.
Docker Build: Builds a Docker image if tests pass.



CD Pipeline

Trigger: Successful merge to the main branch.
Steps:
Build Docker Image: Creates and tags the image.
Push to Docker Hub: Pushes the image to a registry (requires DOCKER_HUB_TOKEN secret).
Deploy to Kubernetes: Applies Kubernetes manifests using kubectl (requires KUBE_CONFIG secret).



To configure secrets:

Go to the repository's Settings > Secrets and variables > Actions.
Add DOCKER_HUB_TOKEN for Docker Hub access.
Add KUBE_CONFIG for Kubernetes cluster access.

Containerization with Docker
The application is containerized using Docker. The Dockerfile defines the build process:

Uses a Node.js base image.
Installs dependencies and builds the React app.
Serves the app using a lightweight server (e.g., serve).

To build and test the Docker image locally:
# Build the image
docker build -t craftista-app:latest .

# Run the container
docker run -p 3000:3000 craftista-app:latest

Push the image to Docker Hub:
# Login to Docker Hub
docker login

# Tag the image
docker tag craftista-app:latest <your-username>/craftista-app:latest

# Push the image
docker push <your-username>/craftista-app:latest

Kubernetes Orchestration
Kubernetes is used to manage application deployment and scaling. Manifests are stored in the k8s/ directory:

Deployment: Defines the application pods and replicas.
Service: Exposes the application within the cluster.
Ingress: Routes external traffic to the service.

To deploy to a Kubernetes cluster:
# Apply manifests
kubectl apply -f k8s/

Ensure your cluster is configured with kubectl and has an ingress controller (e.g., NGINX) installed.
Infrastructure as Code with Terraform
Terraform is used to provision cloud infrastructure, such as an AWS EKS cluster. Configurations are in the terraform/ directory.
To provision infrastructure:
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply

Ensure you have AWS credentials configured (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY) and the AWS CLI installed.
Monitoring and Logging

Monitoring: Use Kubernetes tools like Prometheus and Grafana for cluster monitoring (setup instructions in k8s/monitoring/ if available).
Logging: Application logs are accessible via kubectl logs. Consider integrating with a logging service like ELK or CloudWatch.

Custom Domain Configuration
To connect a custom domain:

Update DNS settings in your domain registrar to point to the Kubernetes ingress or load balancer IP/hostname.
Modify k8s/ingress.yaml to include your domain.
Apply the updated ingress:

kubectl apply -f k8s/ingress.yaml

Refer to your cloud provider's DNS documentation or the Kubernetes Ingress guide.
Deployment Instructions
To deploy the application:

Set Up CI/CD:

Configure GitHub Actions secrets as described above.
Ensure workflows in .github/workflows/ are valid.


Build and Push Docker Image:

Follow the Docker section to build and push the image.


Deploy to Kubernetes:

Apply Kubernetes manifests as described.


Provision Infrastructure:

Use Terraform to set up the cloud environment.


Verify Deployment:

Check pod status with kubectl get pods.
Access the application via the ingress URL or custom domain.



Troubleshooting

CI/CD Failures: Check GitHub Actions logs for errors. Verify secrets and workflow syntax.
Docker Issues: Ensure Docker is running and the Dockerfile is correct.
Kubernetes Errors: Use kubectl describe or kubectl logs to diagnose pod or ingress issues.
Terraform Errors: Verify AWS credentials and Terraform configuration.

Additional Resources

Docker Documentation
Kubernetes Documentation
Terraform Documentation
GitHub Actions Documentation
Vite Documentation
React Documentation
Tailwind CSS Documentation
