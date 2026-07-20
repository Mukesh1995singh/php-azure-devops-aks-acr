# 🚀 PHP Application CI/CD Pipeline using Azure DevOps, Docker & AKS

## 📌 Project Overview

This project demonstrates a complete CI/CD pipeline for deploying a containerized PHP application on **Azure Kubernetes Service (AKS)** using **Azure DevOps**, **Docker**, and **Azure Container Registry (ACR)**.

The application is containerized using Docker, stored in Azure Repos, automatically built and pushed to ACR through a CI pipeline, and deployed to AKS using a separate CD pipeline.

---

# 🏗️ Architecture

```
Developer
    │
    ▼
Azure Repos
    │
    ▼
Feature Branch
    │
    ▼
Pull Request
    │
    ▼
CI Pipeline
    │
    ├── Checkout Source Code
    ├── Build Docker Image
    ├── Security Scan (Trivy)
    ├── Push Image to Azure Container Registry
    └── Publish Kubernetes Manifests
    │
    ▼
Azure Container Registry
    │
    ▼
CD Pipeline
    │
    ├── Download Artifacts
    ├── Connect to AKS
    ├── Deploy Application
    ├── Verify Deployment
    └── Expose Application
    │
    ▼
Azure Kubernetes Service
```

---

# 📁 Repository Structure

```
php-project
│
├── index.php
├── Dockerfile
│
├── kubernetes
│   ├── deployment.yml
│   └── service.yml
│
├── pipelines
│   ├── azure-pipelines-ci.yml
│   └── azure-pipelines-cd.yml
│
├── README.md
└── .gitignore
```

---

# 🛠 Technologies Used

- Microsoft Azure
- Azure Repos
- Azure DevOps Pipelines
- Docker
- Azure Container Registry (ACR)
- Azure Kubernetes Service (AKS)
- Kubernetes
- PHP
- Git
- Trivy (Container Security Scan)

---

# ⚙ Azure Resources

| Resource | Name |
|----------|------|
| Resource Group | app-grp |
| Azure Container Registry | myacr73010 |
| AKS Cluster | mukesh-aks |
| Container Image | phpproject |
| Region | Central India |

---

# 🚀 Continuous Integration (CI)

The CI pipeline performs the following tasks:

- Checkout source code
- Verify Docker installation
- Build Docker image
- Push Docker image to Azure Container Registry
- Perform container security scan using Trivy
- Publish Kubernetes manifest files

---

# 🚀 Continuous Deployment (CD)

The CD pipeline performs the following tasks:

- Download Kubernetes manifests
- Install kubectl
- Connect to AKS
- Deploy Kubernetes manifests
- Update container image
- Verify Pods
- Verify Services
- Verify Deployment

---

# 🐳 Docker

Build Docker Image

```bash
docker build -t phpproject .
```

Run Container

```bash
docker run -d -p 80:80 phpproject
```

---

# ☸ Kubernetes Deployment

Deploy Application

```bash
kubectl apply -f kubernetes/deployment.yml
```

Deploy Service

```bash
kubectl apply -f kubernetes/service.yml
```

Check Pods

```bash
kubectl get pods
```

Check Services

```bash
kubectl get svc
```

Check Deployment

```bash
kubectl get deployment
```

---

# 📦 Azure CLI Commands

Login

```bash
az login
```

Login to ACR

```bash
az acr login --name myacr73010
```

Get AKS Credentials

```bash
az aks get-credentials \
--resource-group app-grp \
--name mukesh-aks
```

---

# 🔒 Security

- Azure DevOps Service Connections
- Azure RBAC
- Azure Container Registry Authentication
- Trivy Container Image Scanning
- Kubernetes RBAC

---

# 📈 CI/CD Workflow

```
Developer
      │
      ▼
Git Push
      │
      ▼
Azure Repos
      │
      ▼
Pull Request
      │
      ▼
CI Pipeline
      │
      ▼
Docker Image
      │
      ▼
Azure Container Registry
      │
      ▼
CD Pipeline
      │
      ▼
Azure Kubernetes Service
      │
      ▼
Application Running
```

---

# 🎯 Learning Objectives

This project demonstrates:

- Azure Repos
- Git Branching Strategy
- Pull Requests
- YAML Pipelines
- Docker Containerization
- Azure Container Registry
- Azure Kubernetes Service
- Kubernetes Deployment
- CI/CD Pipeline Implementation
- Container Security Scanning
- Infrastructure Automation

---

# 👨‍💻 Author

**Mukesh Kumar**

Azure Administrator | Azure DevOps | Docker | Kubernetes | Linux | Azure CLI

---