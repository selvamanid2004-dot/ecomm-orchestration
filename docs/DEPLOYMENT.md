# Production Deployment Guide

## 1. Production Architecture

In a production environment, the frontend static assets and backend API can be served via Nginx with Node.js managed under PM2 or Docker.

```text
[Internet / Cloudflare CDN]
             │
      (HTTPS :443)
             ▼
      [Nginx Reverse Proxy]
      ├── /api/*   ──────▶ [Node.js Express Cluster (PM2 / Port 5000)]
      │                                   │
      │                                   ▼
      │                          [MySQL 8.0 Primary DB]
      └── /*       ──────▶ [Angular Static Assets (dist/frontend/browser)]
```

---

## 2. Environment Variables Checklist

Prior to production deployment, create a private `.env` file on the backend host with production-grade secrets:

```bash
NODE_ENV=production
PORT=5000

DB_HOST=mysql-db-instance.internal
DB_PORT=3306
DB_USER=production_ecomm_user
DB_PASSWORD=YOUR_HIGH_ENTROPY_PASSWORD
DB_NAME=ecommerce_db
DB_LOGGING=false
DB_SYNCHRONIZE=false

JWT_SECRET=YOUR_64_CHAR_RANDOM_SECRET_KEY
JWT_EXPIRES_IN=7d
REFRESH_TOKEN_SECRET=YOUR_64_CHAR_RANDOM_REFRESH_KEY
REFRESH_TOKEN_EXPIRES_IN=30d

FRONTEND_ORIGIN=https://www.luxe-studio.com
ADMIN_ORIGIN=https://admin.luxe-studio.com

LOG_LEVEL=info
LOG_DIR=/var/log/luxecomm
UPLOAD_DIR=/var/data/luxecomm/uploads
MAX_FILE_SIZE=5242880
```

---

## 3. Production Build Commands

```bash
# 1. Build Backend (TypeScript compilation to CommonJS dist/)
cd backend
npm run build

# 2. Build Frontend (Angular AOT compilation)
cd ../frontend
npm run build --configuration=production
```

---

## 4. Database Migrations in CI/CD

Never run `DB_SYNCHRONIZE=true` in production. Always apply audited migration scripts:
```bash
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < database/migrations/001_initial_schema.sql
```

---

## 5. Process Management (PM2)

Start the compiled Node.js backend under PM2 cluster mode:
```bash
pm2 start dist/server.js --name "luxe-api" -i max
pm2 save
pm2 startup
```

Health check verification:
```bash
curl -I https://api.luxe-studio.com/api/v1/health
# HTTP/1.1 200 OK
```
