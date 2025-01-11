# 2-Tier-achitecture-Aws-Terraform
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

### 📐 Architecture Diagram

Below is the architecture diagram of the two-tier infrastructure. It illustrates the routing between components and AWS services.

![AWS Architecture Diagram](INSERT_IMAGE_URL_HERE)

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

### 2️⃣ **Generate SSH Key Pair**
Generate a public-private key pair for your EC2 instances.

```bash
Copy code
cd modules/key/
ssh-keygen -t rsa -b 4096 -f client_key
Update the Terraform configuration file with the generated key name.
```

### 3️⃣ **Set Up Input Variables**
Define variables for the infrastructure in terraform.tfvars.

```hcl
Copy code
region                   = "us-east-1"
project_name             = "two-tier-architecture"
vpc_cidr                 = "10.0.0.0/16"
pub_sub_1a_cidr          = "10.0.1.0/24"
pub_sub_2b_cidr          = "10.0.2.0/24"
pri_sub_3a_cidr          = "10.0.3.0/24"
pri_sub_4b_cidr          = "10.0.4.0/24"
db_username              = "admin"
db_password              = "securepassword123"
certificate_domain_name  = "yourdomain.com"
additional_domain_name   = "www.yourdomain.com"
```

### 4️⃣ **Initialize and Plan the Terraform Deployment**
Navigate to the project directory and initialize Terraform.

```bash
Copy code
cd root
terraform init
```
View the execution plan to ensure everything is configured correctly.

```bash
Copy code
terraform plan
```

### 5️⃣ Deploy the Infrastructure
Finally, deploy the infrastructure using the apply command.

```bash
Copy code
terraform apply --auto-approve
```