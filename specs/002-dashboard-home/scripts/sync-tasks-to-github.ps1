# Sync tasks and user stories from specs/002-dashboard-home to GitHub Issues.
# Requires: GitHub CLI (gh) installed and authenticated.
# Run from repo root: .\specs\002-dashboard-home\scripts\sync-tasks-to-github.ps1
# Optional: .\specs\002-dashboard-home\scripts\sync-tasks-to-github.ps1 -UpdateStatusFromTasks
#   Updates spec.md and tasks.md Status from completion in tasks.md; use -UpdateGitHubIssues to close completed task issues.

param(
    [switch]$UpdateStatusFromTasks,
    [switch]$UpdateGitHubIssues
)

$ErrorActionPreference = 'Stop'
$Repo = "ashoksinarewai/spec_kit_itp"
$FeatureLabel = "feature/002-dashboard-home"
$SpecRef = "Spec: [002-dashboard-home](specs/002-dashboard-home/spec.md) | Tasks: [tasks.md](specs/002-dashboard-home/tasks.md)"
$FeatureDir = Join-Path $PSScriptRoot ".."
$TasksPath = Join-Path $FeatureDir "tasks.md"
$SpecPath = Join-Path $FeatureDir "spec.md"

# Ensure gh is available (skip for status-only update)
if (-not $UpdateStatusFromTasks) {
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Error "GitHub CLI (gh) is not installed or not in PATH. Install from https://cli.github.com/"
        exit 1
    }
    $null = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Not authenticated with GitHub. Run: gh auth login"
        exit 1
    }
}

# --- Update status from tasks.md completion (optional) ---
function Update-StatusFromTasks {
    if (-not (Test-Path $TasksPath)) {
        Write-Warning "tasks.md not found at $TasksPath"
        return
    }
    $content = Get-Content $TasksPath -Raw
    $completed = ([regex]::Matches($content, '^\s*-\s+\[x\]\s+T\d+', 'Multiline')).Count
    $pending = ([regex]::Matches($content, '^\s*-\s+\[\s\]\s+T\d+', 'Multiline')).Count
    $total = $completed + $pending
    if ($total -eq 0) {
        $pct = 0
    } else {
        $pct = [math]::Round(100 * $completed / $total, 0)
    }

    if ($pct -eq 0) { $specStatus = "Draft"; $tasksStatus = "Ready for Development" }
    elseif ($pct -lt 100) { $specStatus = "In Progress"; $tasksStatus = "In Progress" }
    else { $specStatus = "Complete"; $tasksStatus = "Complete" }

    Write-Host "Task completion: $completed/$total ($pct%). Setting spec status: $specStatus, tasks status: $tasksStatus"

    if (Test-Path $SpecPath) {
        $specContent = Get-Content $SpecPath -Raw
        $specContent = $specContent -replace '(\*\*Status\*\*:\s*)[^\r\n]*', "`${1}$specStatus"
        Set-Content $SpecPath -Value $specContent -NoNewline
        Write-Host "  Updated spec.md Status -> $specStatus"
    }
    $tasksContent = Get-Content $TasksPath -Raw
    $tasksContent = $tasksContent -replace '(\*\*Status\*\*:\s*)[^\r\n]*', "`${1}$tasksStatus"
    Set-Content $TasksPath -Value $tasksContent -NoNewline
    Write-Host "  Updated tasks.md Status -> $tasksStatus"

    if ($UpdateGitHubIssues -and (Get-Command gh -ErrorAction SilentlyContinue)) {
        $issueList = gh issue list --repo $Repo --label $FeatureLabel --state all --limit 500 --json number,title,state
        $issues = $issueList | ConvertFrom-Json
        $completedIds = [regex]::Matches($content, '^\s*-\s+\[x\]\s+(T\d+)', 'Multiline') | ForEach-Object { $_.Groups[1].Value }
        foreach ($issue in $issues) {
            if ($issue.title -match '^\[(T\d+)\]\s') {
                $tid = $Matches[1]
                if ($tid -in $completedIds -and $issue.state -eq 'OPEN') {
                    gh issue close $issue.number --repo $Repo
                    Write-Host "  Closed issue #$($issue.number) $tid"
                }
            }
        }
    }
}

if ($UpdateStatusFromTasks) {
    Update-StatusFromTasks
    Write-Host "Done. Status updated from tasks.md."
    exit 0
}

