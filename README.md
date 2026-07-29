# 🚀 PHP-AZURE-DEVOPS-AKS-ACR-DOCKER

## 📌 Project Overview

This project demonstrates a **production-ready end-to-end DevOps implementation** for deploying a PHP web application on **Azure Kubernetes Service (AKS)** using:

- Azure DevOps CI/CD
- Docker containerization
- Azure Container Registry (ACR)
- Kubernetes orchestration
- Azure Key Vault integration using Secrets Store CSI Driver
- Infrastructure as Code using Azure Bicep
- Azure Database for MySQL Flexible Server


The solution follows modern cloud-native practices:

✅ Infrastructure as Code  
✅ Containerized application deployment  
✅ Automated CI/CD pipelines  
✅ Secure secret management  
✅ Kubernetes best practices  
✅ Production monitoring readiness  


---

# 🏗️ Solution Architecture


```
                         Developer
                            |
                            |
                    Azure Repository
                            |
                            |
              Azure DevOps CI Pipeline
                            |
             +--------------+--------------+
             |                             |
        Docker Build                 Security Scan
             |
             |
       Push Docker Image
             |
             |
 Azure Container Registry (ACR)
             |
             |
             |
       Azure DevOps CD Pipeline
             |
             |
       Deploy to AKS Cluster
             |
   +---------+----------+
   |                    |
Kubernetes          Azure Key Vault
Resources                 |
   |                      |
   |              Secrets Store CSI Driver
   |
   |
PHP Application Pods
   |
   |
MySQL Flexible Server
```


---

# 🛠️ Technology Stack


| Category | Technology |
|----------|------------|
| Application | PHP 8.2 |
| Web Server | Apache |
| Database | Azure Database for MySQL Flexible Server |
| Containerization | Docker |
| Container Registry | Azure Container Registry |
| Container Platform | Kubernetes |
| Managed Kubernetes | Azure Kubernetes Service |
| CI/CD | Azure DevOps Pipelines |
| Infrastructure as Code | Azure Bicep |
| Secret Management | Azure Key Vault |
| Secret Integration | Secrets Store CSI Driver |
| Cloud Provider | Microsoft Azure |


---

# 📂 Repository Structure


```
PHP-AZURE-DEVOPS-AKS-ACR-DOCKER
│
├── app/
│   ├── config.php
│   ├── db.php
│   └── index.php
│
├── docs/
│   ├── architecture.md
│   └── deployment-guide.md
│
├── infra/
│   │
│   ├── bicep/
│   │   ├── acr.bicep
│   │   ├── aks.bicep
│   │   ├── keyvault.bicep
│   │   ├── main.bicep
│   │   └── mysql.bicep
│   │
│   └── terraform/
│
├── kubernetes/
│   ├── namespace.yml
│   ├── configmap.yml
│   ├── deployment.yml
│   ├── service.yml
│   └── secretproviderclass.yml
│
├── pipelines/
│   ├── azure-pipelines-ci.yml
│   └── azure-pipelines-cd.yml
│
├── Dockerfile
├── .dockerignore
├── .gitignore
├── LICENSE
└── README.md