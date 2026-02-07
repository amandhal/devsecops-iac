# Complete DevSecOps CI/CD Pipeline | Multi-AZ Amazon EKS + Jenkins + Trivy + SonarQube + ECR + GitHub

This repository contains a complete **DevSecOps setup** covering
infrastructure provisioning, configuration management, and application
CI/CD deployment on AWS and Kubernetes.

It is divided into two main parts:

-   **Infrastructure as Code (IaC)** -- Provisioning and configuring
    cloud and compute resources
-   **CI/CD Pipeline** -- Building, scanning, containerizing, and
    deploying an application

------------------------------------------------------------------------

## Infrastructure as Code

The `infrastructure-as-code` directory automates **cloud infrastructure
provisioning and system configuration** using **Terraform** and
**Ansible**.

### Terraform -- AWS Infrastructure Provisioning

Terraform is used to provision core AWS infrastructure:

-   **Amazon EKS Cluster** created using AWS EKS Terraform module
-   **EKS access control** using `aws_eks_access_entry` to grant cluster
    access to an IAM role used by the Jenkins Agent EC2 instance

This ensures secure, role-based access from the CI system to the
Kubernetes cluster.

### Ansible -- Server Configuration & IAM Integration

Ansible is used for post-provisioning configuration of EC2 instances and
IAM setup.

#### EC2 Instances Created & Configured

-   **Jenkins Controller**
-   **Jenkins Agent**
-   **SonarQube Server**

#### IAM Role Integration

-   An IAM role is created and attached to the **Jenkins Agent EC2
    instance** using an **instance profile**
-   This allows Jenkins pipelines to securely interact with AWS services
    and the EKS cluster

#### Ansible Roles Used

-   `create-ec2-instances` -- Provisions EC2 instances and IAM
    components
-   `configure-ec2-jenkins-controller` -- Installs and configures
    Jenkins Controller
-   `configure-ec2-jenkins-agent` -- Installs Docker, Trivy, AWS CLI and kubectl etc. 
    environment
-   `configure-ec2-sonarqube` -- Installs and configures SonarQube as a
    system service

------------------------------------------------------------------------

## CI/CD Pipeline

The `ci-cd-pipeline` directory contains the application and Jenkinsfile used by Jenkins.

### Tools Used in the Pipeline

-   **Jenkins** -- Pipeline orchestration
-   **Maven** -- Build and dependency management
-   **SonarQube** -- Code quality and security scanning
-   **Docker** -- Container image build and push to an Amazon ECR private repository
-   **Kubernetes (EKS)** -- Application deployment

### Pipeline Flow

1.  Source code checkout
2.  Trivy FS Scan
3.  Build(Maven) and SAST(Sonar)
4.  ECR Login
5.  Build Image
6.  Trivy Image Scan
7.  Edit Kubernetes Manifests
8.  Deploy application to EKS using Kubernetes manifests

------------------------------------------------------------------------

## ☸️ Kubernetes Configuration

Kubernetes manifests are included for deploying the application to the
EKS cluster:

-   `deploy-svc.yml` -- For creating deployment and service.
-   RBAC manifests (`cr.yaml`, `crb.yaml`) to allow required permissions
    inside the cluster

------------------------------------------------------------------------

## ✅ Key Outcomes

-   Fully automated AWS infrastructure provisioning
-   Configuration management with reusable Ansible roles
-   Secure IAM-based access from Jenkins to EKS
-   Integrated DevSecOps pipeline with code quality scanning
-   Containerized application deployed to Kubernetes on AWS

This repository demonstrates an end-to-end **DevSecOps implementation**
combining Infrastructure as Code, Configuration Management, CI/CD,
Security Scanning, and Kubernetes deployment.