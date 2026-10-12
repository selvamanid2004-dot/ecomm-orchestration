# Database setup script
Write-Host "Setting up MySQL database via Docker Compose..." -ForegroundColor Cyan

if (Get-Command docker -ErrorAction SilentlyContinue) {
    docker compose up -d mysql
    Write-Host "Waiting 8 seconds for MySQL engine initialization..." -ForegroundColor Yellow
    Start-Sleep -Seconds 8
    Write-Host "Seeding database..." -ForegroundColor Green
    npm run seed --prefix backend
} else {
    Write-Host "Docker was not detected in PATH. If MySQL is running natively on port 3306, running seed directly..." -ForegroundColor Yellow
    npm run seed --prefix backend
}
