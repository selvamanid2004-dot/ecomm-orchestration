# Logging Architecture & Centralized Error Handling

## 1. Structured Logging System

The backend implements structured JSON logging powered by **Winston** (`backend/src/logging/logger.ts`).

### Log Levels
- `error`: Uncaught exceptions, database query failures, internal server faults (500).
- `warn`: Client validation failures (422), authentication rejections (401), missing resources (404).
- `info`: Server startup, database connection pools, HTTP request completions with response time and status code.
- `debug`: Fine-grained development debug messages.

### Transports & Retention
- **Console Transport:** Formatted with colorized timestamps for local developer convenience.
- **File Transports:**
  - `logs/error.log`: Retains `error` events (max size: 10MB, max files: 5).
  - `logs/combined.log`: Retains all events (max size: 20MB, max files: 5).

---

## 2. Request Correlation IDs

Every inbound HTTP request receives a unique UUIDv4 correlation identifier injected by `requestLogger` (`backend/src/middleware/request-logger.middleware.ts`):
- Added to Express request object: `req.correlationId`.
- Returned to client in response header: `X-Correlation-ID`.
- Embedded into every structured log entry.

Example log output:
```json
{
  "service": "luxe-ecommerce-api",
  "level": "info",
  "message": "HTTP Request processed",
  "correlationId": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
  "method": "POST",
  "path": "/api/v1/orders/checkout",
  "statusCode": 201,
  "durationMs": 34,
  "ip": "::1",
  "timestamp": "2026-10-12 11:30:00"
}
```

---

## 3. Sensitive Data Redaction

To prevent sensitive customer credentials and payment tokens from leaking into server logs, the logger automatically intercepts and replaces the following keys with `[REDACTED]`:
- `password`, `passwordHash`
- `token`, `jwt`, `secret`
- `creditCard`, `cvv`
- `authorization` header

---

## 4. Centralized Error Handling

All uncaught route errors converge at `errorHandler` (`backend/src/middleware/error.middleware.ts`).

### Application Error Hierarchy
- `AppError`: Base operational error class with `statusCode` and `code`.
- `NotFoundError` (404): Resource not found.
- `ValidationError` (422): Zod input validation failure with detailed field issues.
- `UnauthorizedError` (401): Missing or expired JWT.
- `ForbiddenError` (403): Insufficient role permissions.
- `ConflictError` (409): Duplicate SKU, duplicate user email.
- `BadRequestError` (400): Business rule violation (e.g. insufficient inventory).

### Production Privacy Shield
In `production` mode, internal stack traces and database implementation details are concealed from HTTP responses:
```json
{
  "success": false,
  "message": "An unexpected error occurred",
  "code": "INTERNAL_SERVER_ERROR",
  "correlationId": "8b1a8d05-b0b3-4f9e-9943-4e8c16053f3e"
}
```
The client can provide the `correlationId` to the support engineering team, who can locate the exact stack trace in `logs/error.log`.
