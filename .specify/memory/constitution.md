<!--
  SYNC IMPACT REPORT
  Version change: 1.0.0 → 1.1.0
  Modified principles: Naming Conventions (Section 12) enhanced with detailed Flutter-specific rules
  Added sections: Expanded widget naming rules, Flutter file naming clarifications, variable naming best practices
  Removed sections: None
  Templates: plan-template.md ✅ (Constitution Check remains compatible), spec-template.md ✅,
    tasks-template.md ✅ (task types align with expanded principles). No path changes required.
  Follow-up TODOs: None. All Flutter naming conventions properly integrated.
-->

# InTimePro Constitution

This document is the governing guideline for all development decisions in the InTimePro project.
It MUST be followed for architecture, code, API, security, and process choices.

---

## 1. Project Vision

**InTimePro** is an Employee Productivity and Time Tracking Mobile Application. It enables company
employees to manage work tasks, track time, manage projects, submit timesheets, apply for leaves,
and receive notifications. The app extends an existing desktop system and targets company employees
as primary users.

**Vision statement**: A single, reliable mobile companion for employees to stay productive, track
time accurately, and stay in sync with company systems—anywhere.

**Out of scope for this constitution**: Backend/desktop system implementation; this constitution
governs the Flutter mobile application only.

---

## 2. Product Principles

### 2.1 User-First

All features MUST be designed for the primary user (company employees). Flows MUST be simple,
predictable, and aligned with how employees actually work (clock-in, tasks, timesheets, leave).

### 2.2 Offline-Capable Where Critical

Time tracking and task state MUST remain usable with limited or no connectivity. Critical data
(timer state, draft timesheets, pending actions) MUST be stored locally and synced when online.

### 2.3 Consistency with Desktop

The mobile app MUST align with the existing desktop system in terminology, data model, and
business rules. Divergence is allowed only when explicitly justified and documented.

### 2.4 Privacy and Transparency

"Private time" and user-controlled visibility MUST be supported as specified. Users MUST be able
to understand what data is sent to the backend and when.

---

## 3. Architecture Standards

- **Pattern**: Clean Architecture + MVVM. Presentation (UI) MUST NOT depend on data sources or
  infrastructure; use cases MUST depend only on abstractions (repositories, interfaces).
- **Layers**:
  - **Presentation**: Screens, widgets, ViewModels (MVVM). No direct API or DB access.
  - **Domain**: Entities, use cases / application services. No Flutter or platform imports.
  - **Data**: Repositories implementation, API clients, local DB (SQLite), DTOs/mappers.
- **Dependency rule**: Dependencies point inward (Presentation → Domain ← Data). Domain MUST have
  zero dependencies on Presentation or Data.
- **Framework**: Flutter. Minimum supported SDK and target platforms MUST be documented in
  README or tech spec and updated on major changes.

---

## 4. Coding Standards

- **Language**: Dart. Follow effective Dart guidelines and `dart analyze` with zero issues.
- **Imports**: Use `package:` and relative imports consistently; no unused imports.
- **Formatting**: `dart format` on the project; line length 80 or 120 (project-wide choice,
  documented).
- **Null safety**: Full null safety. No unnecessary `!`; use `?` and null-aware operators
  deliberately.
- **Immutability**: Prefer `final` and immutable data structures (e.g. records, value types) for
  domain and DTOs where practical.
- **No magic**: No magic numbers or strings in business logic; use named constants or config.

---

## 5. Folder Structure

Repository MUST follow a consistent structure. Example (adjust paths to match actual repo):

```text
lib/
├── core/                 # Shared utilities, constants, extensions, base classes
├── features/             # Feature modules
│   ├── auth/
│   ├── dashboard/
│   ├── tasks/
│   ├── projects/
│   ├── timesheet/
│   ├── leave/
│   ├── notifications/
│   └── settings/
├── shared/               # Shared UI, widgets, theme (if not under core)
└── main.dart
```

Within each feature (e.g. `lib/features/auth/`):

