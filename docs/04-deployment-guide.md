
# 4. Deployment Guide

## Prerequisites

### Required Software
```bash
# Container and Orchestration
- Docker (v20.0+)
- kubectl (v1.24+)
- Kubernetes cluster (minikube/kind/cloud)

# Infrastructure and Configuration
- Terraform (v1.0+)
- Ansible (v2.12+)

# Version Control
- Git (v2.30+)
- GitHub CLI (optional)
```

### System Requirements
```
Minimum Requirements:
- CPU: 4 cores
- RAM: 8GB
- Storage: 50GB
- Network: Stable internet connection

Recommended Requirements:
- CPU: 8 cores
- RAM: 16GB
- Storage: 100GB
- Network: High-speed broadband
```

## Environment Setup

### 1. Local Development Setup
```bash
# Clone the repository
git clone https://github.com/craftista/craftista.git
cd craftista

# Install Node.js dependencies
npm install

# Start development server
npm run dev
```

### 2. Docker Environment Setup
```bash
# Build the Docker image
docker build -t craftista:latest .

# Run locally for testing
docker run -p 8080:80 craftista:latest

# Test the application
curl http://localhost:8080
```

### 3. Kubernetes Cluster Setup

#### Option A: Minikube (Local)
```bash
# Start minikube
minikube start --driver=docker --memory=4096 --cpus=4

# Enable necessary addons
minikube addons enable ingress
minikube addons enable metrics-server

# Verify cluster
kubectl cluster-info
```

#### Option B: Kind (Local)
```bash
# Create cluster
kind create cluster --name craftista-cluster

# Load Docker image
kind load docker-image craftista:latest --name craftista-cluster
```

#### Option C: Cloud Provider
```bash
# AWS EKS
aws eks create-cluster --name craftista-cluster --version 1.24

# Google GKE
gcloud container clusters create craftista-cluster --num-nodes=3

# Azure AKS
az aks create --resource-group craftista-rg --name craftista-cluster
```

## Deployment Methods

### Method 1: Automated Setup Script

```bash
# Make script executable
chmod +x scripts/setup.sh

# Run automated setup
./scripts/setup.sh

# This script will:
# 1. Check prerequisites
# 2. Create Kubernetes namespaces
# 3. Install ArgoCD
# 4. Install monitoring stack
# 5. Build and deploy application
```

### Method 2: Manual Kubernetes Deployment

#### Step 1: Create Namespace
```bash
kubectl apply -f k8s/namespace.yaml
```

#### Step 2: Deploy ConfigMap and Secrets
```bash
# Apply ConfigMap
kubectl apply -f k8s/configmap.yaml

# Apply Secrets (update values first)
kubectl apply -f k8s/secret.yaml
```

#### Step 3: Deploy Application
```bash
# Deploy the application
kubectl apply -f k8s/deployment.yaml

# Create service
kubectl apply -f k8s/service.yaml

# Setup ingress
kubectl apply -f k8s/ingress.yaml
```

#### Step 4: Verify Deployment
```bash
# Check pod status
kubectl get pods -n craftista

# Check service
kubectl get svc -n craftista

# Check ingress
kubectl get ingress -n craftista
```

### Method 3: Terraform Deployment

#### Step 1: Initialize Terraform
```bash
cd terraform
terraform init
```

#### Step 2: Configure Variables
```bash
# Create terraform.tfvars
cat > terraform.tfvars << EOF
api_url = "https://api.craftista.com"
app_env = "production"
domain_name = "craftista.yourdomain.com"
replica_count = 3
image_name = "craftista"
image_tag = "latest"
db_password = "your-secure-password"
api_key = "your-api-key"
jwt_secret = "your-jwt-secret"
EOF
```

#### Step 3: Plan and Apply
```bash
# Review planned changes
terraform plan

# Apply infrastructure
terraform apply
```

#### Step 4: Verify Resources
```bash
# Check Terraform outputs
terraform output

# Verify Kubernetes resources
kubectl get all -n craftista
```

### Method 4: Ansible Deployment

#### Step 1: Configure Inventory
```bash
# Update ansible/inventory.yml with your cluster details
cd ansible
cp inventory.yml.example inventory.yml
# Edit inventory.yml with your cluster information
```

#### Step 2: Install Dependencies
```bash
# Install Ansible collections
ansible-galaxy collection install kubernetes.core
```

