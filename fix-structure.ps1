# fix-structure.ps1
# Cleanup and fix folder structure for lugx-gaming microservices

$root = "C:\lugx-gaming"

# Define expected service folders
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

# Remove stray node_modules from root
$nodeModulesPath = Join-Path $root "node_modules"
if (Test-Path $nodeModulesPath) {
    Remove-Item -Recurse -Force $nodeModulesPath
    Write-Host "Removed stray node_modules from root"
}

# Delete stray package.json and package-lock.json in root (outside services)
$packageJsonRoot = Join-Path $root "package.json"
$packageLockRoot = Join-Path $root "package-lock.json"
if (Test-Path $packageJsonRoot) {
    Remove-Item -Force $packageJsonRoot
    Write-Host "Deleted stray package.json from root"
}
if (Test-Path $packageLockRoot) {
    Remove-Item -Force $packageLockRoot
    Write-Host "Deleted stray package-lock.json from root"
}

Write-Host "Folder structure cleanup completed."
