# System Architecture & Technical Specifications

## 1. Architectural Philosophy

The LUXE E-Commerce platform is designed around strict separation of concerns, enterprise resilience, and immutable transactional safety. Business rules and financial calculations are executed exclusively within the Node.js backend against authoritative MySQL records, preventing client-side price tampering, overselling of limited inventory, or unauthorized administrative actions.

```
+-------------------------------------------------------------------------+
|                           ANGULAR 18 FRONTEND                           |
|  [Storefront Views]  [Product Gallery]  [Cart / Bag]  [Admin Console]  |
|         |                     |              |               |          |
|  Signals & State      Services Layer    HTTP Interceptor (Bearer & Sess)|
+-----------------------------------|-------------------------------------+
                                    | REST / JSON (HTTP)
                                    v
+-------------------------------------------------------------------------+
|                     NODE.JS / EXPRESS.JS BACKEND                        |
|  [Helmet / CORS] -> [Correlation ID] -> [Rate Limit] -> [JWT Auth]     |
|                                    |                                    |
|                           [Zod Validators]                              |
|                                    |                                    |
|                            [Controllers]                                |
|                                    |                                    |
|                          [Business Services]                            |
|             (Pricing Engine, Cart Calculator, Order Lock)               |
|                                    |                                    |
|                         [TypeORM Data Layer]                            |
+------------------------------------|------------------------------------+
                                     | MySQL Connection Pool
                                     v
+-------------------------------------------------------------------------+
|                             MYSQL 8.0 DATABASE                          |
|  21 Relational Tables | Foreign Keys | Acid Transactions | Migrations   |
+-------------------------------------------------------------------------+
```

---

## 2. Technology Selection Rationale

### Frontend: Angular with TypeScript
- **Enterprise-Grade Modularity:** Clean separation of presentation, business services, and routing.
- **Standalone Component Architecture:** Eliminates legacy NgModule boilerplate while delivering fine-grained, tree-shakeable chunks.
- **Signals-Based Reactivity:** Synchronous, fine-grained reactivity for shopping cart counters, active filters, and wishlist toggles without memory leaks.
- **Type Safety:** Comprehensive models (`Product`, `CartSummary`, `Order`) shared between services and templates.

### Backend: Node.js, Express, and TypeScript
- **Layered Decoupling:** Handlers do not contain business logic; services do not access Express `req`/`res` objects; database entities encapsulate schema definitions.
- **Asynchronous Throughput:** High-performance non-blocking I/O ideal for concurrent inventory locking and checkout transactions.
- **Consistent Typing:** TypeScript compiler guarantees that database payloads match validated DTO schemas.

### Database: MySQL 8.0 & TypeORM
- **ACID Transaction Guarantees:** Multi-table operations (such as order placement, stock deduction, and payment verification) run inside strict `manager.transaction(...)` boundaries.
- **Pessimistic Write Locking:** Uses `pessimistic_write` locks during checkout to prevent concurrent race conditions from overselling inventory.
- **Relational Integrity:** Foreign keys with `ON DELETE CASCADE` or `SET NULL` ensure zero orphaned records across order items, addresses, and images.

---

## 3. End-to-End Request Lifecycle

```text
1. Client Action (e.g. Add to Bag, Checkout, Update Price)
   ↓
2. Angular Component (Captures user intention and invokes service)
   ↓
3. Angular API Service (Appends active session ID and Bearer token via Interceptor)
   ↓
4. Express Router (Routes to versioned endpoint under /api/v1/*)
   ↓
5. Request Logger & Correlation Middleware (Injects X-Correlation-ID)
   ↓
6. Authentication & Authorization Middleware (Verifies JWT signature and checks user role)
   ↓
7. Zod Schema Validator (Validates body, query, and path parameters)
   ↓
8. Controller (Extracts typed parameters and calls business service)
   ↓
9. Business Service (Executes calculations, locks inventory, checks limits)
   ↓
10. TypeORM Repository / EntityManager (Issues parameterized SQL to MySQL)
   ↓
11. MySQL Database (Commits transaction)
   ↓
12. Standard JSON Response Envelope ({ success: true, message: '...', data: ... })
   ↓
13. Angular View Update (Signal updates trigger instantaneous DOM re-render)
```
