# 🏗️ PHP Azure DevOps AKS Architecture

## 📌 Overview

This document describes the architecture of the PHP application deployment platform using:

- Azure DevOps CI/CD
- Docker
- Azure Container Registry (ACR)
- Azure Kubernetes Service (AKS)
- Azure Key Vault
- Secrets Store CSI Driver
- Azure Database for MySQL Flexible Server
- Azure Bicep Infrastructure as Code


---

# 🏛️ High-Level Architecture


```
                         Developer
                            |
                            |
                     Azure Repos
                            |
                            |
                  Azure DevOps CI Pipeline
                            |
             +--------------+--------------+
             |                             |
        Docker Build                 Image Scan
             |
             |
      Azure Container Registry
             |
             |
                  CD Pipeline
             |
             |
        Azure Kubernetes Service
             |
    +--------+---------+
    |                  |
 PHP Application    CSI Driver
    Pods               |
    |                  |
    |              Azure Key Vault
    |
    |
Azure Database for MySQL
```


---

# 🔄 CI/CD Architecture


## Continuous Integration (CI)


CI pipeline performs:


1. Pull source code from Azure Repository
2. Build Docker image
3. Scan container image
4. Tag image using build number
5. Push image to Azure Container Registry


Flow:


```
Developer Commit

      |

Azure DevOps CI

      |

Docker Build

      |

Security Scan

      |

Azure Container Registry
```


---

## Continuous Deployment (CD)


CD pipeline performs:


1. Authenticate with AKS cluster
2. Deploy Kubernetes manifests
3. Create application resources
4. Update application image
5. Perform rolling deployment


Flow:


```
Azure Container Registry

          |

Azure DevOps CD

          |

AKS Cluster

          |

Kubernetes Deployment

          |

PHP Application Pods
```


---

# ☸️ Kubernetes Architecture


## Namespace


Provides application isolation.


```
php-app namespace
```


Resources deployed inside namespace:


- Deployment
- Service
- ConfigMap
- SecretProviderClass


---

## Deployment


Responsible for:


- Pod lifecycle management
- Replica management
- Rolling updates
- Health checks


Example:


```
Deployment

    |

ReplicaSet

    |

PHP Pods
```


---

## Service


Exposes application externally.


Traffic flow:


```
User

 |

Azure Load Balancer

 |

Kubernetes Service

 |

PHP Pods
```


Service Type:


```
LoadBalancer
```


---

# 🔐 Secret Management Architecture


Application secrets are not stored inside Git or Kubernetes YAML files.


Secrets are managed using Azure Key Vault.


## Secret Flow


```
Azure Key Vault

       |

       |

Secrets Store CSI Driver

       |

       |

SecretProviderClass

       |

       |

Kubernetes Pod

       |

       |

PHP Application
```


Managed secrets:


- Database hostname
- Database username
- Database password
- Application credentials


Benefits:


- Centralized secret management
- Azure RBAC control
- No hardcoded credentials
- Secret rotation support


---

# 🗄️ Database Architecture


Database platform:


```
Azure Database for MySQL Flexible Server
```


Application connection:


```
PHP Application

       |

       |

PDO Connection

       |

       |

MySQL Flexible Server
```


Database credentials are injected securely through Azure Key Vault.


---

# ☁️ Infrastructure Architecture


Infrastructure is deployed using Azure Bicep.


Bicep modules:


```
infra/bicep/

│
├── main.bicep
│
├── aks.bicep
│
├── acr.bicep
│
├── keyvault.bicep
│
└── mysql.bicep
```


Resources created:


| Resource | Purpose |
|-|-|
| AKS | Kubernetes workload hosting |
| ACR | Docker image repository |
| Key Vault | Secret storage |
| MySQL Flexible Server | Application database |


---

# 🔒 Security Architecture


## Identity

- Managed Identity
- Azure RBAC
- Least privilege access


## Container Security

- Private ACR registry
- Image scanning
- Controlled image deployment


## Kubernetes Security

- Namespace isolation
- Resource limits
- Readiness probes
- Liveness probes
- Secure secret injection


---

# 📊 Monitoring Architecture


Recommended monitoring:


```
AKS Cluster

     |

Azure Monitor

     |

Log Analytics Workspace

     |

Container Insights
```


Monitored components:


- Pod health
- Application logs
- CPU utilization
- Memory usage
- Deployment status


---

# 🔄 Application Lifecycle


```
Code Commit

     |

CI Build

     |

Docker Image

     |

ACR Storage

     |

CD Deployment

     |

AKS Running Pods

     |

Application Available
```


---

# 🎯 Architecture Benefits


✅ Fully automated deployment  
✅ Cloud-native Kubernetes architecture  
✅ Secure secret management  
✅ Infrastructure as Code  
✅ Scalable container platform  
✅ Production-ready DevOps workflow  