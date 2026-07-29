# 🚀 Deployment Guide - PHP Azure DevOps AKS Project

## 📌 Overview

This document explains the deployment process for the PHP application using:

- Azure Bicep Infrastructure as Code
- Azure DevOps CI/CD Pipelines
- Docker
- Azure Container Registry (ACR)
- Azure Kubernetes Service (AKS)
- Azure Key Vault Secrets Store CSI Driver


---

# ✅ Prerequisites


Install required tools:


| Tool | Purpose |
|------|---------|
| Azure CLI | Azure resource management |
| kubectl | Kubernetes management |
| Docker | Container build |
| Azure DevOps Account | CI/CD automation |


Verify installation:


```bash
az version

kubectl version --client

docker --version
```


---

# ☁️ Phase 1: Azure Infrastructure Deployment


Infrastructure is created using Bicep templates.


Location:


```
infra/bicep/
```


Components:


```
main.bicep

    |
    |
    +-- aks.bicep
    |
    +-- acr.bicep
    |
    +-- keyvault.bicep
    |
    +-- mysql.bicep
```


---

## Login to Azure


```bash
az login
```


Select subscription:


```bash
az account set \
--subscription <subscription-id>
```


---

## Deploy Infrastructure


Create resource group:


```bash
az group create \
--name php-app-rg \
--location centralindia
```


Deploy Bicep:


```bash
az deployment group create \
--resource-group php-app-rg \
--template-file infra/bicep/main.bicep
```


Verify resources:


```bash
az resource list \
--resource-group php-app-rg \
-o table
```


---

# 🐳 Phase 2: Container Image Build


## Build Docker Image


```bash
docker build \
-t php-app .
```


Test locally:


```bash
docker run \
-p 8080:80 \
php-app
```


Access:


```
http://localhost:8080
```


---

# 📦 Phase 3: Push Image to Azure Container Registry


Login to ACR:


```bash
az acr login \
--name <acr-name>
```


Tag image:


```bash
docker tag php-app \
<acr-name>.azurecr.io/php-app:v1
```


Push image:


```bash
docker push \
<acr-name>.azurecr.io/php-app:v1
```


Verify image:


```bash
az acr repository list \
--name <acr-name>
```


---

# ☸️ Phase 4: Connect to AKS


Get AKS credentials:


```bash
az aks get-credentials \
--resource-group php-app-rg \
--name <aks-name>
```


Verify connection:


```bash
kubectl get nodes
```


Expected:


```
NAME          STATUS
aks-node      Ready
```


---

# 🔐 Phase 5: Configure Azure Key Vault Integration


AKS uses Managed Identity to access Key Vault.


Required role:


```
Key Vault Secrets User
```


Enable CSI Driver:


```bash
az aks enable-addons \
--addons azure-keyvault-secrets-provider \
--name <aks-name> \
--resource-group php-app-rg
```


Verify CSI Driver:


```bash
kubectl get pods \
-n kube-system | grep secrets-store
```


---

# ☸️ Phase 6: Deploy Kubernetes Resources


Location:


```
kubernetes/
```


Apply namespace:


```bash
kubectl apply \
-f kubernetes/namespace.yml
```


Deploy ConfigMap:


```bash
kubectl apply \
-f kubernetes/configmap.yml
```


Deploy SecretProviderClass:


```bash
kubectl apply \
-f kubernetes/secretproviderclass.yml
```


Deploy application:


```bash
kubectl apply \
-f kubernetes/deployment.yml
```


Deploy service:


```bash
kubectl apply \
-f kubernetes/service.yml
```


---

# 🔍 Phase 7: Validate Deployment


Check namespace:


```bash
kubectl get namespace
```


Check pods:


```bash
kubectl get pods \
-n php-app
```


Expected:


```
NAME                       STATUS

php-app-xxxxxxxxxx         Running
```


Check deployment:


```bash
kubectl get deployment \
-n php-app
```


Check service:


```bash
kubectl get service \
-n php-app
```


Get external IP:


```bash
kubectl get svc \
-n php-app
```


---

# 🔄 Phase 8: Azure DevOps CI/CD Deployment


## CI Pipeline


File:


```
pipelines/azure-pipelines-ci.yml
```


Pipeline performs:


```
Source Code

     |

Docker Build

     |

Image Scan

     |

Push Image to ACR
```


---

## CD Pipeline


File:


```
pipelines/azure-pipelines-cd.yml
```


Pipeline performs:


```
Download Artifact

       |

Connect AKS

       |

Deploy Kubernetes YAML

       |

Rolling Update
```


---

# 🔄 Application Update


Build new image:


```
php-app:v2
```


Update deployment:


```bash
kubectl set image deployment/php-app \
php-app=<acr-name>.azurecr.io/php-app:v2 \
-n php-app
```


Monitor rollout:


```bash
kubectl rollout status \
deployment/php-app \
-n php-app
```


---

# ↩️ Rollback Deployment


Check history:


```bash
kubectl rollout history \
deployment/php-app \
-n php-app
```


Rollback:


```bash
kubectl rollout undo \
deployment/php-app \
-n php-app
```


---

# 🧹 Troubleshooting


## Check Pod Logs


```bash
kubectl logs \
<pod-name> \
-n php-app
```


## Describe Pod


```bash
kubectl describe pod \
<pod-name> \
-n php-app
```


## Check Events


```bash
kubectl get events \
-n php-app
```


---

# ✅ Deployment Checklist


| Task | Status |
|-|-|
| Azure resources created | ✅ |
| ACR image pushed | ✅ |
| AKS connected | ✅ |
| CSI Driver enabled | ✅ |
| Key Vault access configured | ✅ |
| Kubernetes manifests deployed | ✅ |
| Application accessible | ✅ |


---

# 👨‍💻 Author


**Mukesh Kumar**

Azure Cloud Engineer | DevOps Engineer