# Data Model: User Authentication (Login)

**Feature**: 001-user-auth  
**Date**: 2026-03-12

Entities and value types for the auth feature. Domain entities live in domain layer; DTOs and persistence shapes in data layer. Validation rules align with spec (FR-001–FR-011) and edge cases.

---

## 1. User (Employee)

Represents the authenticated employee. Used after successful login and for session identity.

| Field | Type | Validation / Notes |
|-------|------|---------------------|
| id | String | Required; backend identifier |
| email | String | Required; valid email format; may be used for display |
| displayName | String? | Optional; from backend or social provider |
| linkedProvider | String? | Optional; e.g. "google", "microsoft" when logged in via social |

**Relationships**: One User per active session. User is the principal for post-login flows (e.g. Dashboard).

**State**: No state machine for User in auth scope; session state is represented by AuthSession.

---

## 2. Credentials (value type)

Email and password for email/password login. Not persisted; used only for login request.

| Field | Type | Validation / Notes |
|-------|------|---------------------|
| email | String | Required, non-empty; validated before API call (spec edge case: no backend call with empty fields) |
| password | String | Required, non-empty; masked in UI (FR-010) |

**Validation rules**: Client-side validate "Email and password are required" when empty; do not send request with empty email or password.

---

## 3. AuthSession / Auth token

Represents authenticated state. Backend may return access token and optionally refresh token; "Remember Me" persists refresh (or long-lived token) in secure storage.

| Field | Type | Validation / Notes |
|-------|------|---------------------|
| accessToken | String | Required; Bearer token for API calls |
| refreshToken | String? | Optional; present when Remember Me or backend supports refresh |
| expiresAt | DateTime? | Optional; if backend provides expiry; used to detect expired session |
| user | User | Required; minimal user info from login/social response |

**Persistence**: When "Remember Me" is enabled, refresh token (or long-lived token per backend) stored via secure storage abstraction; no plain-text in logs or insecure storage (FR-011).

**State transitions**: Valid → Expired (on expiry or 401); Expired → cleared locally and user shown login screen (spec edge case).

---

## 4. Password reset request (value type)

Represents a forgot-password request. Not persisted in app; only used for API call and UI feedback.

| Field | Type | Validation / Notes |
|-------|------|---------------------|
| email | String | Required, non-empty; valid email format |

**Backend behavior**: Backend sends reset link or OTP; app shows generic success or error (no account enumeration per spec).

---

## 5. Remember Me preference

Simple flag; may be stored with secure token or in secure storage so it is clear whether to restore session on launch.

| Field | Type | Notes |
|-------|------|--------|
| rememberMe | bool | true when user checked "Remember Me" at login |

---

## Layer mapping

- **Domain**: User, AuthSession (or equivalent value types); Credentials and PasswordResetRequest as value types or parameters.
- **Data**: DTOs for login request/response, token refresh request/response, forgot-password request/response, social token exchange; mappers DTO ↔ domain; secure storage keys and serialization for tokens only.

All sensitive fields (tokens, passwords) must never be logged or stored in plain text (constitution §10, §14).