#### Step 3: Run Playbook
```bash
# Deploy to staging
ansible-playbook deploy-app.yml -e env=staging

# Deploy to production
ansible-playbook deploy-app.yml -e env=production
```

### Method 5: ArgoCD GitOps Deployment

#### Step 1: Install ArgoCD
```bash
# Create ArgoCD namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd
```

#### Step 2: Access ArgoCD UI
```bash
# Port forward to access UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

#### Step 3: Deploy Application
```bash
# Apply ArgoCD project
kubectl apply -f argocd/project.yaml

# Apply ArgoCD application
kubectl apply -f argocd/application.yaml
```

## CI/CD Pipeline Setup

### GitHub Repository Setup

#### Step 1: Create Repository Secrets
```
Navigate to GitHub Repository → Settings → Secrets and Variables → Actions

Add the following secrets:
- KUBE_CONFIG_STAGING: Base64 encoded kubeconfig for staging
- KUBE_CONFIG_PROD: Base64 encoded kubeconfig for production
- DOCKER_USERNAME: Docker Hub username
- DOCKER_PASSWORD: Docker Hub password/token
- DB_PASSWORD: Database password
- API_KEY: External API key
- JWT_SECRET: JWT signing secret
```

#### Step 2: Configure Workflow
```yaml
# .github/workflows/ci-cd.yml is already configured
# Customize triggers and environments as needed
```

#### Step 3: Test Pipeline
```bash
# Push to develop branch
git checkout develop
git push origin develop
# This triggers staging deployment

# Push to main branch
git checkout main
git push origin main
# This triggers production deployment
```

## Monitoring Setup

### Prometheus Installation
```bash
# Using Helm (recommended)
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --wait
```

### Grafana Access
```bash
# Port forward to Grafana
kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80

# Default credentials:
# Username: admin
# Password: prom-operator
```

### Custom Dashboard Import
```bash
# Import the custom dashboard
# Use the JSON file from monitoring/grafana-dashboard.json
# Import through Grafana UI: + → Import → Upload JSON file
```

## Verification and Testing

### Application Health Checks
```bash
# Check pod health
kubectl get pods -n craftista

# Check application logs
kubectl logs -f deployment/craftista-app -n craftista

# Test application endpoints
curl http://your-domain.com
```

### Service Connectivity
```bash
# Test service resolution
kubectl exec -it pod-name -n craftista -- nslookup craftista-service

# Port forward for local testing
kubectl port-forward svc/craftista-service -n craftista 8080:80
```

### Ingress Testing
```bash
# Check ingress status
kubectl describe ingress craftista-ingress -n craftista

# Test TLS certificate
curl -I https://craftista.yourdomain.com
```

## Troubleshooting Common Issues

### Pod Issues
```bash
# Pod not starting
kubectl describe pod pod-name -n craftista

# Check resource constraints
kubectl top pods -n craftista

# Check events
kubectl get events -n craftista --sort-by='.lastTimestamp'
```

### Service Issues
```bash
# Service not accessible
kubectl get endpoints craftista-service -n craftista

# Check service logs
kubectl logs -l app=craftista -n craftista
```

### Ingress Issues
```bash
# Ingress controller logs
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx

# Check ingress configuration
kubectl describe ingress craftista-ingress -n craftista
```

## Environment-Specific Configurations

### Staging Environment
```yaml
Configuration Differences:
- Replica count: 1
- Resource limits: Lower
- TLS: Self-signed certificates
- Monitoring: Basic setup
- Persistence: Temporary storage
```

### Production Environment
```yaml
Configuration Differences:
- Replica count: 3+
- Resource limits: Production-grade
- TLS: Let's Encrypt certificates
- Monitoring: Full observability stack
- Persistence: Persistent volumes
- Backup: Automated backups
```

## Rollback Procedures

### Kubernetes Rollback
```bash
# Check rollout history
kubectl rollout history deployment/craftista-app -n craftista

# Rollback to previous version
kubectl rollout undo deployment/craftista-app -n craftista

# Rollback to specific revision
kubectl rollout undo deployment/craftista-app --to-revision=2 -n craftista
```

### ArgoCD Rollback
```bash
# Rollback through ArgoCD UI
# Or using CLI
argocd app rollback craftista-app

# Check sync status
argocd app get craftista-app
```

### Terraform Rollback
```bash
# Revert to previous state
terraform apply -var="image_tag=previous-version"

# Or restore from backup
terraform state pull > backup.tfstate
```
