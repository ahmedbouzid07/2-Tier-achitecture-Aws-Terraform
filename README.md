# AWS Two-Tier Architecture Deployment with Terraform

This project demonstrates how to deploy a two-tier architecture on **Amazon Web Services (AWS)** using **Terraform**. The architecture ensures scalability, security, and high availability.

---

## 📜 Project Overview

This Terraform project provisions the following resources:
- **Custom VPC** with public and private subnets spread across multiple Availability Zones.
- **NAT Gateways** for secure outbound internet access from private subnets.
- **Application Load Balancer (ALB)** to distribute incoming traffic across multiple EC2 instances.
- **Auto Scaling Group (ASG)** for web servers to handle dynamic traffic.
- **Amazon RDS** for secure and scalable database hosting.
- **Amazon CloudFront** for global content delivery with low latency.
- **Amazon Route 53** for DNS management.

---

## 🔐 Security Configuration
### Security Groups:
* Web servers: Allow HTTP/HTTPS traffic from the ALB.
* Database: Restrict access to only web servers in private subnets.
* ALB: Allow incoming HTTP/HTTPS traffic from the internet.

--- 

## 🚀 Steps to Deploy the Architecture

### 1️⃣ **Set Up Backend for Terraform State**
Create an S3 bucket and DynamoDB table for managing the Terraform state.

```bash
# Replace BUCKET_NAME and DYNAMODB_TABLE_NAME with your values
terraform {
  backend "s3" {
    bucket         = "BUCKET_NAME"
    key            = "backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "DYNAMODB_TABLE_NAME"
  }
}
```

### 2️⃣ Generate SSH Key Pair
Generate an SSH key pair to use for EC2 instances.

```bash
cd modules/key/
ssh-keygen -t rsa -b 2048 -f client_key
```

### 3️⃣ Set Up Variables
Create a terraform.tfvars file and provide values for the required variables.

```bash
region                 = "us-east-1"
project_name           = "two-tier-architecture"
vpc_cidr               = "10.0.0.0/16"
pub_sub_1a_cidr        = "10.0.1.0/24"
pub_sub_2b_cidr        = "10.0.2.0/24"
pri_sub_3a_cidr        = "10.0.3.0/24"
pri_sub_4b_cidr        = "10.0.4.0/24"
pri_sub_5a_cidr        = "10.0.5.0/24"
pri_sub_6b_cidr        = "10.0.6.0/24"
db_username            = "admin"
db_password            = "password123"
certificate_domain_name = "your-domain.com"
additional_domain_name  = "*.your-domain.com"
```

### 4️⃣ Initialize Terraform
Navigate to the root directory and initialize Terraform.

```bash
cd root
terraform init
```

5️⃣ Plan the Deployment
Review the planned infrastructure changes.

```bash
terraform plan
```

### 6️⃣ Deploy the Architecture
Apply the configuration to deploy the infrastructure.

```bash
terraform apply --auto-approve
```
---

## 📈 Scalability and Redundancy
* Auto Scaling Group (ASG) ensures horizontal scaling for the web tier.
* Multi-AZ RDS deployment ensures high availability and failover support for the database.
* CloudFront and Route 53 provide global content delivery and DNS failover.

## 🔄 Clean Up
To destroy the infrastructure and release resources:

```bash
terraform destroy --auto-approve
```