# PowerShell script to boot both Backend and Frontend in separate windows
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  LUXE E-COMMERCE DEVELOPMENT ENVIRONMENT RUNNER  " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# 1. Start Backend
Write-Host "[1/2] Starting Node.js Express Backend on http://localhost:5000..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd backend; npm run dev"

# 2. Start Frontend
Write-Host "[2/2] Starting Angular Dev Server on http://localhost:4200..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd frontend; npm start"

Write-Host "Both services are launching in their respective consoles." -ForegroundColor Yellow
Write-Host "Public Storefront: http://localhost:4200" -ForegroundColor Cyan
Write-Host "Admin Portal:      http://localhost:4200/admin" -ForegroundColor Cyan
Write-Host "Backend API:       http://localhost:5000/api/v1/health" -ForegroundColor Cyan