# --- Create labels ---
$labels = @(
    $FeatureLabel,
    "phase: phase1",
    "phase: phase2",
    "phase: phase3",
    "phase: phase4",
    "phase: cross-cutting",
    "user-story: US1",
    "user-story: US2",
    "user-story: US3",
    "user-story: US4",
    "priority: P1",
    "priority: P2"
)
foreach ($l in $labels) {
    gh label create $l --repo $Repo --color "1d76db" --force 2>$null
}

# --- User Story issues ---
$stories = @(
    @{ title = "[US1] Home Screen Layout and Profile Summary (P1)"; body = "As an employee, I want to land on a Home/Dashboard screen after login so that I can see my profile (name, role, online status), today's time metrics, and the main structure.`n`n$SpecRef"; labels = @($FeatureLabel, "user-story: US1", "priority: P1") },
    @{ title = "[US2] Currently Active Task with Live Timer and Actions (P1)"; body = "As an employee, I want to see my currently active task with a live timer and pause/complete actions so that I can track time and control the task without leaving the Home screen.`n`n$SpecRef"; labels = @($FeatureLabel, "user-story: US2", "priority: P1") },
    @{ title = "[US3] Searchable and Filterable Task List (P2)"; body = "As an employee, I want a searchable and filterable list of my tasks by status (New, In Progress, Overdue, Complete) with per-task timers and quick actions (start/complete).`n`n$SpecRef"; labels = @($FeatureLabel, "user-story: US3", "priority: P2") },
    @{ title = "[US4] Loading, Empty, and Error States (P2)"; body = "As an employee, I want clear loading, empty, and error states on the Home screen so that I always understand what is happening and what to do next.`n`n$SpecRef"; labels = @($FeatureLabel, "user-story: US4", "priority: P2") }
)

Write-Host "Creating User Story issues..."
foreach ($s in $stories) {
    $labelArgs = @(); foreach ($l in $s.labels) { $labelArgs += '--label'; $labelArgs += $l }
    gh issue create --repo $Repo --title $s.title --body $s.body @labelArgs
    Write-Host "  Created: $($s.title)"
}

