# Sync tasks and user stories from specs/001-user-auth to GitHub Issues.
# Requires: GitHub CLI (gh) installed and authenticated.
# Run from repo root: .\specs\001-user-auth\scripts\sync-tasks-to-github.ps1

$ErrorActionPreference = 'Stop'
$Repo = "ashoksinarewai/spec_kit_itp"
$FeatureLabel = "feature/001-user-auth"
$SpecRef = "Spec: [001-user-auth](specs/001-user-auth/spec.md) | Tasks: [tasks.md](specs/001-user-auth/tasks.md)"

# Ensure gh is available
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Error "GitHub CLI (gh) is not installed or not in PATH. Install from https://cli.github.com/"
    exit 1
}

$null = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Not authenticated with GitHub. Run: gh auth login"
    exit 1
}

# Create labels (ignore if already exist)
$labels = @(
    $FeatureLabel,
    "phase: setup",
    "phase: foundational",
    "phase: us1",
    "phase: us2",
    "phase: us3",
    "phase: us4",
    "phase: us5",
    "phase: polish",
    "user-story: US1",
    "user-story: US2",
    "user-story: US3",
    "user-story: US4",
    "user-story: US5",
    "priority: P1",
    "priority: P2"
)
foreach ($l in $labels) {
    gh label create $l --repo $Repo --color "1d76db" 2>$null  # ignore if already exists
}

# --- User Story issues (epics) ---
$stories = @(
    @{
        title = "[US1] Email and Password Login (P1) MVP"
        body = "As an employee, I want to log in with my email and password so that I can access the InTimePro app.`n`n**Independent Test**: Valid credentials -> Dashboard; invalid -> error; network off -> notified; password masked.`n`n$SpecRef"
        labels = @($FeatureLabel, "user-story: US1", "priority: P1")
    },
    @{
        title = "[US2] Remember Me (P2)"
        body = "As an employee, I want ""Remember Me"" so I stay logged in on this device.`n`n**Independent Test**: Remember Me on -> reopen -> Dashboard; off -> reopen -> Login; tokens stored securely.`n`n$SpecRef"
        labels = @($FeatureLabel, "user-story: US2", "priority: P2")
    },
    @{
        title = "[US3] Forgot Password (P2)"
        body = "As an employee, I want to reset my password via ""Forgot Password"" and receive reset link/OTP.`n`n**Independent Test**: Generic success/error; no account enumeration.`n`n$SpecRef"
        labels = @($FeatureLabel, "user-story: US3", "priority: P2")
    },
    @{
        title = "[US4] Social Login - Microsoft & Google (P2)"
        body = "As an employee, I want to log in with Microsoft or Google.`n`n**Independent Test**: Success -> Dashboard; cancel/fail -> login + message; only tokens stored.`n`n$SpecRef"
        labels = @($FeatureLabel, "user-story: US4", "priority: P2")
    },
    @{
        title = "[US5] Error Handling and Security (P1)"
        body = "Clear feedback when login fails; credentials and session handled securely.`n`n**Independent Test**: Error messages; password masked; tokens secure; no credentials in logs.`n`n$SpecRef"
        labels = @($FeatureLabel, "user-story: US5", "priority: P1")
    }
)

Write-Host "Creating User Story issues..."
foreach ($s in $stories) {
    $labelArgs = @(); foreach ($l in $s.labels) { $labelArgs += '--label'; $labelArgs += $l }
    gh issue create --repo $Repo --title $s.title --body $s.body @labelArgs
    Write-Host "  Created: $($s.title)"
}

