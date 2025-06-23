
# 2. Architecture Design

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        DEVELOPMENT FLOW                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Developer → GitHub Repository → GitHub Actions CI/CD          │
│      ↓              ↓                      ↓                    │
│  Local Dev    Version Control        Automated Testing         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│                      BUILD & PACKAGE FLOW                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Source Code → Docker Build → Container Registry → Kubernetes  │
│      ↓              ↓              ↓                ↓          │
│  React App    Multi-stage     Docker Hub       Pod Deploy      │
│               Dockerfile                                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│                    INFRASTRUCTURE LAYER                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Terraform → Kubernetes Cluster ← Ansible                      │
│      ↓              ↓                ↓                         │
│  IaC Provision   Orchestration   Config Mgmt                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────┐
│                     DEPLOYMENT & MONITORING                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ArgoCD GitOps ← Prometheus Monitoring ← Grafana Dashboards    │
│      ↓              ↓                      ↓                   │
│  Auto Deploy    Metrics Collection    Visualization            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

### Application Layer
```
┌─────────────────┐
│   React App     │
│                 │
│ ┌─────────────┐ │
│ │ Components  │ │
│ │ Pages       │ │
│ │ Hooks       │ │
│ │ Utils       │ │
│ └─────────────┘ │
│                 │
│ Built with Vite │
│ Styled with     │
│ Tailwind CSS    │
└─────────────────┘
```

### Container Layer
```
┌─────────────────────────────────────┐
│            Docker Container         │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────┐  ┌─────────────┐   │
│  │   Nginx     │  │ Static Files│   │
│  │   Server    │  │   (dist/)   │   │
│  │             │  │             │   │
│  │ Port: 80    │  │ HTML/CSS/JS │   │
│  └─────────────┘  └─────────────┘   │
│                                     │
│  Alpine Linux Base Image           │
└─────────────────────────────────────┘
```

### Kubernetes Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │  Namespace  │    │   Ingress   │    │   Service   │     │
│  │ craftista   │    │             │    │ ClusterIP   │     │
│  │             │    │ TLS Term.   │    │ Port: 80    │     │
│  └─────────────┘    └─────────────┘    └─────────────┘     │
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │ Deployment  │    │ ConfigMap   │    │   Secret    │     │
│  │ 3 Replicas  │    │ App Config  │    │ Credentials │     │
│  │ Rolling     │    │ Environment │    │ Base64 Enc. │     │
│  │ Updates     │    │ Variables   │    │             │     │
│  └─────────────┘    └─────────────┘    └─────────────┘     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Network Architecture

### External Access Flow
```
Internet → Load Balancer → Ingress Controller → Service → Pods
   ↓            ↓               ↓                ↓        ↓
HTTPS:443   TLS Termination  Routing Rules   ClusterIP  App:80
```

### Internal Communication
```
Pod ↔ Service ↔ ConfigMap/Secret
 ↓      ↓           ↓
App   Discovery  Configuration
```

## Data Flow Diagrams

### CI/CD Pipeline Flow
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Commit    │───▶│    Test     │───▶│    Build    │
│   to Git    │    │   & Lint    │    │   Docker    │
└─────────────┘    └─────────────┘    └─────────────┘
                                             │
                                             ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Deploy    │◀───│   Push to   │◀───│   Tag &     │
│ to K8s      │    │  Registry   │    │   Release   │
└─────────────┘    └─────────────┘    └─────────────┘
```

### GitOps Flow
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Git Commit  │───▶│   ArgoCD    │───▶│ Kubernetes  │
│ (Manifest)  │    │  Detects    │    │   Apply     │
└─────────────┘    │  Changes    │    │  Changes    │
                   └─────────────┘    └─────────────┘
                          │                   │
                          ▼                   ▼
                   ┌─────────────┐    ┌─────────────┐
                   │ Sync Status │    │ Health      │
                   │ Monitoring  │    │ Monitoring  │
                   └─────────────┘    └─────────────┘
```

## Security Architecture

### Secrets Management
```
┌─────────────────────────────────────────────────────────┐
│                  Secrets Flow                           │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  GitHub Secrets → CI/CD Pipeline → Kubernetes Secrets  │
│        ↓               ↓                    ↓           │
│   Base64 Encoded   Environment Vars    Pod Volumes     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Network Security
```
┌─────────────────────────────────────────────────────────┐
│                Network Security                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Internet → TLS → Ingress → ClusterIP → Pod            │
│     ↓        ↓       ↓         ↓         ↓             │
│  Firewall  HTTPS   Routing   Internal   Container      │
│                              Network    Security       │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Monitoring Architecture

### Metrics Collection
```
┌─────────────────────────────────────────────────────────┐
│                Monitoring Stack                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Application → Prometheus → Grafana → Alerts           │
│      ↓             ↓           ↓         ↓             │
│   Metrics      Collection   Visualization Notifications │
│                                                         │
│  Node Metrics → Node Exporter → Prometheus             │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Scalability Design

### Horizontal Scaling
- Kubernetes Horizontal Pod Autoscaler (HPA)
- Load balancing across multiple pod replicas
- Resource-based scaling triggers

### Vertical Scaling
- Resource requests and limits
- Memory and CPU optimization
- Container resource management

### Infrastructure Scaling
- Terraform-managed infrastructure
- Cloud provider auto-scaling groups
- Dynamic resource allocation

## High Availability Design

### Application Level
- Multiple pod replicas (minimum 3)
- Rolling updates with zero downtime
- Health checks and readiness probes

### Infrastructure Level
- Multi-node Kubernetes cluster
- Load balancer redundancy
- Cross-availability zone deployment

### Disaster Recovery
- Automated backups
- Infrastructure as Code for rapid recovery
- GitOps for configuration restoration
