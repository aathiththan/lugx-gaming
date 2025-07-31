# fix-structure-and-setup.ps1
# Full cleanup, Dockerfiles, Kubernetes manifests, frontend setup

$root = "C:\lugx-gaming"
$services = @("game-service", "order-service", "analytics-service")

# Ensure service folders exist
foreach ($service in $services) {
    $path = Join-Path $root $service
    if (-Not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
        Write-Host "Created missing folder: $path"
    }
}

# Move misplaced Game Service files
$gamePath = Join-Path $root "game-service"
$misplacedFiles = @("index.js", "models.js", ".env")
foreach ($file in $misplacedFiles) {
    $src = Join-Path $root $file
    $dest = Join-Path $gamePath $file
    if (Test-Path $src) {
        Move-Item -Force $src $dest
        Write-Host "Moved $file to game-service folder"
    }
}

# Remove stray node_modules
$nodeModulesPath = Join-Path $root "node_modules"
if (Test-Path $nodeModulesPath) {
    Remove-Item -Recurse -Force $nodeModulesPath
    Write-Host "Removed stray node_modules from root"
}

# Delete stray package.json and package-lock.json from root
foreach ($file in @("package.json","package-lock.json")) {
    $filePath = Join-Path $root $file
    if (Test-Path $filePath) {
        Remove-Item -Force $filePath
        Write-Host "Deleted stray $file from root"
    }
}

# --- Add Dockerfiles with correct ports ---
foreach ($service in $services) {
    $dockerfile = Join-Path $root "$service\Dockerfile"
    if (-Not (Test-Path $dockerfile)) {

        switch ($service) {
            "game-service"      { $port = 3001 }
            "order-service"     { $port = 3002 }
            "analytics-service" { $port = 3003 }
            default             { $port = 3000 }
        }

        @"
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE $port
CMD ["node","index.js"]
"@ | Set-Content $dockerfile

        Write-Host "Dockerfile created for $service (port $port)"
    }
}

# --- Kubernetes manifests folder ---
$k8sPath = Join-Path $root "k8s"
if (-Not (Test-Path $k8sPath)) {
    New-Item -ItemType Directory -Path $k8sPath | Out-Null
}

# --- Generate Kubernetes manifests with correct ports ---
foreach ($service in $services) {
    switch ($service) {
        "game-service"      { $port = 3001 }
        "order-service"     { $port = 3002 }
        "analytics-service" { $port = 3003 }
        default             { $port = 3000 }
    }

    $deploymentFile = Join-Path $k8sPath "$service-deployment.yaml"
    $yaml = @"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $service
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $service
  template:
    metadata:
      labels:
        app: $service
    spec:
      containers:
      - name: $service
        image: $service:latest
        ports:
        - containerPort: $port
---
apiVersion: v1
kind: Service
metadata:
  name: $service
spec:
  selector:
    app: $service
  ports:
  - port: 80
    targetPort: $port
"@
    $yaml | Set-Content $deploymentFile
    Write-Host "Kubernetes manifest created for $service (port $port)"
}

# --- Ingress manifest ---
$ingressFile = Join-Path $k8sPath "ingress.yaml"
$ingressYaml = @"
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: lugx-ingress
spec:
  rules:
  - http:
      paths:
      - path: /games
        pathType: Prefix
        backend:
          service:
            name: game-service
            port:
              number: 80
      - path: /orders
        pathType: Prefix
        backend:
          service:
            name: order-service
            port:
              number: 80
      - path: /analytics
        pathType: Prefix
        backend:
          service:
            name: analytics-service
            port:
              number: 80
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend
            port:
              number: 80
"@
$ingressYaml | Set-Content $ingressFile
Write-Host "Ingress manifest created (lugx-ingress)."

# --- Frontend folder and Dockerfile ---
$frontendPath = Join-Path $root "frontend"
if (-Not (Test-Path $frontendPath)) {
    New-Item -ItemType Directory -Path $frontendPath | Out-Null
    Write-Host "Created frontend folder (drop Lugx template files here)"
}

$frontendDockerfile = Join-Path $frontendPath "Dockerfile"
if (-Not (Test-Path $frontendDockerfile)) {
    @"
FROM nginx:alpine
COPY . /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
"@ | Set-Content $frontendDockerfile
    Write-Host "Dockerfile created for frontend"
}

$frontendYaml = Join-Path $k8sPath "frontend-deployment.yaml"
if (-Not (Test-Path $frontendYaml)) {
    @"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: frontend:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
"@ | Set-Content $frontendYaml
    Write-Host "Frontend Kubernetes Deployment & Service created"
}

Write-Host "Cleanup + Dockerfiles + Kubernetes manifests + Ingress + Frontend completed!"