# --- Task issues T001-T060 (phase: phase1|phase2|phase3|phase4|cross-cutting, user-story where applicable) ---
$taskList = @(
    @{ id = "T001"; phase = "phase: phase1"; us = "user-story: US1"; title = "Set up Dashboard feature folder structure with data/domain/presentation layers" },
    @{ id = "T002"; phase = "phase: phase1"; us = "user-story: US1"; title = "[P] Define domain entities: EmployeeProfile, TimeMetrics, Task, ActiveTask" },
    @{ id = "T003"; phase = "phase: phase1"; us = "user-story: US1"; title = "[P] Create data models (DTOs) with JSON serialization: *Model classes" },
    @{ id = "T004"; phase = "phase: phase1"; us = "user-story: US1"; title = "[P] Create mapper: DTO to Entity conversion in DashboardMapper" },
    @{ id = "T005"; phase = "phase: phase1"; us = "user-story: US1"; title = "Define DashboardRepository interface (abstract)" },
    @{ id = "T006"; phase = "phase: phase1"; us = "user-story: US1"; title = "Implement DashboardRepositoryImpl with mock/test data initially" },
    @{ id = "T007"; phase = "phase: phase1"; us = "user-story: US1"; title = "[P] Create domain use cases: GetDashboardDataUseCase, PauseActiveTaskUseCase, CompleteActiveTaskUseCase, StartTaskUseCase" },
    @{ id = "T008"; phase = "phase: phase1"; us = "user-story: US1"; title = "[P] Create Riverpod providers for dashboard state" },
    @{ id = "T009"; phase = "phase: phase1"; us = "user-story: US1"; title = "Create DashboardViewModel using Riverpod providers" },
    @{ id = "T010"; phase = "phase: phase1"; us = "user-story: US1"; title = "Build HeaderWidget displaying user profile and online status" },
    @{ id = "T011"; phase = "phase: phase1"; us = "user-story: US1"; title = "[P] Build TimeMetricsWidget displaying clock-in, active time, total work time" },
    @{ id = "T012"; phase = "phase: phase1"; us = "user-story: US4"; title = "[P] Build LoadingStateWidget (reusable skeleton loader)" },
    @{ id = "T013"; phase = "phase: phase1"; us = "user-story: US4"; title = "[P] Build ErrorStateWidget (reusable error display with retry)" },
    @{ id = "T014"; phase = "phase: phase1"; us = "user-story: US1"; title = "Build DashboardScreen scaffold integrating header, metrics, active task area, error/loading states" },
    @{ id = "T015"; phase = "phase: phase1"; us = "user-story: US1"; title = "[P] Add unit tests for Phase 1 domain and data components" },
    @{ id = "T016"; phase = "phase: phase1"; us = "user-story: US1"; title = "Verify auth service integration and token injection in API calls" },
    @{ id = "T017"; phase = "phase: phase2"; us = "user-story: US2"; title = "Build ActiveTaskCard widget with live timer display" },
    @{ id = "T018"; phase = "phase: phase2"; us = "user-story: US2"; title = "Implement activeTaskTimerProvider (StreamProvider) emitting Duration every 1 second" },
    @{ id = "T019"; phase = "phase: phase2"; us = "user-story: US2"; title = "[P] Implement PauseActiveTaskUseCase" },
    @{ id = "T020"; phase = "phase: phase2"; us = "user-story: US2"; title = "[P] Implement CompleteActiveTaskUseCase" },
    @{ id = "T021"; phase = "phase: phase2"; us = "user-story: US2"; title = "[P] Implement StartTaskUseCase" },
    @{ id = "T022"; phase = "phase: phase2"; us = "user-story: US2"; title = "Wire pause/complete/start actions from ActiveTaskCard to repository via ViewModel" },
    @{ id = "T023"; phase = "phase: phase2"; us = "user-story: US4"; title = "Build EmptyStateWidget for No active task scenario" },
    @{ id = "T024"; phase = "phase: phase2"; us = "user-story: US2"; title = "Integrate EmptyStateWidget into ActiveTaskCard (when activeTask is null) [FR-011]" },
    @{ id = "T025"; phase = "phase: phase2"; us = "user-story: US2"; title = "Implement offline action queuing for pause/complete/start (Phase 2 foundation)" },
    @{ id = "T026"; phase = "phase: phase2"; us = "user-story: US2"; title = "Add retry logic on fetch failure with exponential backoff" },
    @{ id = "T027"; phase = "phase: phase2"; us = "user-story: US2"; title = "Test timer accuracy and lifecycle (app background, device sleep, resume)" },
    @{ id = "T028"; phase = "phase: phase2"; us = "user-story: US2"; title = "[P] Add unit tests for Phase 2 timer and action logic" },
    @{ id = "T029"; phase = "phase: phase3"; us = "user-story: US3"; title = "Build TaskListWidget container with SearchFieldWidget and TaskFilterTabs" },
    @{ id = "T030"; phase = "phase: phase3"; us = "user-story: US3"; title = "[P] Build SearchFieldWidget for task search input" },
    @{ id = "T031"; phase = "phase: phase3"; us = "user-story: US3"; title = "[P] Build TaskFilterTabs showing status counts (New, In Progress, Overdue, Complete)" },
    @{ id = "T032"; phase = "phase: phase3"; us = "user-story: US3"; title = "Build TaskItemWidget: individual task card for list" },
    @{ id = "T033"; phase = "phase: phase3"; us = "user-story: US3"; title = "Build TaskListViewWithPagination using ListView.builder for lazy loading [FR-006, FR-007, Q3]" },
    @{ id = "T034"; phase = "phase: phase3"; us = "user-story: US3"; title = "Implement SearchTasksUseCase: search tasks by query and (optional) status filter" },
    @{ id = "T035"; phase = "phase: phase3"; us = "user-story: US3"; title = "[P] Implement FilterTasksByStatusUseCase" },
    @{ id = "T036"; phase = "phase: phase3"; us = "user-story: US3"; title = "Create filteredTasksProvider: Riverpod derived provider for search + filter results" },
    @{ id = "T037"; phase = "phase: phase3"; us = "user-story: US3"; title = "Integrate TaskListWidget into DashboardScreen below ActiveTaskCard" },
    @{ id = "T038"; phase = "phase: phase3"; us = "user-story: US3"; title = "Wire start/complete actions on task list items to ViewModel" },
    @{ id = "T039"; phase = "phase: phase3"; us = "user-story: US4"; title = "Build ReusableTaskEmptyStateWidget for No tasks in list" },
    @{ id = "T040"; phase = "phase: phase3"; us = "user-story: US3"; title = "Integrate ReusableTaskEmptyStateWidget into task list (when filtered list is empty) [FR-012]" },
    @{ id = "T041"; phase = "phase: phase3"; us = "user-story: US3"; title = "Test performance with large task lists (lazy loading, ListView rendering)" },
    @{ id = "T042"; phase = "phase: phase3"; us = "user-story: US3"; title = "[P] Add unit and widget tests for Phase 3 search/filter logic and list widgets" },
    @{ id = "T043"; phase = "phase: phase4"; us = "user-story: US4"; title = "[P] Refine loading skeletons with shimmer/pulse animations" },
    @{ id = "T044"; phase = "phase: phase4"; us = "user-story: US4"; title = "[P] Add state transitions and animations (card layouts, state changes)" },
    @{ id = "T045"; phase = "phase: phase4"; us = "user-story: US2"; title = "Complete offline caching (SQLite) implementation for task list and time metrics" },
    @{ id = "T046"; phase = "phase: phase4"; us = "user-story: US4"; title = "Improve error handling and user-facing error messages [FR-013]" },
    @{ id = "T047"; phase = "phase: phase4"; us = "user-story: US4"; title = "Test session expiry scenario: 401 response redirect to login [FR-015]" },
    @{ id = "T048"; phase = "phase: phase4"; us = "user-story: US4"; title = "[P] Test offline mode: no internet, queued actions, sync feedback" },
    @{ id = "T049"; phase = "phase: phase4"; us = "user-story: US1"; title = "Verify bottom navigation integration: Home tab selected, navigation to Activities/Projects/Notifications works" },
    @{ id = "T050"; phase = "phase: phase4"; us = $null; title = "Performance optimization: profile dashboard load time, optimize rebuilds" },
    @{ id = "T051"; phase = "phase: phase4"; us = $null; title = "[P] Add comprehensive unit tests: repository, use cases, mappers (80%+ coverage)" },
    @{ id = "T052"; phase = "phase: phase4"; us = $null; title = "[P] Add widget tests: key screens and widgets - DashboardScreen, ActiveTaskCard, TaskListWidget" },
    @{ id = "T053"; phase = "phase: phase4"; us = $null; title = "[P] Add integration tests: critical user journeys (login to Dashboard to interact to offline)" },
    @{ id = "T054"; phase = "phase: phase4"; us = $null; title = "Write comprehensive documentation for dashboard feature" },
    @{ id = "T055"; phase = "phase: phase4"; us = $null; title = "Code review and cleanup: ensure constitution compliance, naming conventions, no dead code" },
    @{ id = "T056"; phase = "phase: phase4"; us = $null; title = "Final integration with app routing, dependency injection (Riverpod), and app-level setup" },
    @{ id = "T057"; phase = "phase: phase4"; us = $null; title = "Release preparation: tag features, create release notes, final QA checklist" },
    @{ id = "T058"; phase = "phase: cross-cutting"; us = $null; title = "Setup CI/CD pipeline: ensure all tests run, lint checks pass, coverage reports generated" },
    @{ id = "T059"; phase = "phase: cross-cutting"; us = $null; title = "Create dashboard mockups/design reference (if not already done)" },
    @{ id = "T060"; phase = "phase: cross-cutting"; us = $null; title = "Create API integration task for backend team (if separate)" }
)

Write-Host "Creating Task issues..."
foreach ($t in $taskList) {
    $labels = @($FeatureLabel, $t.phase)
    if ($t.us) { $labels += $t.us }
    $labelArgs = @(); foreach ($l in $labels) { $labelArgs += '--label'; $labelArgs += $l }
    $title = "[$($t.id)] $($t.title)"
    $body = "See tasks.md for acceptance criteria and details. $SpecRef"
    gh issue create --repo $Repo --title $title --body $body @labelArgs
    Write-Host "  Created: $title"
}

Write-Host "Done. User Story and Task issues created in $Repo."
Write-Host "To update spec/tasks status from completion, run: .\specs\002-dashboard-home\scripts\sync-tasks-to-github.ps1 -UpdateStatusFromTasks"
Write-Host "To also close GitHub issues for completed tasks, add: -UpdateGitHubIssues"
