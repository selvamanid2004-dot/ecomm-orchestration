# Security Architecture & Best Practices

## 1. Authentication & Session Security

- **Password Hashing:** Passwords are never stored in plain text. They are hashed using **Bcrypt** (`bcryptjs`) with 10 salt rounds before database persistence.
- **JWT Signing:** Access tokens (`JWT_SECRET`) are signed and verified with cryptographic algorithms and enforced expiration (`7d`).
- **Refresh Token Rotation:** Refresh tokens allow session extension without exposing raw login credentials repeatedly.
- **Authorization Enforcement:** Client-side route guards prevent unauthorized UI navigation, while backend middleware (`requireRoles('admin', 'manager')`) strictly rejects unauthorized API requests with `403 Forbidden`.

---

## 2. SQL Injection Prevention

- **Parameterized Queries:** All database interactions utilize TypeORM repositories or TypeORM QueryBuilder parameter binding:
  ```typescript
  qb.where('product.slug = :identifier OR product.id = :identifier', { identifier });
  ```
- No raw concatenated SQL strings are used in application routes or controllers.

---

## 3. Defense-in-Depth Measures

| Security Layer | Implementation | Purpose |
|---|---|---|
| **Helmet** | `helmet()` | Enforces secure HTTP headers (`X-Content-Type-Options`, `Strict-Transport-Security`, `X-Frame-Options`). |
| **CORS** | `cors({ origin: [...] })` | Limits API access to trusted frontend origins (`FRONTEND_ORIGIN`). |
| **Rate Limiting** | `express-rate-limit` | Protects auth endpoints against brute-force password guessing (30 requests per 15 min). |
| **Payload Limits** | `express.json({ limit: '10mb' })` | Prevents denial-of-service through memory exhaustion. |
| **Authoritative Pricing** | Server-side calculation | Angular client never dictates final order payable amounts. |
| **Pessimistic Locking** | `SELECT ... FOR UPDATE` | Prevents inventory race conditions during peak checkout traffic. |
| **Audit Logging** | `audit_logs` & `price_history` | Tracks all administrative price updates and role changes. |
