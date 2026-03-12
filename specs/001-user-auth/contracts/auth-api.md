# Auth API Contracts

**Feature**: 001-user-auth  
**Date**: 2026-03-12

Backend REST contracts assumed by the InTimePro mobile app for login, token refresh, forgot password, and social login. Base URL and environment (dev/staging/prod) are configurable per constitution §7. All traffic MUST use HTTPS.

---

## 1. Login (email / password)

**Endpoint**: `POST /auth/login` (or as defined by backend)

**Request**:

```json
{
  "email": "string (required)",
  "password": "string (required)"
}
```

**Success (200 or 201)**:

```json
{
  "accessToken": "string",
  "refreshToken": "string (optional; required when client will persist for Remember Me)",
  "expiresIn": "number (optional; seconds until access token expiry)",
  "user": {
    "id": "string",
    "email": "string",
    "displayName": "string (optional)"
  }
}
```

**Errors**:

- 401: Invalid email or password (generic message; no indication of whether email exists).
- 4xx/5xx: Handled with clear user-facing message; no silent failure (spec FR-008, FR-009).
- Network unavailable: App does not call backend; shows "Network unavailable" or similar (FR-009).

---

## 2. Token refresh

**Endpoint**: `POST /auth/refresh` (or as defined by backend)

Used when "Remember Me" is enabled and stored refresh token is used to obtain a new access token (e.g. on app launch or when access token expires).

**Request**:

```json
{
  "refreshToken": "string"
}
```

**Success (200)**:

```json
{
  "accessToken": "string",
  "refreshToken": "string (optional; rotated refresh token if backend supports)",
  "expiresIn": "number (optional)",
  "user": { "id": "string", "email": "string", "displayName": "string (optional)" }
}
```

**Errors**:

- 401: Refresh token expired or invalid; app clears stored tokens and shows login (e.g. "Session expired. Please log in again.").

---

## 3. Forgot password

**Endpoint**: `POST /auth/forgot-password` (or as defined by backend)

**Request**:

```json
{
  "email": "string (required)"
}
```

**Success (200 or 202)**:

- Generic success message; backend sends reset link or OTP per its design. Response body may be empty or contain a generic message (e.g. "If an account exists, you will receive instructions.").

**Errors**:

- Same response for registered and unregistered email (no account enumeration). 4xx/5xx mapped to generic user message.

---

## 4. Social login (Microsoft / Google)

**Flow**: App uses provider SDK to obtain provider token (e.g. ID token or access token). App sends that token to backend; backend validates with provider and returns app session.

**Endpoint**: `POST /auth/social` or `POST /auth/google`, `POST /auth/microsoft` (as defined by backend)

**Request** (example for single endpoint):

```json
{
  "provider": "google | microsoft",
  "idToken": "string (or accessToken per backend contract)"
}
```

**Success (200 or 201)**:

- Same shape as Login success: accessToken, optional refreshToken, user (id, email, displayName).

**Errors**:

- 401 / 403: Invalid or unrecognized provider token.
- 404 or 4xx: Account not registered with backend; app shows e.g. "This account is not registered. Please use your work email or contact support." and remains on login screen.

---

## 5. General

- **Auth header**: `Authorization: Bearer <accessToken>` for authenticated requests.
- **Content-Type**: `application/json` for request/response.
- **Timeouts**: App shows loading then success or clear error (e.g. "Request timed out. Please try again."); no silent hang (spec edge case).
- **Contracts**: Breaking changes require versioning or coordination (constitution §7).
