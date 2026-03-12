# Implementation Plan: User Authentication (Login)

**Branch**: `001-user-auth` | **Date**: 2026-03-12 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-user-auth/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Implement login for the InTimePro Flutter mobile app: email/password login with validation and redirect to Dashboard; Remember Me via secure token persistence; Forgot Password (reset link or OTP per backend); Microsoft and Google social login; and consistent error handling and security (masked password, secure token storage). Technical approach follows constitution: Clean Architecture + MVVM, Flutter/Dart, REST to existing backend, flutter_secure_storage for tokens, OAuth SDKs for social login.

## Technical Context

**Language/Version**: Dart 3.x (null safety), Flutter SDK per project README  
**Primary Dependencies**: Flutter framework, Riverpod or Bloc (per project choice), flutter_secure_storage, http/dio for REST, OAuth packages for Microsoft/Google sign-in  
**Storage**: Local: flutter_secure_storage for tokens and sensitive prefs; no local DB required for auth-only feature  
**Testing**: flutter test (unit, widget, integration); test backend or mocks for integration  
**Target Platform**: iOS and Android (mobile); minimum versions documented in README  
**Project Type**: mobile-app (Flutter)  
**Performance Goals**: Login to Dashboard &lt; 2s under normal network (per SC-001); first meaningful screen &lt; 3s (constitution)  
**Constraints**: HTTPS only; no plain-text credentials or tokens in storage or logs; offline: show clear message on login attempt, no silent fail  
**Scale/Scope**: Company employees; auth screens (login, forgot password, optional social redirect); single post-login destination (Dashboard)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|--------|
| §3 Clean Architecture + MVVM | PASS | Auth feature in lib/features/auth/ with data/domain/presentation |
| §3 Dependency rule (inward) | PASS | Presentation → Domain ← Data; no Flutter in domain |
| §4 Dart, null safety, formatting | PASS | dart analyze, dart format |
| §5 Folder structure (lib/core, lib/features/auth) | PASS | Plan uses lib/features/auth with data/domain/presentation |
| §6 Design system, loading/errors | PASS | Loading and error states required by spec |
| §7 REST, configurable base URL, contracts | PASS | Contracts in specs/001-user-auth/contracts/ |
| §7 Auth: secure storage, refresh centralized | PASS | flutter_secure_storage; token handling in data layer |
| §8 State management (Riverpod/Bloc) | PASS | Use project choice consistently |
| §9 Unit/widget/integration tests | PASS | Critical flows (login) covered per constitution |
| §10 Credentials/tokens not logged; secure storage | PASS | Spec FR-010, FR-011; constitution §10 |
| §10 OAuth: official flows, store only tokens | PASS | Spec US4; no provider passwords stored |
| §12 Naming (snake_case files, PascalCase classes) | PASS | login_screen.dart, LoginScreen, etc. |

No violations. Phase 0 and Phase 1 may proceed.

## Project Structure

### Documentation (this feature)

```text
specs/001-user-auth/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── login-ui-design.md   # Login screen UI design (layout, colours, components)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── core/                     # Shared utilities, constants, extensions, base classes
│   ├── network/              # API client, base URL, error handling
│   └── storage/              # Secure storage abstraction (wraps flutter_secure_storage)
├── features/
│   ├── auth/
│   │   ├── data/             # AuthRepository impl, API client, DTOs, mappers, secure token storage
│   │   ├── domain/           # Entities, use cases (Login, RememberMe, ForgotPassword, SocialLogin)
│   │   └── presentation/     # LoginScreen, ForgotPasswordScreen, ViewModels/Bloc
│   └── dashboard/            # Post-login (out of scope for this spec; only navigation target)
├── shared/                   # Shared UI, theme
└── main.dart

test/
├── core/
├── features/
│   └── auth/
│       ├── data/
│       ├── domain/
│       └── presentation/
```

**Structure Decision**: Single Flutter project with feature-based layout under lib/ per constitution §5. Auth is isolated under lib/features/auth/ with data/domain/presentation. Backend is external (REST); no api/ folder in repo. Test layout mirrors lib/.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations. Table left empty.
