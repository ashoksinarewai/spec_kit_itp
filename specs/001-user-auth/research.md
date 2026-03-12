# Research: User Authentication (Login)

**Feature**: 001-user-auth  
**Date**: 2026-03-12

Consolidated decisions for implementation. All NEEDS CLARIFICATION from Technical Context are resolved via constitution and project standards.

---

## 1. Secure token and credential storage

**Decision**: Use `flutter_secure_storage` for access/refresh tokens and for "Remember Me" persistence. No plain-text credentials or tokens in shared_preferences or other insecure storage.

**Rationale**: Constitution §7 and §10 require tokens to be stored securely; §10 explicitly references flutter_secure_storage. Industry standard for mobile; uses platform Keychain/Keystore.

**Alternatives considered**: Raw shared_preferences (rejected: not secure); custom native storage (rejected: unnecessary complexity).

---

## 2. OAuth / social login (Microsoft, Google)

**Decision**: Use official provider SDKs or well-maintained OAuth packages (e.g. `google_sign_in`, Microsoft Authentication Library / MSAL or equivalent for Flutter). App obtains provider tokens and sends them to backend for validation; app stores only backend-issued tokens in secure storage.

**Rationale**: Spec and constitution §10 require official OAuth flows and storing only tokens; no provider passwords. Backend validates provider tokens and issues app session.

**Alternatives considered**: Custom OAuth flows (rejected: security and maintenance burden); storing provider tokens long-term (rejected: backend issues own tokens; only those stored).

---

## 3. State management for auth

**Decision**: Use project’s chosen state management (Riverpod or Bloc per constitution §8) for auth state. Auth state (logged-in user, token availability) is global; screen-local UI state stays in ViewModel/Bloc/Notifier for login form, forgot password, etc.

**Rationale**: Constitution requires consistent use of Riverpod or Bloc and clear separation of global vs feature-local state.

**Alternatives considered**: Provider only (rejected if project standard is Riverpod/Bloc); global variable for token (rejected: violates persistence and layer rules).

---

## 4. API layer and error handling

**Decision**: REST client (e.g. dio or http) with configurable base URL; centralized error handling that maps 4xx/5xx and network errors to user-facing messages. Login, token refresh, and forgot-password calls go through a single auth API client in data layer.

**Rationale**: Constitution §7 (REST, configurable base URL, 4xx/5xx handling). Spec requires clear feedback on invalid credentials and network unavailable.

**Alternatives considered**: Per-screen API calls (rejected: no single place for retry/refresh); ignoring network errors (rejected: spec FR-009).

---

## 5. Remember Me implementation

**Decision**: When "Remember Me" is enabled, persist refresh token (or long-lived session token per backend contract) in flutter_secure_storage. On app launch, attempt token restore and optional refresh; if valid, navigate to Dashboard; if expired/invalid, clear stored auth and show login with optional "Session expired" message.

**Rationale**: Spec assumptions: Remember Me = persist secure token; expiry/refresh align with backend. Constitution: persisted state through repositories/services, not raw key-value in UI.

**Alternatives considered**: Storing password (rejected: spec and security); no expiry handling (rejected: edge case in spec).

---

## 6. Forgot password flow

**Decision**: App calls backend forgot-password endpoint with user email; backend sends reset link or OTP per its design. App shows success or generic error (no account enumeration). If backend returns a deep link or in-app OTP step, app supports that flow as per contract.

**Rationale**: Spec FR-005 and assumptions: flow defined by backend; app supports link or OTP as documented in contracts.

**Alternatives considered**: App sending email (rejected: backend owns delivery); revealing whether email exists (rejected: spec and security).

---

All Technical Context items are resolved. Phase 1 design may proceed.