# --- Task issues (T001-T041) ---
$tasks = @(
    @{ id = "T001"; phase = "phase: setup";  us = $null; title = "Create auth feature and core folder structure"; body = "Create auth feature and core folder structure per plan: lib/core/network, lib/core/storage, lib/features/auth/data, domain, presentation, test/features/auth. $SpecRef" },
    @{ id = "T002"; phase = "phase: setup";  us = $null; title = "Add auth and core dependencies to pubspec.yaml"; body = "Add flutter_secure_storage, dio (or http), Riverpod or Bloc, google_sign_in, Microsoft auth package. $SpecRef" },
    @{ id = "T003"; phase = "phase: setup";  us = $null; title = "Configure analysis_options.yaml"; body = "Configure dart analyze and dart format (line length 80 or 120). $SpecRef" },
    @{ id = "T004"; phase = "phase: foundational"; us = $null; title = "Create SecureStorage interface and impl"; body = "lib/core/storage/secure_storage.dart and secure_storage_impl.dart wrapping flutter_secure_storage. $SpecRef" },
    @{ id = "T005"; phase = "phase: foundational"; us = $null; title = "Create base API client"; body = "lib/core/network/api_client.dart with base URL, timeout, JSON, 4xx/5xx/network error mapping. $SpecRef" },
    @{ id = "T006"; phase = "phase: foundational"; us = $null; title = "Create User entity"; body = "lib/features/auth/domain/entities/user.dart (id, email, displayName, linkedProvider). $SpecRef" },
    @{ id = "T007"; phase = "phase: foundational"; us = $null; title = "Create AuthSession and Credentials"; body = "lib/features/auth/domain/entities/auth_session.dart and credentials.dart. $SpecRef" },
    @{ id = "T008"; phase = "phase: foundational"; us = $null; title = "Create AuthRepository interface"; body = "lib/features/auth/domain/repositories/auth_repository.dart with login, refreshSession, requestPasswordReset, socialLogin, logout, getCurrentSession. $SpecRef" },
    @{ id = "T009"; phase = "phase: foundational"; us = $null; title = "Create auth DTOs and mappers"; body = "lib/features/auth/data/dto/auth_dto.dart and data/mappers/auth_mapper.dart. $SpecRef" },
    @{ id = "T010"; phase = "phase: foundational"; us = $null; title = "Create AuthRemoteDataSource"; body = "lib/features/auth/data/datasources/auth_remote_datasource.dart - POST login, refresh, forgot-password, social per contracts. $SpecRef" },
    @{ id = "T011"; phase = "phase: foundational"; us = $null; title = "Create AuthLocalDataSource"; body = "lib/features/auth/data/datasources/auth_local_datasource.dart for tokens and rememberMe via SecureStorage. $SpecRef" },
    @{ id = "T012"; phase = "phase: foundational"; us = $null; title = "Implement AuthRepository"; body = "lib/features/auth/data/repositories/auth_repository_impl.dart. $SpecRef" },
    @{ id = "T013"; phase = "phase: foundational"; us = $null; title = "Create LoginUseCase"; body = "lib/features/auth/domain/usecases/login_usecase.dart - validate Credentials, call AuthRepository.login. $SpecRef" },
    @{ id = "T014"; phase = "phase: foundational"; us = $null; title = "Create app bootstrap / auth guard"; body = "lib/core/auth/auth_bootstrap.dart - getCurrentSession/refreshSession on launch; 401 clear and show login. $SpecRef" },
    @{ id = "T015"; phase = "phase: us1"; us = "user-story: US1"; title = "Create LoginViewModel or LoginBloc"; body = "lib/features/auth/presentation/login/ - state: email, password, rememberMe, loading, errorMessage; events: submit, clearError. $SpecRef" },
    @{ id = "T016"; phase = "phase: us1"; us = "user-story: US1"; title = "Implement login form UI"; body = "lib/features/auth/presentation/login/login_screen.dart - email, password (masked), Remember Me, Submit, loading, error. $SpecRef" },
    @{ id = "T017"; phase = "phase: us1"; us = "user-story: US1"; title = "Validate empty email/password in submit"; body = "Show ""Email and password are required""; do not call backend when empty. $SpecRef" },
    @{ id = "T018"; phase = "phase: us1"; us = "user-story: US1"; title = "On login success persist token and navigate"; body = "Persist refresh token and rememberMe when true; store session; navigate to Dashboard. $SpecRef" },
    @{ id = "T019"; phase = "phase: us1"; us = "user-story: US1"; title = "Map LoginUseCase errors to user messages"; body = "Invalid credentials, network error, timeout -> clear user-facing messages. $SpecRef" },
    @{ id = "T020"; phase = "phase: us1"; us = "user-story: US1"; title = "Wire app router to LoginScreen/Dashboard"; body = "Show LoginScreen when not authenticated, Dashboard when authenticated (integrate with T014). $SpecRef" },
    @{ id = "T021"; phase = "phase: us2"; us = "user-story: US2"; title = "Persist refresh token when rememberMe true"; body = "In AuthRepositoryImpl persist refresh token and rememberMe via AuthLocalDataSource on login success. $SpecRef" },
    @{ id = "T022"; phase = "phase: us2"; us = "user-story: US2"; title = "Clear stored token when rememberMe false"; body = "When rememberMe false on login, clear stored refresh token and flag so next launch shows login. $SpecRef" },
    @{ id = "T023"; phase = "phase: us2"; us = "user-story: US2"; title = "Session restore on app launch"; body = "In auth bootstrap: read rememberMe and refresh token; call refreshSession(); on 401 clear and show login with ""Session expired"". $SpecRef" },
    @{ id = "T024"; phase = "phase: us2"; us = "user-story: US2"; title = "Add remember-me test coverage (optional)"; body = "Unit or widget tests for remember-me on/off and session restore per constitution. $SpecRef" },
    @{ id = "T025"; phase = "phase: us3"; us = "user-story: US3"; title = "Create RequestPasswordResetUseCase"; body = "lib/features/auth/domain/usecases/request_password_reset_usecase.dart - call AuthRepository.requestPasswordReset(email). $SpecRef" },
    @{ id = "T026"; phase = "phase: us3"; us = "user-story: US3"; title = "Create ForgotPasswordScreen"; body = "lib/features/auth/presentation/forgot_password/forgot_password_screen.dart - email, Submit, loading, generic success/error. $SpecRef" },
    @{ id = "T027"; phase = "phase: us3"; us = "user-story: US3"; title = "Create ForgotPasswordViewModel/Bloc"; body = "Submit handler calling RequestPasswordResetUseCase; generic user message (no account enumeration). $SpecRef" },
    @{ id = "T028"; phase = "phase: us3"; us = "user-story: US3"; title = "Add Forgot Password link on LoginScreen"; body = "Link/button to ForgotPasswordScreen; back to LoginScreen. $SpecRef" },
    @{ id = "T029"; phase = "phase: us4"; us = "user-story: US4"; title = "Integrate Google Sign-In"; body = "lib/features/auth/data/datasources/social_auth_datasource.dart - google_sign_in, obtain ID token; document client IDs. $SpecRef" },
    @{ id = "T030"; phase = "phase: us4"; us = "user-story: US4"; title = "Integrate Microsoft Sign-In"; body = "social_auth_datasource.dart - Microsoft auth package, ID/access token per backend contract. $SpecRef" },
    @{ id = "T031"; phase = "phase: us4"; us = "user-story: US4"; title = "Implement socialLogin in repository"; body = "AuthRepositoryImpl socialLogin(provider, idToken) - POST auth/social; store tokens and user; return AuthSession. $SpecRef" },
    @{ id = "T032"; phase = "phase: us4"; us = "user-story: US4"; title = "Add Google/Microsoft buttons to login screen"; body = "Sign in with Google/Microsoft buttons; launch provider flow; call repository; on success navigate to Dashboard. $SpecRef" },
    @{ id = "T033"; phase = "phase: us4"; us = "user-story: US4"; title = "Handle social login cancel/failure"; body = "Remain on login; show ""Sign-in cancelled"" or ""This account is not registered..."" per contracts. $SpecRef" },
    @{ id = "T034"; phase = "phase: us4"; us = "user-story: US4"; title = "Ensure social stores only backend tokens"; body = "Verify only backend-issued tokens in secure storage; never provider passwords. $SpecRef" },
    @{ id = "T035"; phase = "phase: us5"; us = "user-story: US5"; title = "Verify empty email/password validation"; body = "Message ""Email and password are required"" before login call in login_viewmodel/login_bloc. $SpecRef" },
    @{ id = "T036"; phase = "phase: us5"; us = "user-story: US5"; title = "Verify timeout maps to user message"; body = "API client/auth layer: timeout -> ""Request timed out. Please try again."" $SpecRef" },
    @{ id = "T037"; phase = "phase: us5"; us = "user-story: US5"; title = "Verify session expiry handling"; body = "401 from refresh -> clear tokens, show login with ""Session expired. Please log in again."" $SpecRef" },
    @{ id = "T038"; phase = "phase: us5"; us = "user-story: US5"; title = "Audit auth layers for no credentials in logs"; body = "Ensure no credentials or tokens logged in lib/features/auth/data and domain; structured logger. $SpecRef" },
    @{ id = "T039"; phase = "phase: polish"; us = $null; title = "Update README/docs for auth"; body = "Auth feature summary, how to run, environment (base URL, Google/Microsoft client IDs). $SpecRef" },
    @{ id = "T040"; phase = "phase: polish"; us = $null; title = "Run quickstart.md validation"; body = "Execute checklist in specs/001-user-auth/quickstart.md and fix gaps. $SpecRef" },
    @{ id = "T041"; phase = "phase: polish"; us = $null; title = "Code cleanup"; body = "dart format and dart analyze on lib/features/auth and lib/core; remove unused imports and dead code. $SpecRef" }
)

Write-Host "Creating Task issues..."
foreach ($t in $tasks) {
    $labels = @($FeatureLabel, $t.phase)
    if ($t.us) { $labels += $t.us }
    $labelArgs = @(); foreach ($l in $labels) { $labelArgs += '--label'; $labelArgs += $l }
    $title = "[$($t.id)] $($t.title)"
    gh issue create --repo $Repo --title $title --body $t.body @labelArgs
    Write-Host "  Created: $title"
}

Write-Host "Done. User Story and Task issues created in $Repo"
