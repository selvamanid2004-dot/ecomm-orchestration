# MySQL Database Architecture & Migrations

## 1. Database Overview

The application utilizes **MySQL 8.0** with strict InnoDB storage engine semantics, `utf8mb4` character encoding, and `utf8mb4_unicode_ci` collation. 

All foreign key relationships enforce strict cascading or nullification to avoid orphaned data. Critical write operations (checkout, price updates, stock replenishment) utilize ACID transactions with **pessimistic write locking** (`SELECT ... FOR UPDATE`).

---

## 2. Relational Entity Schema

### Core Tables Summary

| Table | Primary Key | Foreign Keys / References | Description |
|---|---|---|---|
| `users` | `id` (VARCHAR 36) | - | Admin, managers, and customers with Bcrypt hashes |
| `customers` | `id` (VARCHAR 36) | `user_id` &rarr; `users.id` (CASCADE) | Customer profiles, loyalty tiers, notes |
| `customer_addresses` | `id` (VARCHAR 36) | `customer_id` &rarr; `customers.id` (CASCADE) | Shipping and billing address book |
| `categories` | `id` (VARCHAR 36) | `parent_id` &rarr; `categories.id` (SET NULL) | Product category taxonomy |
| `products` | `id` (VARCHAR 36) | `category_id` &rarr; `categories.id` (SET NULL) | Master product records with SKU, base price, stock |
| `product_images` | `id` (VARCHAR 36) | `product_id` &rarr; `products.id` (CASCADE) | Multi-angle imagery with `display_order` |
| `product_variants` | `id` (VARCHAR 36) | `product_id` &rarr; `products.id` (CASCADE) | Options (Color, Size, Switches) with price override |
| `price_history` | `id` (VARCHAR 36) | `product_id` &rarr; `products.id` (CASCADE) | Immutable audit trail of old & new prices + reason |
| `inventory_adjustments`| `id` (VARCHAR 36) | `product_id` &rarr; `products.id` (CASCADE) | Audit records of stock deltas (`restock`, `sale`, etc.) |
| `wishlists` | `id` (VARCHAR 36) | `customer_id` &rarr; `customers.id` (CASCADE) | Persisted customer or guest session wishlists |
| `wishlist_items` | `id` (VARCHAR 36) | `wishlist_id`, `product_id` (CASCADE) | Unique constraint preventing duplicate entries |
| `carts` | `id` (VARCHAR 36) | `customer_id` &rarr; `customers.id` (CASCADE) | Active shopping cart with coupon and discount anchors |
| `cart_items` | `id` (VARCHAR 36) | `cart_id`, `product_id`, `variant_id` | Line items with quantity and unit price |
| `orders` | `id` (VARCHAR 36) | `customer_id` &rarr; `customers.id` (SET NULL) | Master order header, status, payment status, totals |
| `order_items` | `id` (VARCHAR 36) | `order_id` &rarr; `orders.id` (CASCADE) | **Immutable price snapshot** and SKU at purchase time |
| `order_status_history`| `id` (VARCHAR 36) | `order_id` &rarr; `orders.id` (CASCADE) | Audit log of status transitions and carrier updates |
| `payments` | `id` (VARCHAR 36) | `order_id` &rarr; `orders.id` (CASCADE) | Gateway transaction references and verification logs |
| `coupons` | `id` (VARCHAR 36) | - | Promo discount codes (percentage vs fixed) |
| `coupon_usages` | `id` (VARCHAR 36) | `coupon_id`, `order_id` (CASCADE) | Tracks individual customer redemption counts |
| `reviews` | `id` (VARCHAR 36) | `product_id` &rarr; `products.id` (CASCADE) | Customer ratings and approved reviews |
| `audit_logs` | `id` (VARCHAR 36) | - | Administrative operations audit log |

---

## 3. Critical Business Data Rules

### Immutable Order Item Price Snapshots
When an order is created, `order_items` records:
- `unit_price`: The exact base price or variant override valid at that second.
- `product_name`: The product title at purchase time.
- `sku`: The SKU at purchase time.

Future price increases, promotional markdowns, or product deletions **never alter historical orders**.

### Concurrency & Oversell Protection
During `OrderService.createOrderFromCart(...)`:
```typescript
const product = await manager.findOne(Product, {
  where: { id: item.productId },
  lock: { mode: 'pessimistic_write' }, // SELECT ... FOR UPDATE
});
```
This forces concurrent checkout requests targeting the same product to queue sequentially, ensuring stock never drops below zero.

---

## 4. Migration & Seeding Instructions

### Executing Initial Schema Migration:
```bash
mysql -u root -p ecommerce_db < database/migrations/001_initial_schema.sql
```

### Seeding Catalog & Demo Records:
```bash
npm run seed --prefix backend
```
*Or execute `database/seeds/001_initial_seeds.sql` directly into MySQL.*
