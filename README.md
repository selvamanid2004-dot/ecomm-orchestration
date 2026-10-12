# LUXE — Professional Dynamic E-Commerce Application

[![TypeScript](https://img.shields.io/badge/TypeScript-5.5+-blue.svg)](https://www.typescriptlang.org/)
[![Angular](https://img.shields.io/badge/Angular-18+-red.svg)](https://angular.dev/)
[![Node.js](https://img.shields.io/badge/Node.js-24+-green.svg)](https://nodejs.org/)
[![Express](https://img.shields.io/badge/Express-4.19+-lightgrey.svg)](https://expressjs.com/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0+-orange.svg)](https://www.mysql.com/)
[![TypeORM](https://img.shields.io/badge/TypeORM-0.3.20-orange.svg)](https://typeorm.io/)

A production-oriented, dynamic E-Commerce shopping platform and executive administration console architected with modern **Angular (TypeScript)**, **Node.js (Express & TypeScript)**, **TypeORM**, and **MySQL 8.0**.

---

## 🌟 Key Application Capabilities

### 1. Public E-Commerce Storefront
- **Dynamic Catalog:** Real-time catalog powered by MySQL through structured REST APIs with category filtering, search keywords, price sliders, and in-stock toggles.
- **Product Details & Multi-Angle Media:** Full product view with thumbnail image gallery, full-screen image zoom/lightbox, variant selection (Color, Size, Switches), and stock level indicators.
- **Dynamic Price Engine:** All selling prices, discounts, and order totals calculated authoritatively on the backend.
- **Cart & Wishlist Flow:** Guest session persistence merged with authenticated user data upon login. Server-side promo coupon calculation (e.g., `LUXE10`, `WELCOME50`).
- **Secure Checkout:** Full address collection, delivery method selection, payment method choices, and order number generation with carrier tracking.
- **Customer Portal:** Profile review, order history with item snapshots, and printable invoices.

### 2. Separate Admin Management Portal
- **Independent Layout & Guards:** Isolated admin layout with dark luxury styling, restricted behind backend role-based access control (`admin`, `manager`).
- **Operations Dashboard:** Live aggregate KPI metrics (Total Paid Revenue, Total Orders, Active Catalog Items, Low-Stock Warnings, Recent Orders Stream).
- **Product Management:** Complete CRUD, unique SKU validation, category associations, multiple image URLs, and soft-deactivation.
- **Dynamic Price Management & Audit Trail:** Modify selling and compare-at prices with mandatory audit justification reasons; browse immutable historical price audit logs.
- **Inventory Management:** Atomic stock adjustments with pessimistic write locking (`restock`, `sale`, `adjustment`, `return`) and low-stock monitor.
- **Order Fulfillment:** Live status transitions (`pending` &rarr; `processing` &rarr; `shipped` &rarr; `delivered`), carrier tracking input, and status logs.
- **Customer Directory:** Directory of customer accounts with aggregate metrics (total orders placed and lifetime spend).

---

## 🏗️ Architecture & Technology Stack

| Layer | Technology | Responsibility |
|---|---|---|
| **Frontend** | Angular 18 (TypeScript) | Standalone components, reactive Signals, lazy-loaded routing, route guards, functional interceptors |
| **Backend** | Node.js + Express (TypeScript) | Layered REST API: Routes &rarr; Middleware &rarr; Validators &rarr; Controllers &rarr; Services &rarr; TypeORM |
| **Database** | MySQL 8.0 | 21 relational tables with foreign keys, indexes, transactions, and migration scripts |
| **ORM** | TypeORM 0.3.20 | Entity models, relations, transactions with pessimistic locks, connection pooling |
| **Logging** | Winston & Daily Rotate | Structured JSON logging with request correlation IDs (`X-Correlation-ID`) and credential redaction |
| **Security** | Helmet, CORS, Rate Limit, Bcrypt, JWT | Hardened HTTP headers, password hashing, and token authentication |

---

## 🔗 Linked GitHub Repositories
The project is organized both as this unified monorepo orchestration and as three independent services:
- **Frontend App (Angular 19):** [https://github.com/selvamanid2004-dot/ecomm-frontend](https://github.com/selvamanid2004-dot/ecomm-frontend)
- **Backend API (Node.js/Express):** [https://github.com/selvamanid2004-dot/ecomm-backend](https://github.com/selvamanid2004-dot/ecomm-backend)
- **Database & Schemas (MySQL 8.0):** [https://github.com/selvamanid2004-dot/ecomm-database](https://github.com/selvamanid2004-dot/ecomm-database)
- **Root Orchestration Monorepo:** [https://github.com/selvamanid2004-dot/ecomm-orchestration](https://github.com/selvamanid2004-dot/ecomm-orchestration)

---

## 🐳 Quick Start with Full Docker Orchestration

To run the entire system (Database + Backend API + Frontend Nginx + phpMyAdmin) with a single command:

```bash
# Build and start all 4 services in the background
docker compose up -d --build

# View real-time aggregated logs
docker compose logs -f

# Check health of all running containers
docker compose ps
```

### Services & URLs:
- **Storefront & Admin:** [http://localhost](http://localhost) (or [http://localhost:4200](http://localhost:4200))
- **Backend REST API:** [http://localhost:5000/api/v1/health](http://localhost:5000/api/v1/health)
- **phpMyAdmin Interface:** [http://localhost:8080](http://localhost:8080)
- **MySQL Direct Port:** `127.0.0.1:3306`

---

## 💻 Manual Local Development Setup

### Prerequisites
- **Node.js**: v20+ or v24+
- **npm**: v10+ or v11+
- **MySQL**: Native MySQL 8.0 server on port 3306 OR Docker

### 1. Database Setup
Start MySQL using Docker Compose:
```bash
docker compose up -d mysql
```
*Or ensure your local MySQL server is running on `127.0.0.1:3306` with database `ecommerce_db`.*

### 2. Seed Initial Database Data
Execute the seed runner to populate categories, products, images, variants, coupons, admin, and customer records:
```bash
npm run seed --prefix backend
```

### 3. Start Backend & Frontend
Launch both services with one command:
```powershell
# Windows PowerShell
.\scripts\dev.ps1
```
Or start them individually:
```bash
# Terminal 1: Backend API (port 5000)
cd backend
npm run dev

# Terminal 2: Angular Storefront & Admin (port 4200)
cd frontend
npm start
```

### 4. Access URLs & Demo Accounts
- **Public Storefront:** [http://localhost:4200](http://localhost:4200)
- **Admin Management Portal:** [http://localhost:4200/admin](http://localhost:4200/admin)
- **API Health Check:** [http://localhost:5000/api/v1/health](http://localhost:5000/api/v1/health)

#### Pre-Configured Demo Accounts:
| Role | Email | Password | Access |
|---|---|---|---|
| **Administrator** | `admin@luxecomm.com` | `Password@123` | Full Admin Portal & Storefront |
| **Customer** | `sophia.chen@example.com` | `Password@123` | Storefront, Wishlist, Bag, Account |

---

## 📚 Complete Developer Documentation
Comprehensive architectural documentation is located in the `docs/` directory:
- [Architecture & Design Decisions](docs/ARCHITECTURE.md)
- [Project Directory Structure](docs/PROJECT_STRUCTURE.md)
- [Database Schema & Migrations](docs/DATABASE.md)
- [REST API Specification](docs/API_DOCUMENTATION.md)
- [Development & Handover Guide](docs/DEVELOPMENT_GUIDE.md)
- [Logging & Centralized Error Handling](docs/LOGGING_AND_ERRORS.md)
- [Security Architecture](docs/SECURITY.md)
- [Automated Testing Strategy](docs/TESTING.md)
- [Production Deployment Guide](docs/DEPLOYMENT.md)
