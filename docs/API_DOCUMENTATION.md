# REST API Documentation (Version 1.0)

Base URL: `http://localhost:5000/api/v1`

All responses follow a consistent JSON envelope format:

**Success Response:**
```json
{
  "success": true,
  "message": "Human-readable description",
  "data": {},
  "meta": { "page": 1, "limit": 20, "total": 100 }
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Descriptive error message",
  "code": "ERROR_CODE",
  "errors": [],
  "correlationId": "uuid-v4-string"
}
```

---

## 1. Authentication Endpoints (`/api/v1/auth`)

### `POST /auth/register`
- **Purpose:** Register a new customer account.
- **Auth:** Public.
- **Request Body:**
  ```json
  {
    "email": "customer@example.com",
    "password": "Password@123",
    "first_name": "Sophia",
    "last_name": "Chen",
    "phone": "+1-555-0142"
  }
  ```
- **Response (201):** User profile, `accessToken`, and `refreshToken`.

### `POST /auth/login`
- **Purpose:** Authenticate user credentials.
- **Auth:** Public.
- **Request Body:**
  ```json
  {
    "email": "admin@luxecomm.com",
    "password": "Password@123"
  }
  ```
- **Response (200):** User profile with role (`admin` or `customer`) and JWT tokens.

### `POST /auth/refresh-token`
- **Purpose:** Issue new JWT access token using valid refresh token.
- **Auth:** Public.

### `GET /auth/profile`
- **Purpose:** Retrieve authenticated user profile and addresses.
- **Auth:** Required (`Bearer <token>`).

---

## 2. Product Catalog Endpoints (`/api/v1/products`)

### `GET /products`
- **Purpose:** Query products catalog with filters and pagination.
- **Auth:** Public.
- **Query Parameters:**
  - `page`: Page number (default: `1`)
  - `limit`: Items per page (default: `12`)
  - `category`: Category slug (e.g. `audio-acoustics`)
  - `search`: Keyword query matching name, SKU, or description
  - `min_price` / `max_price`: Numeric price range
  - `sort`: `newest` | `price_asc` | `price_desc` | `featured`
  - `in_stock`: `true` | `false`

### `GET /products/featured`
- **Purpose:** Retrieve curated featured products for landing showcase.

### `GET /products/:identifier`
- **Purpose:** Get complete product specifications, ordered images, variants, and reviews by ID or slug.

---

## 3. Shopping Cart Endpoints (`/api/v1/cart`)

### `GET /cart`
- **Purpose:** Retrieve cart summary, calculated items, subtotal, discount, tax, shipping, and total.
- **Headers:** `X-Session-ID` (guest) or `Authorization: Bearer <token>`.

### `POST /cart/items`
- **Purpose:** Add product or variant to shopping cart.
- **Request Body:**
  ```json
  {
    "product_id": "prod-001",
    "variant_id": "var-001",
    "quantity": 1
  }
  ```

### `PUT /cart/items/:itemId`
- **Purpose:** Update quantity of item in cart.

### `DELETE /cart/items/:itemId`
- **Purpose:** Remove item from cart.

### `POST /cart/apply-coupon`
- **Purpose:** Apply promotional coupon (e.g., `LUXE10`).
- **Request Body:** `{ "coupon_code": "LUXE10" }`

---

## 4. Wishlist Endpoints (`/api/v1/wishlist`)

### `GET /wishlist`
- **Purpose:** Retrieve customer or guest saved items list.

### `POST /wishlist/items`
- **Purpose:** Toggle / add product to wishlist.

### `DELETE /wishlist/items/:productId`
- **Purpose:** Remove product from wishlist.

---

## 5. Orders & Checkout Endpoints (`/api/v1/orders`)

### `POST /orders/checkout`
- **Purpose:** Atomic order placement and stock deduction transaction.
- **Request Body:**
  ```json
  {
    "shipping_address": {
      "recipient_name": "Alexander Vance",
      "phone": "+1-555-0199",
      "street_address": "742 Evergreen Terrace",
      "apartment": "Suite 4B",
      "city": "San Francisco",
      "state": "CA",
      "postal_code": "94107",
      "country": "United States"
    },
    "billing_address": { /* Same as shipping or different */ },
    "payment_method": "credit_card",
    "shipping_method": "Standard Delivery",
    "guest_email": "customer@example.com"
  }
  ```
- **Response (201):** Order record with immutable price snapshots and `order_number`.

### `GET /orders/my-orders`
- **Purpose:** Fetch historical orders for authenticated customer.
- **Auth:** Required (`customer`).

### `GET /orders/:id`
- **Purpose:** Inspect order details and status timeline.

---

## 6. Admin Portal Endpoints (`/api/v1/admin`)
*All Admin endpoints require `Authorization: Bearer <token>` and `role: admin` or `manager`.*

### `GET /admin/dashboard/metrics`
- **Purpose:** Returns aggregate revenue, order counts, active products, and low stock warnings.

### `GET /admin/products` & `POST /admin/products`
- **Purpose:** Browse and create new products with unique SKUs and images.

### `PUT /admin/products/:id` & `DELETE /admin/products/:id`
- **Purpose:** Edit existing product attributes or deactivate.

### `POST /admin/products/:productId/pricing`
- **Purpose:** **Dynamic Price Modification**. Updates selling price and compare-at price while creating an immutable `price_history` audit entry.
- **Request Body:**
  ```json
  {
    "base_price": 299.00,
    "compare_at_price": 349.00,
    "reason": "Seasonal promotion markdown"
  }
  ```

### `GET /admin/products/:productId/price-history`
- **Purpose:** Retrieve complete price audit trail for a product.

### `POST /admin/products/:productId/inventory`
- **Purpose:** Execute atomic inventory adjustment.
- **Request Body:**
  ```json
  {
    "change_quantity": 25,
    "type": "restock",
    "notes": "Inbound supplier shipment PO-889"
  }
  ```

### `GET /admin/inventory/low-stock`
- **Purpose:** Retrieve products at or below their low-stock threshold.

### `GET /admin/orders`
- **Purpose:** View and filter all orders.

### `PUT /admin/orders/:id/status`
- **Purpose:** Update fulfillment status (`pending` &rarr; `processing` &rarr; `shipped` &rarr; `delivered`), tracking number, and audit comments.

### `GET /admin/customers`
- **Purpose:** Query customer directory with aggregate spend and order statistics.
