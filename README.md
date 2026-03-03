# InfraDeploy Project – Production-Ready AWS Infrastructure (Terraform + GitHub Actions + Ansible)

## Overview

This project provisions and manages a fully automated, multi-environment AWS infrastructure using:

- **Terraform** (Infrastructure as Code)
- **GitHub Actions** (CI/CD pipeline)
- **Ansible** (Database bootstrap automation)
- **AWS best practices** (ALB, ASG, RDS Proxy, Secrets Manager, SSM)

The platform supports three isolated environments:

- dev
- staging
- prod

All environments are deployed through a guarded CI/CD pipeline with safety controls to prevent destructive operations.

---

## Architecture

Each environment provisions:

- VPC (public + private subnets)
- Internet Gateway + NAT Gateway
- Application Load Balancer (HTTP → HTTPS redirect)
- ACM certificate (DNS validated)
- Auto Scaling Group (EC2 instances)
- RDS PostgreSQL
- RDS Proxy
- AWS Secrets Manager
- Route53 DNS records
- IAM roles (SSM, RDS Proxy)
- No SSH access (SSM Session Manager only)

---

## Infrastructure Design Principles

- Infrastructure as Code only (no manual provisioning)
- Environment isolation
- Remote Terraform state (S3 + DynamoDB locking)
- Guardrails preventing accidental ASG scale-to-zero
- Secrets managed via GitHub Environments + AWS Secrets Manager
- CI/CD driven deployments (no local applies in production)

---

## CI/CD Pipeline

Workflow: `.github/workflows/deploy-infra-and-db.yml`

Pipeline stages:

1. Checkout & clean runner
2. Terraform Init
3. Terraform Validate
4. Terraform Plan
5. Guardrail check (prevent ASG scale-to-zero)
6. Terraform Apply
7. Wait for ASG instance healthy
8. DB Bootstrap (Ansible)

Concurrency control:


---

## Security Controls

- No SSH access to EC2
- SSM only
- Secrets not stored in repository
- GitHub Environment-level secrets
- Terraform remote locking
- Guardrail validation before apply

---

## Database Bootstrap

After infrastructure deployment:

- Pipeline waits for ASG instance
- Connects via SSM
- Retrieves DB credentials from Secrets Manager
- Executes Ansible playbook to initialize database

---

## Branching Strategy

Stable branches follow convention: dev-stable-VX.Y


Each stable version represents a fully functional multi-environment release.

---

## Current Stable Release

**Version: v2.6**

Status:
- dev 
- staging 
- prod 

---

## Purpose

This project demonstrates:

- Transition from DBA role to DevOps engineering
- Cloud-native infrastructure automation
- CI/CD-driven infrastructure management
- Production-ready AWS deployment patterns

---

## Author
Javier Guerrero


InfraDeploy Project  
AWS | Terraform | GitHub Actions | Ansible | PostgreSQL
