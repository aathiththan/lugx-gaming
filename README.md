# Lugx Gaming Microservices Platform

This project is a cloud-native microservices solution designed for **Lugx Gaming**, an online gaming shop.  
It includes a static frontend, multiple backend microservices, and analytics with a focus on scalability, security, and automated deployment.

---

## Architecture Overview

### Microservices
- **Frontend** – Static website served via NGINX (Port 80)
- **Game Service** – Manages gaming catalog (CRUD) using MySQL (Port 3001)
- **Order Service** – Handles customer orders and order items using MySQL (Port 3002)
- **Analytics Service** – Captures analytics events stored in ClickHouse (Port 3003)

### Databases
- **MySQL** – Stores game and order data
- **ClickHouse** – Stores analytics data for fast analytical queries

### Cloud & Tools
- **Amazon EKS** – Kubernetes cluster for deployment
- **DockerHub** – Image registry
- **GitHub Actions** – CI/CD pipeline
- **Amazon QuickSight** – Analytics visualization (optional)
- **Grafana** – Metrics visualization

---

## Features
- Modular microservices-based architecture
- Automated deployment pipeline with GitHub Actions
- Secure credential management using Kubernetes Secrets
- Observability with Grafana dashboards
- Analytics data visualization using Amazon QuickSight

---

## Project Structure

```
├── analytics-service
├── game-service
├── order-service
├── frontend
├── k8s-manifests
│   ├── namespace.yaml
│   ├── mysql-deployment.yaml
│   ├── clickhouse.yaml
│   ├── game-service.yaml
│   ├── order-service.yaml
│   ├── analytics.yaml
│   └── frontend-deployment.yaml
└── tests
```



---

## Deployment Guide

### Prerequisites
- AWS EKS Cluster and kubectl configured
- DockerHub account
- GitHub repository configured with CI/CD

### Steps
1. Clone this repository:
   ```bash
   git clone https://github.com/<your-username>/lugx-gaming.git

2. Deploy Kubernetes manifests:
    kubectl apply -f k8s-manifests/namespace.yaml
    kubectl apply -f k8s-manifests/mysql-deployment.yaml
    kubectl apply -f k8s-manifests/clickhouse.yaml
    kubectl apply -f k8s-manifests/game-service.yaml
    kubectl apply -f k8s-manifests/order-service.yaml
    kubectl apply -f k8s-manifests/analytics.yaml
    kubectl apply -f k8s-manifests/frontend-deployment.yaml

3. Verify:
    kubectl get pods -n lugx
    kubectl get svc -n lugx
# Testing & API Endpoints

## Game Service
- **GET** `/games`
- **POST** `/games`
- **DELETE** `/games/:id`

## Order Service
- **GET** `/orders`
- **POST** `/orders`

## Analytics Service
- **GET** `/analytics`
- **POST** `/analytics`

> **Use Postman for API testing.**

---

# Visualization

- **Grafana:** For metrics monitoring.
- **QuickSight:** For analytics dashboard creation using exported event data from ClickHouse → S3.

---

# CI/CD Pipeline

- **GitHub Actions** workflows build images and push them to **DockerHub**.
- Deployments are automatically applied to the **EKS cluster**.
- Integration tests run automatically after deployments.

---

# License

This project is developed as part of academic coursework and is **not intended for commercial use**.

---


   
  


