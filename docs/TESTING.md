# Testing Strategy & Execution

## 1. Automated Test Suite

The test suite covers critical business workflows, pricing precision, coupon rules, and input validation without external network dependencies.

Tests are located in `backend/tests/ecommerce.spec.ts`.

### Test Coverage Highlights
1. **API Health & Middleware:** Verifies HTTP 200 health responses and `X-Correlation-ID` header injection.
2. **404 Routing:** Asserts structured error envelope format for undefined endpoints.
3. **Pricing Calculations:** Verifies floating-point arithmetic precision on multi-unit orders (e.g. `$349.99 * 3 = $1049.97`).
4. **Coupon Rules Engine:**
   - Enforces minimum order amount thresholds.
   - Tests percentage-based discount computations.
   - Tests maximum discount caps.
5. **Authentication Validation:**
   - Rejects invalid email syntax.
   - Enforces password complexity rules (uppercase, lowercase, number, minimum 8 characters).

---

## 2. Running Automated Tests

Run the backend test suite:
```bash
npm test --prefix backend
```

Output:
```text
PASS tests/ecommerce.spec.ts
  Luxe E-Commerce Backend Suite
    API Health and Core Middleware
      √ should return 200 and healthy status on /api/v1/health
      √ should return 404 for non-existent route with structured envelope
    Pricing Calculations and Rule Engine
      √ should correctly calculate line item amounts without precision drift
      √ should handle fractional quantity computations accurately
    Coupon Calculations
      √ should reject coupons below minimum order threshold
      √ should correctly apply percentage discount when conditions met
    Authentication Input Validation
      √ should reject invalid email during registration
      √ should reject weak password during registration

Test Suites: 1 passed, 1 total
Tests:       8 passed, 8 total
```

---

## 3. Frontend Build Verification

To verify Angular compilation, type safety, and template integrity:
```bash
npm run build --prefix frontend
```
Build output produces optimized, lazy-loaded bundles in `frontend/dist/frontend`.
