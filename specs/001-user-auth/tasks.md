# Tasks: User Authentication (Login)

**Input**: Design documents from `/specs/001-user-auth/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Not explicitly requested in the feature specification; no test tasks included. Add per constitution §9 when implementing.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter (this feature)**: `lib/`, `test/` at repository root; `lib/core/`, `lib/features/auth/` per plan.md

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and auth feature structure

- [x] T001 Create auth feature and core folder structure per plan: lib/core/network, lib/core/storage, lib/features/auth/data, lib/features/auth/domain, lib/features/auth/presentation, test/features/auth
- [x] T002 Add auth and core dependencies to pubspec.yaml: flutter_secure_storage, dio (or http), Riverpod or Bloc (per project choice), google_sign_in, Microsoft auth package (e.g. msal_flutter or equivalent)
- [x] T003 [P] Configure analysis_options.yaml for dart analyze and dart format (line length 80 or 120 per constitution)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure and auth data/domain layer that MUST be complete before ANY user story

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Create SecureStorage interface in lib/core/storage/secure_storage.dart and implementation wrapping flutter_secure_storage in lib/core/storage/secure_storage_impl.dart
- [x] T005 [P] Create base API client in lib/core/network/api_client.dart with configurable base URL, timeout, JSON encoding/decoding, and 4xx/5xx/network error mapping to user-facing messages
- [x] T006 [P] Create User entity in lib/features/auth/domain/entities/user.dart (id, email, displayName, linkedProvider per data-model.md)
- [x] T007 [P] Create AuthSession and Credentials value types in lib/features/auth/domain/entities/auth_session.dart and lib/features/auth/domain/entities/credentials.dart
- [x] T008 Create AuthRepository interface in lib/features/auth/domain/repositories/auth_repository.dart with methods: login(Credentials), refreshSession(), requestPasswordReset(email), socialLogin(provider, idToken), logout(), getCurrentSession()
- [x] T009 [P] Create login, refresh, forgot-password, and social response DTOs in lib/features/auth/data/dto/auth_dto.dart and mappers in lib/features/auth/data/mappers/auth_mapper.dart (DTO to User/AuthSession)
- [x] T010 Create AuthRemoteDataSource in lib/features/auth/data/datasources/auth_remote_datasource.dart implementing POST login, POST refresh, POST forgot-password, POST social per contracts/auth-api.md
- [x] T011 Create AuthLocalDataSource in lib/features/auth/data/datasources/auth_local_datasource.dart for reading/writing tokens and rememberMe flag via SecureStorage (no plain-text; keys in constants)
- [x] T012 Implement AuthRepository in lib/features/auth/data/repositories/auth_repository_impl.dart using AuthRemoteDataSource and AuthLocalDataSource; implement login, refreshSession, requestPasswordReset, socialLogin, logout, getCurrentSession
- [x] T013 Create LoginUseCase in lib/features/auth/domain/usecases/login_usecase.dart that validates Credentials (non-empty email/password), calls AuthRepository.login, returns AuthSession or domain error (invalid credentials, network error)
- [x] T014 Create app bootstrap / auth guard logic in lib/core/auth/auth_bootstrap.dart (or main/auth flow): on launch call getCurrentSession/refreshSession; if valid session navigate to Dashboard, else show LoginScreen; handle 401 by clearing storage and showing login with optional "Session expired" message

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Email and Password Login (Priority: P1) 🎯 MVP

**Goal**: User can log in with email and password; credentials validated; on success redirect to Dashboard; password masked; errors and network failure handled.

**Independent Test**: Enter valid credentials → redirect to Dashboard; invalid credentials → error, no access; network off → user notified, no access; password field masked.

- [ ] T015 [US1] Create LoginViewModel or LoginBloc in lib/features/auth/presentation/login/login_viewmodel.dart (or login_bloc.dart) with state: email, password, rememberMe, loading, errorMessage; events: submit, clearError
- [ ] T016 [US1] Implement login form UI in lib/features/auth/presentation/login/login_screen.dart: email and password fields (password obscured/masked), Remember Me checkbox, Submit button, loading indicator, error message display; wire to ViewModel/Bloc
- [ ] T017 [US1] In LoginViewModel/Bloc submit handler: validate email and password non-empty; if empty show "Email and password are required" and do not call backend; otherwise call LoginUseCase with rememberMe flag
- [ ] T018 [US1] On login success in presentation layer: persist refresh token and rememberMe via repository when rememberMe true; store session in app state; navigate to Dashboard
- [ ] T019 [US1] Map LoginUseCase errors to user messages in presentation: invalid credentials → generic "Invalid email or password"; network error → "Network unavailable" or "Please check your connection"; timeout → "Request timed out. Please try again."
- [ ] T020 [US1] Ensure main/app router shows LoginScreen when not authenticated and Dashboard when authenticated (integrate with T014 auth bootstrap)

**Checkpoint**: User Story 1 (email/password login) is fully functional and testable independently

---

## Phase 4: User Story 2 - Remember Me (Priority: P2)

**Goal**: When "Remember Me" is enabled, user stays logged in across app restarts; when disabled, login screen on next launch; tokens stored securely.

**Independent Test**: Login with Remember Me → close and reopen app → Dashboard; login without Remember Me → close and reopen → Login screen; tokens in secure storage only.

- [ ] T021 [US2] In AuthRepositoryImpl (or login flow): when login succeeds and rememberMe is true, persist refresh token (and rememberMe flag) via AuthLocalDataSource in lib/features/auth/data/repositories/auth_repository_impl.dart
- [ ] T022 [US2] In AuthRepositoryImpl: when rememberMe is false on login, clear any stored refresh token and rememberMe flag after successful login so next launch shows login
- [ ] T023 [US2] In auth bootstrap (lib/core/auth/auth_bootstrap.dart or equivalent): on app launch read rememberMe and refresh token from AuthLocalDataSource; if present call refreshSession(); if success navigate to Dashboard, if 401 clear storage and show LoginScreen with optional "Session expired. Please log in again."
- [ ] T024 [US2] Add unit or widget test coverage for remember-me on/off and session restore (optional; add if project requires per constitution §9)

**Checkpoint**: User Stories 1 and 2 work independently; Remember Me and session restore verified

---

## Phase 5: User Story 3 - Forgot Password (Priority: P2)

**Goal**: User can request password reset from login screen; enter email; receive generic success or error (no account enumeration); backend sends link or OTP per contract.

**Independent Test**: Forgot Password → enter registered email → success message; invalid/unregistered email → generic response; no different message revealing account existence.

- [ ] T025 [US3] Create RequestPasswordResetUseCase in lib/features/auth/domain/usecases/request_password_reset_usecase.dart that calls AuthRepository.requestPasswordReset(email) and returns success or generic error
- [ ] T026 [US3] Create ForgotPasswordScreen in lib/features/auth/presentation/forgot_password/forgot_password_screen.dart with email field, Submit button, loading state, and generic success/error message (no account enumeration)
- [ ] T027 [US3] Create ForgotPasswordViewModel or ForgotPasswordBloc in lib/features/auth/presentation/forgot_password/forgot_password_viewmodel.dart with submit handler calling RequestPasswordResetUseCase and mapping result to generic user message
- [ ] T028 [US3] Add "Forgot Password" link or button on LoginScreen in lib/features/auth/presentation/login/login_screen.dart navigating to ForgotPasswordScreen; back navigation to LoginScreen

**Checkpoint**: User Story 3 (Forgot Password) is complete and independently testable

---

## Phase 6: User Story 4 - Social Login (Microsoft and Google) (Priority: P2)

**Goal**: User can sign in with Microsoft or Google; provider flow; on success authenticated and redirected to Dashboard; cancel/failure leaves user on login with message; only tokens stored securely.

**Independent Test**: Sign in with Microsoft/Google → success → Dashboard; cancel/fail → login screen + message; no provider passwords stored.

- [ ] T029 [P] [US4] Integrate Google Sign-In: add google_sign_in usage in lib/features/auth/data/datasources/social_auth_datasource.dart (or within auth data layer) to obtain ID token; document configuration (e.g. client IDs in env)
- [ ] T030 [P] [US4] Integrate Microsoft Sign-In: add Microsoft auth package usage in lib/features/auth/data/datasources/social_auth_datasource.dart to obtain ID/access token per backend contract
- [ ] T031 [US4] In AuthRepositoryImpl (or dedicated use case): implement socialLogin(provider, idToken) calling backend POST auth/social (or /auth/google, /auth/microsoft); on success store tokens and user; return AuthSession
- [ ] T032 [US4] Add "Sign in with Google" and "Sign in with Microsoft" buttons to lib/features/auth/presentation/login/login_screen.dart; on tap launch provider flow, then call repository socialLogin with token; on success navigate to Dashboard
- [ ] T033 [US4] Handle social login cancel or failure in presentation: remain on login screen; show "Sign-in cancelled" or "This account is not registered. Please use your work email or contact support." when backend returns account-not-registered (per contracts)
- [ ] T034 [US4] Ensure social login stores only backend-issued tokens in secure storage via AuthLocalDataSource; never store provider passwords (verify in lib/features/auth/data/repositories/auth_repository_impl.dart)

**Checkpoint**: User Story 4 (Social Login) is complete; all login paths use secure token storage

---

## Phase 7: User Story 5 - Error Handling and Security (Priority: P1)

**Goal**: Cross-cutting: clear error messages, no credentials in logs, session expiry handling, timeout and empty-field validation already placed; verify and complete any gaps.

**Independent Test**: Invalid credentials and network-off show messages; password masked; tokens secure; empty fields validated; timeout and session-expired messages shown.

- [ ] T035 [US5] Verify and add if missing: empty email/password validation before any login call with message "Email and password are required" in lib/features/auth/presentation/login/login_viewmodel.dart (or login_bloc.dart)
- [ ] T036 [US5] Verify API client and auth layer map timeout to user message "Request timed out. Please try again." in lib/core/network/api_client.dart or lib/features/auth/data/datasources/auth_remote_datasource.dart
- [ ] T037 [US5] Verify session expiry: on 401 from refresh clear stored tokens and show login with "Session expired. Please log in again." in lib/core/auth/auth_bootstrap.dart (or equivalent)
- [ ] T038 [US5] Audit auth data and domain layers: ensure no credentials or tokens are logged (constitution §10, §14); use structured logger without sensitive fields in lib/features/auth/data/ and domain/

**Checkpoint**: Error handling and security requirements for auth are satisfied across all stories

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Documentation, validation, and cleanup

- [ ] T039 [P] Update README or docs with auth feature summary, how to run, and environment (base URL, Google/Microsoft client IDs) in project root README or docs/
- [ ] T040 Run quickstart.md validation: execute checklist in specs/001-user-auth/quickstart.md and fix any gaps
- [ ] T041 Code cleanup: run dart format and dart analyze on lib/features/auth and lib/core; fix any issues; remove unused imports and dead code

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup - BLOCKS all user stories
- **User Stories (Phases 3–7)**: All depend on Foundational completion; US2 depends on US1 login flow; US3/US4 can proceed after Foundational; US5 verifies all stories
- **Polish (Phase 8)**: Depends on completion of desired user stories

### User Story Dependencies

- **US1 (P1)**: After Foundational only - no dependency on other stories
- **US2 (P2)**: After Foundational; builds on US1 login (Remember Me checkbox and token persistence)
- **US3 (P2)**: After Foundational; independent (Forgot Password screen and use case)
- **US4 (P2)**: After Foundational; independent (social buttons and backend exchange)
- **US5 (P1)**: After US1–US4; verification and gap-filling across auth

### Within Each User Story

- Domain/use case before presentation where applicable
- Repository/datasources before use cases
- Story complete before moving to next

### Parallel Opportunities

- T003 [P] (Setup) can run in parallel with T001–T002
- T005, T006, T007, T009 [P] (Foundational) can run in parallel after T004
- T029 and T030 [P] (US4 Google vs Microsoft) can run in parallel
- T039 [P] (docs) can run in parallel with other Polish tasks

---

## Parallel Example: User Story 1

```text
# After Foundational complete, US1 tasks run in sequence per dependencies:
# T015 ViewModel/Bloc → T016 LoginScreen UI → T017–T020 validation, success, errors, routing
```

---

## Parallel Example: Foundational

```text
# After T001–T003 Setup:
# T005 (api_client.dart), T006 (user.dart), T007 (auth_session, credentials), T009 (DTOs, mappers) can run in parallel.
# Then T004, T008, T010, T011, T012, T013, T014 in order (or T004 then T005–T009 then rest).
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL)
3. Complete Phase 3: User Story 1 (Email/Password Login)
4. **STOP and VALIDATE**: Run quickstart checklist for US1
5. Deploy/demo if ready

### Incremental Delivery

1. Setup + Foundational → foundation ready
2. Add US1 → validate → Deploy (MVP)
3. Add US2 (Remember Me) → validate → Deploy
4. Add US3 (Forgot Password) → validate → Deploy
5. Add US4 (Social Login) → validate → Deploy
6. Complete US5 (error/security audit) and Polish

### Parallel Team Strategy

1. Team completes Setup + Foundational together
2. Developer A: US1 then US5; Developer B: US2; Developer C: US3; Developer D: US4
3. Merge and run US5 + Polish

---

## Notes

- [P] = parallelizable (different files, no blocking dependencies)
- [USn] = task belongs to User Story n for traceability
- All tasks use exact file paths under lib/ or test/ per plan.md
- No test tasks included; add unit/widget/integration tests per constitution §9 when implementing
- Commit after each task or logical group; validate at each checkpoint
