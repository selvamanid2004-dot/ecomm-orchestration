# Project Structure & Directory Organization

```text
ecommerce-project/
├── backend/                              # Node.js + Express + TypeScript Backend
│   ├── src/
│   │   ├── config/                       # Environment & DB configurations
│   │   │   ├── database.config.ts        # TypeORM MySQL connection pool & entities
│   │   │   └── environment.config.ts     # Zod validated environment variables
│   │   ├── controllers/                  # HTTP route controllers
│   │   │   ├── admin/                    # Admin portal controllers
│   │   │   │   ├── admin-customer.controller.ts
│   │   │   │   ├── admin-dashboard.controller.ts
│   │   │   │   ├── admin-inventory.controller.ts
│   │   │   │   ├── admin-order.controller.ts
│   │   │   │   ├── admin-price.controller.ts
│   │   │   │   └── admin-product.controller.ts
│   │   │   ├── auth.controller.ts
│   │   │   ├── cart.controller.ts
│   │   │   ├── category.controller.ts
│   │   │   ├── customer.controller.ts
│   │   │   ├── order.controller.ts
│   │   │   ├── product.controller.ts
│   │   │   └── wishlist.controller.ts
│   │   ├── database/
│   │   │   └── seeds/
│   │   │       └── run-seeds.ts          # Programmatic seed runner for MySQL
│   │   ├── entities/                     # TypeORM database models (21 entities)
│   │   │   ├── AuditLog.ts
│   │   │   ├── Cart.ts & CartItem.ts
│   │   │   ├── Category.ts
│   │   │   ├── Coupon.ts & CouponUsage.ts
│   │   │   ├── Customer.ts & CustomerAddress.ts
│   │   │   ├── InventoryAdjustment.ts
│   │   │   ├── Order.ts & OrderItem.ts & OrderStatusHistory.ts
│   │   │   ├── Payment.ts
│   │   │   ├── PriceHistory.ts
│   │   │   ├── Product.ts & ProductImage.ts & ProductVariant.ts
│   │   │   ├── Review.ts
│   │   │   └── User.ts
│   │   ├── errors/                       # AppError, NotFoundError, ValidationError
│   │   ├── logging/
│   │   │   └── logger.ts                 # Winston logger with data redaction
│   │   ├── middleware/                   # Express pipeline middleware
│   │   │   ├── auth.middleware.ts        # JWT verification & role authorization
│   │   │   ├── error.middleware.ts       # Centralized error handler
│   │   │   ├── rate-limit.middleware.ts  # Express rate limiting
│   │   │   └── request-logger.middleware.ts # X-Correlation-ID & timing
│   │   ├── routes/                       # Express router definitions
│   │   │   ├── admin.routes.ts           # Protected /api/v1/admin/* routes
│   │   │   └── index.ts                  # Consolidated API v1 routing
│   │   ├── services/                     # Authoritative business logic
│   │   │   ├── admin-dashboard.service.ts
│   │   │   ├── auth.service.ts
│   │   │   ├── cart.service.ts
│   │   │   ├── category.service.ts
│   │   │   ├── coupon.service.ts
│   │   │   ├── customer.service.ts
│   │   │   ├── inventory.service.ts
│   │   │   ├── order.service.ts
│   │   │   ├── pricing.service.ts
│   │   │   ├── product.service.ts
│   │   │   └── wishlist.service.ts
│   │   ├── validators/                   # Zod schemas for input validation
│   │   ├── app.ts                        # Express application factory
│   │   └── server.ts                     # HTTP bootstrap & graceful shutdown
│   ├── tests/
│   │   └── ecommerce.spec.ts             # Supertest & Jest test suite
│   ├── package.json
│   └── tsconfig.json
│
├── frontend/                             # Angular 18 Client Application
│   ├── src/
│   │   ├── app/
│   │   │   ├── core/
│   │   │   │   ├── guards/               # authGuard & adminGuard
│   │   │   │   ├── interceptors/         # authInterceptor (JWT & Session headers)
│   │   │   │   ├── models/               # TypeScript interfaces
│   │   │   │   └── services/             # Angular API services with Signals
│   │   │   ├── features/
│   │   │   │   ├── admin/                # Admin management views
│   │   │   │   │   ├── admin-customers.component.ts
│   │   │   │   │   ├── admin-dashboard.component.ts
│   │   │   │   │   ├── admin-inventory.component.ts
│   │   │   │   │   ├── admin-orders.component.ts
│   │   │   │   │   ├── admin-pricing.component.ts
│   │   │   │   │   └── admin-products.component.ts
│   │   │   │   ├── authentication/       # Login & Register views
│   │   │   │   ├── cart/                 # Shopping bag & checkout review
│   │   │   │   ├── checkout/             # Payment & destination form
│   │   │   │   ├── customer-account/     # Orders timeline & invoices
│   │   │   │   ├── home/                 # Hero banner & featured showcase
│   │   │   │   ├── product-details/      # Multi-angle gallery, zoom, variants
│   │   │   │   ├── products/             # Filterable product catalog
│   │   │   │   └── wishlist/             # Saved items grid
│   │   │   ├── layouts/
│   │   │   │   ├── admin-layout/         # Sidebar, health check, dark theme
│   │   │   │   └── storefront-layout/    # Top announcement, navbar, footer
│   │   │   ├── app.config.ts             # Providers, HttpClient, router
│   │   │   └── app.routes.ts             # Route definitions with lazy loading
│   │   ├── environments/                 # Base URLs (development & production)
│   │   ├── index.html                    # Plus Jakarta Sans typography
│   │   └── styles.css                    # Luxury vanilla CSS design system
│   ├── angular.json
│   ├── package.json
│   └── tsconfig.json
│
├── database/
│   ├── migrations/
│   │   └── 001_initial_schema.sql        # 21 MySQL tables, foreign keys, indexes
│   └── seeds/
│       └── 001_initial_seeds.sql         # Seed categories, products, images, coupons
│
├── docs/                                 # Complete developer documentation
├── scripts/                              # Development & deployment scripts
│   ├── dev.ps1                           # Concurrently boots backend & frontend
│   └── setup-db.ps1                      # Initializes MySQL & seeds
├── docker-compose.yml                    # MySQL 8.0 & phpMyAdmin container specs
├── package.json                          # Root repository scripts
└── README.md
```
