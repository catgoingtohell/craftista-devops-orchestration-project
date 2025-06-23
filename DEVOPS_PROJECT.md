
# DevOps Semester Project - Craftista Application

## Project Overview
This project demonstrates the implementation of DevOps tools and techniques on the Craftista application, showcasing integration of multiple DevOps tools in a complete CI/CD pipeline.

## Team Members
- **Member 1**: Rayyan - Responsible for Docker, Kubernetes, ArgoCD, Responsible for Terraform, Ansible, and Infrastructure, Responsible for CI/CD, Monitoring, and Documentation

## Project Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   GitHub Repo   │────│  GitHub Actions │────│   Docker Hub    │
│                 │    │     CI/CD       │    │   Container     │
└─────────────────┘    └─────────────────┘    │   Registry      │
                                              └─────────────────┘
                                                       │
                                                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Terraform     │────│    Ansible      │────│   Kubernetes    │
│ Infrastructure  │    │  Configuration  │    │    Cluster      │
│   as Code       │    │  Management     │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     ArgoCD      │────│   Prometheus    │────│    Grafana      │
│   GitOps CD     │    │   Monitoring    │    │  Visualization  │
│                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Tools Implementation

### 1. GitHub Repository
- **Location**: https://github.com/craftista/craftista
- **Purpose**: Source code management and version control
- **Implementation**: All source code, configurations, and documentation stored in GitHub

### 2. Docker
- **File**: `Dockerfile`
- **Purpose**: Containerization of the application
- **Features**:
  - Multi-stage build for optimization
  - Alpine-based images for security
  - Nginx for serving static content

### 3. Kubernetes
- **Directory**: `k8s/`
- **Components**:
  - **Deployment**: Manages application pods with rolling updates
  - **Service**: ClusterIP service for internal communication
  - **Ingress**: External access with TLS termination
  - **ConfigMap**: Environment-specific configuration
  - **Secrets**: Sensitive data management
  - **Namespace**: Resource isolation

### 4. Terraform
- **Directory**: `terraform/`
- **Purpose**: Infrastructure as Code
- **Features**:
  - Kubernetes resource provisioning
  - Variable-driven configuration
  - State management
  - Output values for integration

### 5. Ansible
- **Directory**: `ansible/`
- **Purpose**: Configuration management and deployment automation
- **Features**:
  - Kubernetes deployment playbooks
  - Inventory management
  - Secret and ConfigMap management
  - Idempotent operations

### 6. CI/CD (GitHub Actions)
- **File**: `.github/workflows/ci-cd.yml`
- **Pipeline Stages**:
  - **Test**: Unit tests, linting, and build verification
  - **Build**: Docker image creation and registry push
  - **Deploy Staging**: Automated deployment to staging environment
  - **Deploy Production**: Manual approval with production deployment

### 7. ArgoCD
- **Directory**: `argocd/`
- **Purpose**: GitOps continuous deployment
- **Features**:
  - Automated synchronization with Git repository
  - Self-healing capabilities
  - Application project management
  - Rollback functionality

### 8. Prometheus & Grafana
- **Directory**: `monitoring/`
- **Purpose**: Application and infrastructure monitoring
- **Features**:
  - **Prometheus**: Metrics collection and alerting
  - **Grafana**: Visualization dashboards
  - Custom alerts for application health
  - Performance monitoring

## Deployment Process

### 1. Development to Staging
```bash
# Push to develop branch triggers staging deployment
git push origin develop

# GitHub Actions automatically:
# 1. Runs tests
# 2. Builds Docker image
# 3. Deploys to staging via Ansible
```

### 2. Staging to Production
```bash
# Push to main branch triggers production deployment
git push origin main

# GitHub Actions automatically:
# 1. Runs tests
# 2. Builds Docker image
# 3. Deploys to production via Terraform
```

### 3. GitOps with ArgoCD
```bash
# ArgoCD continuously monitors Git repository
# Automatically syncs changes to Kubernetes cluster
# Self-heals any configuration drift
```

## Environment Setup

### Prerequisites
- Kubernetes cluster (minikube, kind, or cloud provider)
- Docker installed
- kubectl configured
- Terraform installed
- Ansible installed
- ArgoCD installed in cluster

### Installation Steps

1. **Clone Repository**
```bash
git clone https://github.com/craftista/craftista
cd craftista
```

2. **Build Docker Image**
```bash
docker build -t craftista:latest .
```

3. **Deploy with Kubernetes**
```bash
kubectl apply -f k8s/
```

4. **Deploy with Terraform**
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