- **data/**: Repositories impl, API client, local storage, DTOs, mappers.
- **domain/**: Entities, use cases / application services (interfaces in domain, impl in data
  if needed).
- **presentation/**: Screens, widgets, ViewModels (or Bloc/Riverpod notifiers).

Test layout MUST mirror `lib/` (e.g. `test/features/auth/`, `test/core/`).

---

## 6. UI/UX Guidelines

- **Design system**: One shared theme (colors, typography, spacing). Dark/light mode MUST be
  supported if specified in product requirements.
- **Accessibility**: Semantic labels, sufficient contrast, and tappable target sizes per
  platform guidelines (Material/Cupertino).
- **Loading and errors**: Every async flow MUST show loading state and user-friendly error
  messages; no silent failures.
- **Navigation**: Clear back and exit; deep links and navigation state MUST be consistent
  with app structure.
- **Copy**: Use consistent terminology with the desktop system and product principles.

---

## 7. API Integration Standards

- **Protocol**: REST APIs. Base URL and environment (dev/staging/prod) MUST be configurable
  (e.g. env/flavor).
- **Contracts**: API contracts (endpoints, request/response shapes) MUST be documented (e.g.
  OpenAPI or shared markdown). Breaking changes require versioning or coordination.
- **HTTP**: Use appropriate verbs and status codes. Handle 4xx/5xx with clear error handling
  and user messaging.
- **Auth**: Tokens (e.g. Bearer) MUST be stored securely (e.g. flutter_secure_storage). Refresh
  logic MUST be centralized and must not expose tokens to UI.
- **Idempotency and retries**: For critical operations (e.g. timesheet submit), follow backend
  idempotency/retry design; document in feature specs.

---

## 8. State Management Rules

- **Choice**: Riverpod or Bloc as per project decision; use consistently across the app.
- **Scope**: Global app state (e.g. auth, theme) vs feature-local state MUST be clearly
  separated. Avoid global state for purely screen-local UI.
- **Side effects**: Async work (API, DB) MUST be triggered from ViewModels/Bloc/Notifiers, not
  from widgets. One-way data flow: UI → event → state update → UI.
- **Persistence**: Persisted state (e.g. auth token, preferences) MUST go through repositories
  or dedicated services, not raw key-value in UI layer.

---

## 9. Testing Strategy

- **Unit tests**: Domain logic (entities, use cases) and pure functions MUST have unit tests.
  Target high coverage for domain and critical business rules.
- **Widget tests**: Critical flows (e.g. login, start/stop timer, submit timesheet) MUST have
  widget tests where cost-effective.
- **Integration tests**: Key user journeys (e.g. login → dashboard → start task → submit
  timesheet) MUST be covered by integration tests; run against test backend or mocks as
  documented.
- **Test data**: Use factories or fixtures; no production data. Tests MUST be deterministic
  and isolated.
- **CI**: Tests MUST run in CI; failing tests MUST block merge unless explicitly bypassed
  with documented reason.

---

## 10. Security Principles

- **Credentials**: Passwords and tokens MUST never be logged or stored in plain text. Use
  secure storage (e.g. flutter_secure_storage) for tokens and sensitive preferences.
- **Input**: All user and API input MUST be validated and sanitized; prevent injection and
  malformed data from affecting app or backend.
- **Transport**: All API communication MUST use HTTPS. Certificate pinning MAY be used if
  required by security policy.
- **OAuth**: Google and Microsoft login MUST follow official OAuth flows and store only
  tokens as per backend contract; no custom credential handling beyond SDKs and secure storage.

---

## 11. Git Workflow

- **Branching**: Main (or master) protected; feature work on branches (e.g. `feature/`,
  `fix/`). Branch names MUST be descriptive and reference spec/ticket if applicable.
- **Commits**: Commits MUST be logical units; messages MUST be clear (e.g. "feat(auth): add
  forgot password screen").
- **Pull requests**: Changes MUST be reviewed before merge. CI (lint, tests) MUST pass.
- **Constitution**: PRs that affect architecture, new features, or security MUST be checked
  against this constitution; violations MUST be resolved before merge.

---

## 12. Naming Conventions

### 12.1 File Naming

All Dart file names MUST follow snake_case:
- Use lowercase letters only
- Separate words using underscores (_)
- Do NOT use camelCase or PascalCase in file names
- File names MUST clearly describe the purpose of the file

**Examples**: `login_screen.dart`, `user_profile.dart`, `api_service.dart`, `time_tracking_service.dart`, `auth_repository_impl.dart`

**Assets**: snake_case for all assets (e.g. `icons/clock_in.svg`, `images/user_avatar.png`)

### 12.2 Class Naming

All Dart classes MUST follow PascalCase:
- The first letter of each word MUST be capitalized
- The class name MUST clearly represent the purpose of the component
- The class name MUST logically match the file's purpose
- Use appropriate suffixes: `*Repository`, `*UseCase`, `*ViewModel`, `*Bloc`, `*State`, `*Event`

**Examples**: `LoginScreen`, `UserProfile`, `ApiService`, `AuthRepository`, `TimeTrackingUseCase`

### 12.3 Widget Naming

Widget names MUST clearly describe their functionality:
- Screen widgets MUST end with `Screen` (e.g. `LoginScreen`, `ProfileScreen`, `DashboardScreen`)
- UI components MUST use meaningful names based on their UI purpose (e.g. `UserCard`, `RatingSelector`, `TaskListItem`)
- Avoid generic names like `Widget1`, `MyWidget`, `TestComponent`

**Good examples**: `LoginScreen`, `ProfileScreen`, `UserCard`, `RatingSelector`, `TimeEntryRow`, `NavigationDrawer`

**Avoid**: Generic or unclear names that don't describe the component's purpose

### 12.4 Variable and Function Naming

All variables and functions MUST follow camelCase:
- The first word MUST start with lowercase
- Each following word MUST start with uppercase
- Variable names MUST clearly describe the stored data
- Boolean names SHOULD read as predicates (e.g. `isLoggedIn`, `hasPendingTimesheet`, `canSubmitTimesheet`)

**Examples**: `userName`, `totalItems`, `isLoggedIn`, `hasPendingTimesheet`, `submitTimesheet()`, `calculateDuration()`

### 12.5 Constants

- **Dart constants**: lowerCamelCase for internal constants (e.g. `maxRetryAttempts`, `defaultTimeout`)
- **External references**: SCREAMING_SNAKE_CASE only when matching external systems (e.g. API keys, environment variables)

### 12.6 General Naming Rules

Always ensure:
- Names are clear and meaningful
- Naming is consistent across the project
- The structure is easy to read and maintain
- Names accurately reflect the component's role and responsibility
- Avoid abbreviations unless they are well-known (e.g. `url`, `api`, `ui`)

---

## 13. Performance Rules

- **Startup**: App MUST show first meaningful screen within target time (e.g. &lt; 3s on
  mid-range devices); measure and document.
- **Lists**: Long lists MUST use lazy loading (list view builders) or pagination; avoid
  loading full datasets into memory.
- **Images**: Use appropriate resolution and caching; avoid loading full-size images when
  thumbnails suffice.
- **Background**: Heavy work (e.g. sync, large DB ops) MUST NOT block UI; use isolates or
  async effectively and indicate progress to the user.

---

## 14. Logging & Error Handling

- **Logging**: Structured logging for diagnostic use (e.g. debug/info/warning/error). MUST
  NOT log credentials, tokens, or PII in plain text. Use a single logging mechanism
  (e.g. logger package) project-wide.
- **Errors**: Exceptions MUST be caught at layer boundaries; convert to user-facing messages
  or retry where appropriate. Unhandled exceptions MUST be reported (e.g. crash reporting)
  and MUST not crash the app silently.
- **Crash reporting**: Production builds SHOULD report crashes and non-fatal errors to a
  central service (e.g. Firebase Crashlytics); respect user privacy and data policies.

---

## 15. Documentation Requirements

- **README**: MUST describe project (InTimePro), how to build, run, and test; MUST list
  main dependencies and environment requirements.
- **Specs**: Features MUST have a spec (or link to spec) describing scope, user stories,
  and acceptance criteria; link to this constitution where relevant.
- **API**: Backend API usage (endpoints, auth, errors) MUST be documented; doc location
  MUST be referenced in README or architecture doc.
- **Code**: Non-obvious logic MUST have brief comments or doc comments; public APIs (e.g.
  use cases, repositories) MUST have dartdoc where they are part of the contract.

---

## Governance

- This constitution is the single source of truth for InTimePro mobile app development.
  Conflicting practices (docs, ADRs, or code) MUST be updated to comply or explicitly
  exempted with approval and rationale.
- **Amendments**: Changes require a documented proposal (e.g. PR or ADR), review, and
  update of this file. Version and "Last Amended" MUST be updated; "Ratified" is set once
  at initial adoption.
- **Compliance**: All PRs MUST satisfy the constitution unless an exception is documented
  and accepted. New features MUST align with Project Vision and Product Principles.
- **Versioning**: MAJOR for backward-incompatible governance or principle removals; MINOR
  for new principles or material new sections; PATCH for clarifications and typos.

**Version**: 1.1.0 | **Ratified**: 2025-03-12 | **Last Amended**: 2026-03-12
