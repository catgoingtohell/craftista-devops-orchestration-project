# Craftista DevOps Orchestration Project

## Project Overview

The **Craftista DevOps Orchestration Project** is a modern web application built with React, designed to demonstrate efficient DevOps practices. It leverages containerization, orchestration, CI/CD pipelines, and Infrastructure as Code (IaC) to streamline development, deployment, and management processes. This project serves as a reference for building scalable, maintainable applications using industry-standard tools.

---

## Getting Started

### Prerequisites

Ensure you have the following installed:

* **Node.js and npm**: Install using [nvm](https://github.com/nvm-sh/nvm).
* **Docker**: For containerization. [Installation Guide](https://docs.docker.com/get-docker/)
* **kubectl**: For Kubernetes management. [Installation Guide](https://kubernetes.io/docs/tasks/tools/)
* **Terraform**: For IaC. [Installation Guide](https://developer.hashicorp.com/terraform/install)
* **GitHub account**: For repository access and CI/CD configuration.
* **Cloud provider account**: AWS, GCP, or Azure for Kubernetes cluster deployment.

---

## Editing the Code

### Using Your Preferred IDE

```bash
# Clone the repository
git clone https://github.com/catgoingtohell/craftista-devops-orchestration-project.git

# Navigate to the project directory
cd craftista-devops-orchestration-project

# Install dependencies
npm install

# Start the development server with auto-reloading
npm run dev
```

### Editing Directly in GitHub

1. Navigate to the desired file in the repository.
2. Click the **Edit** button (pencil icon).
3. Make changes and commit them.

### Using GitHub Codespaces

1. Go to the repository’s main page.
2. Click the green **Code** button and select the **Codespaces** tab.
3. Click **New codespace** to launch a cloud-based development environment.
4. Edit files and commit/push changes.

---

## Technologies Used

### Frontend

* **Vite**: Fast build tool for modern web development.
* **TypeScript**: Static typing for enhanced developer experience.
* **React**: JavaScript library for building user interfaces.
* **shadcn-ui**: Accessible UI component library.
* **Tailwind CSS**: Utility-first CSS framework for styling.

### DevOps

* **Docker**: Containerization of the application.
* **Kubernetes**: Orchestration and deployment management.
* **GitHub Actions**: CI/CD pipeline automation.
* **Terraform**: Infrastructure as Code provisioning.

---

## DevOps Documentation

### Project Structure

```
├── .github/workflows/        # GitHub Actions workflows for CI/CD
├── k8s/                      # Kubernetes manifests
├── terraform/                # Terraform configurations for IaC
├── src/                      # React application source code
├── Dockerfile                # Docker configuration for the app
├── package.json              # Node.js dependencies and scripts
├── vite.config.ts            # Vite configuration
└── README.md                 # Project documentation
```

---

## Continuous Integration and Deployment (CI/CD)

CI/CD is powered by GitHub Actions. Workflows are located in `.github/workflows/`.

### CI Pipeline

**Trigger:** Pull requests or pushes to the `main` branch.

**Steps:**

1. **Linting** – Runs `npm run lint`
2. **Testing** – Executes `npm test`
3. **Build** – Runs `npm run build`
4. **Docker Build** – Builds Docker image if tests pass

### CD Pipeline

**Trigger:** Successful merge to the `main` branch.

**Steps:**

1. **Build Docker Image**
2. **Push to Docker Hub** (requires `DOCKER_HUB_TOKEN`)
3. **Deploy to Kubernetes** using `kubectl` (requires `KUBE_CONFIG`)

### Configuring Secrets

In your GitHub repo:

* Go to **Settings > Secrets and variables > Actions**
* Add:

  * `DOCKER_HUB_TOKEN`
  * `KUBE_CONFIG`

---

## Containerization with Docker

The app is containerized using Docker.

### Dockerfile Overview

* Uses Node.js base image
* Installs dependencies and builds React app
* Serves app using a lightweight server

### Local Docker Commands

```bash
# Build the image
docker build -t craftista-app:latest .

# Run the container
docker run -p 3000:3000 craftista-app:latest
```

### Push to Docker Hub

```bash
docker login
docker tag craftista-app:latest <your-username>/craftista-app:latest
docker push <your-username>/craftista-app:latest
```

---

## Kubernetes Orchestration

Kubernetes manifests are in the `k8s/` directory:

* **Deployment** – Defines pods and replicas
* **Service** – Exposes app in the cluster
* **Ingress** – Routes external traffic

### Deployment

```bash
kubectl apply -f k8s/
```

> Ensure your cluster is configured and has an ingress controller (e.g., NGINX).

---

## Infrastructure as Code with Terraform

Terraform config is in the `terraform/` directory.

### Provisioning Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

> Ensure AWS credentials (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) and AWS CLI are configured.

---

## Monitoring and Logging

* **Monitoring**: Use Prometheus + Grafana (check `k8s/monitoring/` if available)
* **Logging**: Use `kubectl logs` or integrate with ELK/CloudWatch

---

## Custom Domain Configuration

1. Update your domain’s DNS to point to the Kubernetes ingress or load balancer.
2. Modify `k8s/ingress.yaml` with your domain.
3. Apply the ingress:

```bash
kubectl apply -f k8s/ingress.yaml
```

Refer to your cloud provider’s DNS docs or the [Kubernetes Ingress Guide](https://kubernetes.io/docs/concepts/services-networking/ingress/).

---

## Deployment Instructions

### 1. Set Up CI/CD

* Configure GitHub secrets (`DOCKER_HUB_TOKEN`, `KUBE_CONFIG`)
* Validate workflows in `.github/workflows/`

### 2. Build and Push Docker Image

See [Docker section](#containerization-with-docker).

### 3. Deploy to Kubernetes

Apply the manifests in `k8s/`.

### 4. Provision Infrastructure

Use Terraform as described above.

### 5. Verify Deployment

```bash
kubectl get pods
```

Access the app via the ingress URL or custom domain.

---

## Troubleshooting

| Issue              | Suggestions                                                       |
| ------------------ | ----------------------------------------------------------------- |
| CI/CD Failures     | Check GitHub Actions logs, validate secrets, and workflow syntax. |
| Docker Issues      | Ensure Docker is running and the Dockerfile is correct.           |
| Kubernetes Errors  | Use `kubectl describe` or `kubectl logs` for debugging.           |
| Terraform Failures | Verify AWS credentials and Terraform config.                      |

---

## Additional Resources

* [Docker Documentation](https://docs.docker.com/)
* [Kubernetes Documentation](https://kubernetes.io/docs/)
* [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
* [GitHub Actions Docs](https://docs.github.com/en/actions)
* [Vite Documentation](https://vitejs.dev/)
* [React Documentation](https://reactjs.org/)
* [Tailwind CSS Documentation](https://tailwindcss.com/)