5. **Deploy with Ansible**
```bash
cd ansible
ansible-playbook deploy-app.yml
```

6. **Setup ArgoCD**
```bash
kubectl apply -f argocd/
```

7. **Setup Monitoring**
```bash
kubectl apply -f monitoring/
```

## Monitoring and Observability

### Metrics Collected
- Request rate and response times
- Error rates (4xx, 5xx)
- Pod status and resource usage
- Infrastructure metrics

### Alerts Configured
- High error rate (>10%)
- High response time (>500ms)
- Pod crash looping
- Resource exhaustion

### Grafana Dashboards
- Application performance overview
- Infrastructure health
- Custom business metrics

## Security Implementation

### Container Security
- Non-root user in containers
- Minimal base images (Alpine)
- Regular image scanning

### Kubernetes Security
- Namespace isolation
- Resource limits and requests
- Secret management
- Network policies (can be added)

### CI/CD Security
- Secret management in GitHub
- Image vulnerability scanning
- Signed commits (can be implemented)

## Testing Strategy

### Unit Tests
- Jest/Vitest for React components
- Coverage reporting

### Integration Tests
- API endpoint testing
- Database integration testing

### End-to-End Tests
- Cypress or Playwright (can be added)
- User journey testing

## Performance Optimization

### Application Level
- Code splitting and lazy loading
- Asset optimization
- Caching strategies

### Infrastructure Level
- Resource limits and requests
- Horizontal Pod Autoscaling (can be added)
- CDN integration (can be added)

## Disaster Recovery

### Backup Strategy
- Database backups
- Configuration backups
- Container image registry

### Recovery Procedures
- Automated rollback with ArgoCD
- Database restoration
- Infrastructure recreation with Terraform

## Future Enhancements

1. **Service Mesh**: Implement Istio for advanced traffic management
2. **Security Scanning**: Add Falco for runtime security monitoring
3. **Cost Optimization**: Implement resource right-sizing
4. **Multi-cluster**: Extend to multi-cluster deployment
5. **Chaos Engineering**: Add chaos testing with Chaos Monkey

## Conclusion

This project successfully demonstrates the integration of multiple DevOps tools in a production-ready environment. The implementation showcases:

- Complete automation from code commit to production deployment
- Infrastructure as Code practices
- GitOps methodology
- Comprehensive monitoring and alerting
- Security best practices
- Scalable and maintainable architecture

The project serves as a practical example of modern DevOps practices and can be used as a reference for similar implementations.
```

Finally, let's create a setup script to help with initial configuration:

<lov-write file_path="scripts/setup.sh">
#!/bin/bash

set -e

echo "🚀 Setting up Craftista DevOps Environment"

# Check required tools
check_tool() {
    if ! command -v $1 &> /dev/null; then
        echo "❌ $1 is not installed. Please install it first."
        exit 1
    else
        echo "✅ $1 is available"
    fi
}

echo "📋 Checking required tools..."
check_tool "docker"
check_tool "kubectl"
check_tool "terraform"
check_tool "ansible"

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p logs
mkdir -p configs
mkdir -p backups

# Setup Kubernetes namespace
echo "🔧 Setting up Kubernetes namespace..."
kubectl create namespace craftista --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# Install ArgoCD
echo "📦 Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
echo "⏳ Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Install Prometheus and Grafana (using helm if available)
if command -v helm &> /dev/null; then
    echo "📊 Installing Prometheus and Grafana..."
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
    
    helm install prometheus prometheus-community/kube-prometheus-stack \
        --namespace monitoring \
        --create-namespace \
        --wait
else
    echo "⚠️  Helm not found. Please install Prometheus and Grafana manually."
fi

# Build Docker image
echo "🐳 Building Docker image..."
docker build -t craftista:latest .

# Apply Kubernetes manifests
echo "☸️  Applying Kubernetes manifests..."
kubectl apply -f k8s/

# Setup ArgoCD application
echo "🔄 Setting up ArgoCD application..."
kubectl apply -f argocd/

# Initialize Terraform
echo "🏗️  Initializing Terraform..."
cd terraform
terraform init
cd ..

# Setup Ansible
echo "🔧 Setting up Ansible..."
ansible-galaxy collection install kubernetes.core

echo "✨ Setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Configure your secrets in GitHub repository settings"
echo "2. Update domain names in configuration files"
echo "3. Run 'kubectl get pods -A' to check all pods are running"
echo "4. Access ArgoCD UI: kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "5. Access Grafana: kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80"
echo ""
echo "🎉 Happy DevOps-ing!"
