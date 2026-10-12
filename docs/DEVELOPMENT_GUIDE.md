# Developer Handover & Engineering Guide

## 1. Onboarding & Local Development Setup

To onboard onto this codebase:

```bash
# 1. Clone repository and install dependencies
cd ecomm
cd backend && npm install
cd ../frontend && npm install
cd ..

# 2. Configure Environment Files
# backend/.env is pre-configured with local defaults
# frontend/src/environments/environment.ts targets http://localhost:5000/api/v1

# 3. Boot MySQL Database via Docker (or connect to native local MySQL)
docker compose up -d mysql

# 4. Populate Database Seeds
npm run seed --prefix backend

# 5. Launch Full Stack Dev Environment
.\scripts\dev.ps1
```

---

## 2. Developer Handover Standard (Section 24 Traces)

Every major feature is mapped below through all 10 architectural tiers so that any engineer can trace, maintain, or debug the system.

---

### Feature Trace 1: Dynamic Price Management & Price History

```
1. Feature Start: Administrator updates a product's selling price in the Admin Console.
2. Angular Component: frontend/src/app/features/admin/admin-pricing.component.ts
3. Angular Service: AdminService.updatePrice(productId, basePrice, compareAt, reason)
   ↳ File: frontend/src/app/core/services/admin.service.ts
4. Backend Route: POST /api/v1/admin/products/:productId/pricing
   ↳ File: backend/src/routes/admin.routes.ts
5. Middleware: authenticateJwt, requireRoles('admin', 'manager'), validateRequest(updatePriceSchema)
   ↳ Files: backend/src/middleware/auth.middleware.ts, backend/src/validators/pricing.validator.ts
6. Controller: AdminPriceController.updatePrice
   ↳ File: backend/src/controllers/admin/admin-price.controller.ts
7. Business Service: PricingService.updateProductPrice
   ↳ File: backend/src/services/pricing.service.ts
8. Entity / ORM: Product entity updated; new PriceHistory and AuditLog records inserted.
   ↳ Files: backend/src/entities/Product.ts, PriceHistory.ts, AuditLog.ts
9. MySQL Tables Affected: `products`, `price_history`, `audit_logs`.
10. Verification:
    - Base price updates in database.
    - Public storefront displays updated price immediately.
    - Past orders retain their original purchase price.
```

---

### Feature Trace 2: Customer Checkout & Inventory Transaction

```
1. Feature Start: Customer submits delivery address and payment choice on Checkout page.
2. Angular Component: frontend/src/app/features/checkout/checkout.component.ts
3. Angular Service: OrderService.checkout(payload)
   ↳ File: frontend/src/app/core/services/order.service.ts
4. Backend Route: POST /api/v1/orders/checkout
   ↳ File: backend/src/routes/order.routes.ts
5. Middleware: optionalAuth, validateRequest(checkoutSchema)
   ↳ Files: backend/src/middleware/auth.middleware.ts, backend/src/validators/order.validator.ts
6. Controller: OrderController.createOrder
   ↳ File: backend/src/controllers/order.controller.ts
7. Business Service: OrderService.createOrderFromCart
   ↳ File: backend/src/services/order.service.ts
   ↳ Runs inside AppDataSource.transaction(...) with pessimistic write locking on products.
8. Entity / ORM:
   - Locks Product / ProductVariant (`SELECT ... FOR UPDATE`).
   - Decrements `stock_quantity`.
   - Creates `InventoryAdjustment` audit record.
   - Inserts `Order` and snapshots prices into `OrderItem`.
   - Inserts `OrderStatusHistory` ('pending').
   - Inserts `Payment` transaction record.
   - Deletes line items from `CartItem`.
9. MySQL Tables Affected:
   `products`, `product_variants`, `inventory_adjustments`, `orders`, `order_items`, `order_status_history`, `payments`, `cart_items`.
10. Verification:
    - Run `npm test --prefix backend` (`tests/ecommerce.spec.ts`).
    - Verify stock decrement in MySQL and order record in customer account.
```

---

### Feature Trace 3: Shopping Cart & Server-Side Coupon Engine

```
1. Feature Start: User inputs promo coupon code (e.g. LUXE10) in Shopping Bag view.
2. Angular Component: frontend/src/app/features/cart/cart.component.ts
3. Angular Service: CartService.applyCoupon(code)
   ↳ File: frontend/src/app/core/services/cart.service.ts
4. Backend Route: POST /api/v1/cart/apply-coupon
   ↳ File: backend/src/routes/cart.routes.ts
5. Middleware: optionalAuth, validateRequest(applyCouponSchema)
6. Controller: CartController.applyCoupon
   ↳ File: backend/src/controllers/cart.controller.ts
7. Business Service: CartService.applyCoupon -> CouponService.validateCoupon
   ↳ Files: backend/src/services/cart.service.ts, backend/src/services/coupon.service.ts
8. Entity / ORM: Updates `Cart.coupon_code` and recalculates authoritative discounts and taxes.
9. MySQL Tables Affected: `carts`, `coupons`.
10. Verification:
    - Validates minimum order threshold ($100 for LUXE10).
    - Caps discount if `max_discount_amount` is defined.
```

---

### Feature Trace 4: Admin Order Fulfillment & Carrier Tracking

```
1. Feature Start: Admin marks order as 'Shipped' and inputs carrier tracking code.
2. Angular Component: frontend/src/app/features/admin/admin-orders.component.ts
3. Angular Service: AdminService.updateOrderStatus(orderId, status, paymentStatus, tracking, comments)
   ↳ File: frontend/src/app/core/services/admin.service.ts
4. Backend Route: PUT /api/v1/admin/orders/:id/status
   ↳ File: backend/src/routes/admin.routes.ts
5. Middleware: authenticateJwt, requireRoles('admin', 'manager'), validateRequest(updateOrderStatusSchema)
6. Controller: AdminOrderController.updateStatus
   ↳ File: backend/src/controllers/admin/admin-order.controller.ts
7. Business Service: OrderService.updateOrderStatus
   ↳ File: backend/src/services/order.service.ts
8. Entity / ORM:
   - Updates `Order.status` and `Order.tracking_number`.
   - Inserts `OrderStatusHistory` entry with previous status, new status, and audit comments.
9. MySQL Tables Affected: `orders`, `order_status_history`.
10. Verification:
    - Customer portal `/account` immediately displays carrier tracking code and shipped status badge.
```

---

## 3. How to Add a New API Endpoint

1. **Define Entity (if new table needed):**
   Add decorator class in `backend/src/entities/NewEntity.ts` and export from `backend/src/entities/index.ts`.
2. **Add Validation Schema:**
   Create Zod schema in `backend/src/validators/new.validator.ts`.
3. **Implement Business Logic:**
   Add method in `backend/src/services/new.service.ts`.
4. **Create Controller Method:**
   Add handler in `backend/src/controllers/new.controller.ts`.
5. **Connect Route & Middleware:**
   Add route in `backend/src/routes/new.routes.ts` and mount in `backend/src/routes/index.ts`.
6. **Add Unit/Integration Test:**
   Add test case in `backend/tests/ecommerce.spec.ts` and run `npm test`.
