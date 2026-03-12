# Quickstart: User Authentication (Login)

**Feature**: 001-user-auth  
**Date**: 2026-03-12

Steps to run the app and validate the auth feature after implementation. Assumes Flutter SDK and environment are configured per project README.

---

## Prerequisites

- Flutter SDK installed; `flutter doctor` passing for target platforms (iOS/Android).
- Backend auth endpoints available (or mock/stub) per [contracts/auth-api.md](./contracts/auth-api.md).
- Environment/config: base API URL and any keys for Google/Microsoft sign-in set (e.g. env or flavor).

---

## Run the app

```bash
# From repository root
flutter pub get
flutter run
```

Use `flutter run -d <device_id>` to choose a device or simulator. Ensure backend (or mock) is reachable at the configured base URL.

---

## Validation checklist

Use this to verify auth behavior matches spec and acceptance scenarios.

### User Story 1 – Email and password login (P1)

1. Open app → login screen is shown.
2. Enter valid email and password → submit → loading state → redirect to Dashboard (within ~2s under normal network).
3. Enter invalid email or password → submit → error message (e.g. invalid email or password), no access.
4. Turn off network → submit login → user notified (e.g. "Network unavailable" or "Please check your connection"), no access.
5. Password field: input is masked (not visible in plain text).

### User Story 2 – Remember Me (P2)

1. Enable "Remember Me" → log in successfully → close app fully → reopen → user is authenticated and taken to Dashboard (no login screen).
2. Log in without "Remember Me" → close app → reopen → login screen is shown.
3. (Optional) Confirm tokens are stored via secure storage (no plain-text credentials).

### User Story 3 – Forgot password (P2)

1. On login screen → choose "Forgot Password" → enter registered email → submit → success or generic message; no reset sent to invalid email with different message that reveals account existence.
2. If backend supports full flow: complete reset (link or OTP) → set new password → log in with new credentials.

### User Story 4 – Social login (P2)

1. "Sign in with Microsoft" → complete provider flow → on success, authenticated and redirected to Dashboard.
2. "Sign in with Google" → complete provider flow → on success, authenticated and redirected to Dashboard.
3. Cancel or fail social login → return to app → remain on login screen with appropriate message if applicable.
4. No provider passwords stored; only tokens in secure storage.

### User Story 5 – Error handling and security (P1)

1. Invalid credentials → clear error message, no access (covered in US1).
2. Network unavailable → explicit notification, no access (covered in US1).
3. Password masking and secure token storage (covered in US1/US2/US4).
4. Empty email or password → client validation message ("Email and password are required"); no backend call with empty fields.
5. Backend slow/timeout → loading state then success or clear error (e.g. "Request timed out. Please try again.").
6. Remember Me with expired token → app clears auth state, shows login, optional "Session expired. Please log in again."
7. Social login with account not recognized by backend → clear message, remain on login screen.

---

## Tests

```bash
flutter test
```

Run unit, widget, and integration tests. Key flows (login, remember me, error handling) should be covered per constitution §9 and spec.

---

## Notes

- Dashboard content is out of scope for this feature; only navigation to Dashboard after login is required.
- Backend contract details (exact paths, field names) may differ; align with [contracts/auth-api.md](./contracts/auth-api.md) and backend documentation.
