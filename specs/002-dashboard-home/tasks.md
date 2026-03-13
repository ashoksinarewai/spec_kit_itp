# Development Tasks: Dashboard (Home) Module

**Feature**: Dashboard (Home) Module  
**Branch**: `002-dashboard-home`  
**Created**: 2026-03-13  
**Last Updated**: 2026-03-13  
**Status**: Ready for Development
**Target Sprint**: 4 weeks (Phase 1-4)

---

## Overview

This document breaks down the Dashboard feature into development-ready tasks organized by phase and user story. Each task is:
- **Independent and testable** within its phase
- **Sequenced by dependency** (setup → foundational → user stories)
- **Parallelizable** where marked with `[P]`
- **Effort-scoped** for sprint planning
- **Reference-ready** with file paths and acceptance criteria

**MVP Scope**: Complete User Stories 1 & 2 (P1 features) for first release; defer US3 & US4 optimizations to Iteration 2.

---

## Task Format Reference

```
- [ ] [ID] [P?] [Story?] Task title with clear action and file path
  - **Acceptance Criteria**: 
    - AC1: ...
    - AC2: ...
  - **Dependencies**: [Blockers, if any]
  - **Effort**: [XS, S, M, L, XL estimate]
```

---

# Phase 1: Core Project Setup & Architecture (Week 1)

**Goal**: Establish feature folder structure, entity definitions, data models, and Riverpod state management foundation. Header and time metrics UI mockup ready.

**Deliverable**: Project structure complete, domain entities defined, repository interface ready, Riverpod providers scaffolded, HeaderWidget and TimeMetricsWidget display data (mocked or from test API).

---

- [X] T001 Set up Dashboard feature folder structure with data/domain/presentation layers
  - **Description**: Create all directories per plan §3: `lib/features/dashboard/{data,domain,presentation}` with subdirs (datasources, models, repositories, mappers, entities, usecases, pages, widgets, viewmodels).
  - **File**: `lib/features/dashboard/` (folder structure)
  - **Acceptance Criteria**:
    - ✓ Folders created: data/{datasources,models,repositories,mappers}, domain/{entities,repositories,usecases}, presentation/{pages,widgets,viewmodels}
    - ✓ Core constants file created: `lib/core/constants/dashboard_constants.dart`
    - ✓ Extensions created: `lib/core/extensions/duration_extension.dart` (format HH:MM:SS)
    - ✓ All directories have `.gitkeep` or initial files to preserve structure
  - **Dependencies**: None
  - **Effort**: XS

- [X] T002 [P] Define domain entities: EmployeeProfile, TimeMetrics, Task, ActiveTask
  - **Description**: Create immutable Dart data classes for all core domain entities with proper null safety, enums for TaskStatus and OnlineStatus.
  - **Files**:
    - `lib/features/dashboard/domain/entities/employee_profile.dart`
    - `lib/features/dashboard/domain/entities/time_metrics.dart`
    - `lib/features/dashboard/domain/entities/task.dart`
    - `lib/features/dashboard/domain/entities/active_task.dart`
  - **Acceptance Criteria**:
    - ✓ EmployeeProfile: id, displayName, role, onlineStatus, avatarUrl
    - ✓ TimeMetrics: clockInTime, activeTime, totalTimeAtWork, clockOutTime
    - ✓ Task: id, projectName, description, status, isBillable, elapsedTime, isActive, startedAt, completedAt
    - ✓ ActiveTask extends Task: isPaused flag
    - ✓ Enums: TaskStatus (new, inProgress, overdue, complete), OnlineStatus (online, offline, away, doNotDisturb)
    - ✓ All classes immutable (final fields, const constructors where applicable)
    - ✓ copyWith() methods for immutable updates
    - ✓ Unit tests for entity constructors and comparison
  - **Dependencies**: None
  - **Effort**: S

- [X] T003 [P] Create data models (DTOs) with JSON serialization: *Model classes
  - **Description**: Define TaskModel, TaskListModel, TimeMetricsModel, EmployeeProfileModel with @JsonSerializable, factory constructors, and toJson().
  - **Files**:
    - `lib/features/dashboard/data/models/employee_profile_model.dart`
    - `lib/features/dashboard/data/models/time_metrics_model.dart`
    - `lib/features/dashboard/data/models/task_model.dart`
    - `lib/features/dashboard/data/models/active_task_model.dart`
  - **Acceptance Criteria**:
    - ✓ All models use `@JsonSerializable()` and implement `fromJson()`, `toJson()`
    - ✓ Models map API field names (snake_case) to Dart properties (camelCase)
    - ✓ Status fields stored as strings in JSON, converted to enums in factories
    - ✓ Duration fields stored as seconds (int) in JSON, converted to Duration entities
    - ✓ Models properly handle null fields and defaults
    - ✓ Generated JSON serialization code via `dart run build_runner build`
  - **Dependencies**: T002
  - **Effort**: M

- [X] T004 [P] Create mapper: DTO ↔ Entity conversion in DashboardMapper
  - **Description**: Implement bidirectional mapping between data models and domain entities to maintain layer separation.
  - **File**: `lib/features/dashboard/data/mappers/dashboard_mapper.dart`
  - **Acceptance Criteria**:
    - ✓ TaskModel → Task (and ActiveTask if isActive=true)
    - ✓ TimeMetricsModel → TimeMetrics
    - ✓ EmployeeProfileModel → EmployeeProfile
    - ✓ Status enum conversion (string ↔ enum)
    - ✓ Duration conversion (int seconds ↔ Duration)
    - ✓ Unit tests: convert and reverse operations, verify field mappings
  - **Dependencies**: T002, T003
  - **Effort**: S

- [X] T005 Define DashboardRepository interface (abstract)
  - **Description**: Create abstract `DashboardRepository` interface with all required methods (getDashboardData, pause, complete, start, search).
  - **File**: `lib/features/dashboard/domain/repositories/dashboard_repository.dart`
  - **Acceptance Criteria**:
    - ✓ Method: `Future<DashboardData> getDashboardData()` — returns profile, metrics, active task, task list
    - ✓ Method: `Future<void> pauseActiveTask(String taskId)`
    - ✓ Method: `Future<void> completeActiveTask(String taskId)`
    - ✓ Method: `Future<Task> startTask(String taskId)`
    - ✓ Method: `Future<List<Task>> searchTasks(String query, {TaskStatus? status, int limit = 20, int offset = 0})`
    - ✓ Method: `Future<List<Task>> filterTasksByStatus(TaskStatus status, {int limit = 20, int offset = 0})`
    - ✓ All methods throw appropriate exceptions on error
  - **Dependencies**: T002
  - **Effort**: S

- [X] T006 Implement DashboardRepositoryImpl with mock/test data initially
  - **Description**: Implement `DashboardRepository` using mock data first (no real API calls yet); scaffold for later API integration and SQLite caching.
  - **File**: `lib/features/dashboard/data/repositories/dashboard_repository_impl.dart`
  - **Acceptance Criteria**:
    - ✓ Constructor injects auth service and API client
    - ✓ `getDashboardData()` returns mock DashboardData with sample profile, metrics, active task, task list
    - ✓ `pauseActiveTask()`, `completeActiveTask()`, `startTask()` update mock state (in-memory cache)
    - ✓ `searchTasks()` filters mock task list by query
    - ✓ `filterTasksByStatus()` filters mock task list by status
    - ✓ Logging for all method calls (per constitution §14)
    - ✓ Comments mark places for real API calls and SQLite integration
    - ✓ Unit tests: verify mock data structure, method calls, error handling stubs
  - **Dependencies**: T004, T005
  - **Effort**: M

- [X] T007 [P] Create domain use cases: GetDashboardDataUseCase, PauseActiveTaskUseCase, CompleteActiveTaskUseCase, StartTaskUseCase
  - **Description**: Implement use case classes that orchestrate repository calls and business logic per domain layer separation (no UI, no DB specifics).
  - **Files**:
    - `lib/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart`
    - `lib/features/dashboard/domain/usecases/pause_active_task_usecase.dart`
    - `lib/features/dashboard/domain/usecases/complete_active_task_usecase.dart`
    - `lib/features/dashboard/domain/usecases/start_task_usecase.dart`
  - **Acceptance Criteria**:
    - ✓ Each use case has single `call()` method (or `execute()`)
    - ✓ GetDashboardDataUseCase: takes no params, returns DashboardData
    - ✓ PauseActiveTaskUseCase: takes taskId, returns void
    - ✓ CompleteActiveTaskUseCase: takes taskId, returns void
    - ✓ StartTaskUseCase: takes taskId, returns Task
    - ✓ All use cases inject DashboardRepository only (no UI or DB layer)
    - ✓ Unit tests for each use case: verify repository calls, return values, error propagation
  - **Dependencies**: T005, T006
  - **Effort**: M

- [X] T008 [P] Create Riverpod providers for dashboard state
  - **Description**: Set up Riverpod FutureProvider for dashboard data, StateNotifierProvider for filter state, and derived filtered tasks provider.
  - **File**: `lib/features/dashboard/presentation/viewmodels/dashboard_providers.dart` (or split into providers file)
  - **Acceptance Criteria**:
    - ✓ `dashboardProvider` (FutureProvider.autoDispose): fetches DashboardData, handles loading/error/data states
    - ✓ `taskFilterProvider` (StateNotifierProvider): manages task filter (status, search query)
    - ✓ `filteredTasksProvider` (Provider.autoDispose): derives filtered tasks from dashboardProvider + taskFilterProvider
    - ✓ `activeTaskTimerProvider` (StreamProvider.autoDispose): emits Duration every 1 second for live timer [FR-014]
    - ✓ Action providers: pauseActiveTaskProvider, completeActiveTaskProvider, startTaskProvider (handle mutations)
    - ✓ Providers inject repository and use cases correctly
    - ✓ autoDispose to clean up unused providers
    - ✓ Unit tests (or mock tests): providers build correctly, return expected AsyncValue states
  - **Dependencies**: T006, T007
  - **Effort**: M

- [X] T009 Create DashboardViewModel using Riverpod providers
  - **Description**: Assemble the ViewModel as a StateNotifier or Riverpod family provider that holds dashboard UI state (profile, metrics, active task, tasks, loading, error).
  - **File**: `lib/features/dashboard/presentation/viewmodels/dashboard_viewmodel.dart`
  - **Acceptance Criteria**:
    - ✓ ViewModel hold: profile, timeMetrics, activeTask, tasks list, isLoading, error message
    - ✓ Exposes methods: loadDashboard(), pauseActiveTask(), completeActiveTask(), startTask(), filterTasks(), searchTasks()
    - ✓ Integrates with Riverpod providers (watches, reads, refreshes)
    - ✓ Handles state transitions (idle → loading → data/error)
    - ✓ Provides derived state: hasActiveTask, isTimerRunning, filtered/searched tasks
    - ✓ Unit/widget tests: state transitions, action outcomes, error handling
  - **Dependencies**: T008
  - **Effort**: M

- [X] T010 Build HeaderWidget displaying user profile and online status
  - **Description**: Create reusable HeaderWidget that displays user name, role, online status with visual indicator (colored dot, badge, etc.).
  - **File**: `lib/features/dashboard/presentation/widgets/header_widget.dart`
  - **Acceptance Criteria**:
    - ✓ Accepts EmployeeProfile model
    - ✓ Displays: displayName (large), role (secondary text), online status with indicator (green/red/gray dot)
    - ✓ Optional dropdown or menu for status change (stub for future)
    - ✓ Responsive: adapts to screen width (mobile first)
    - ✓ Uses theme system for colors, typography
    - ✓ Skeleton loading state when profile is null
    - ✓ Widget tests: verify text content, indicator color per status
  - **Dependencies**: T002
  - **Effort**: S

- [X] T011 [P] Build TimeMetricsWidget displaying clock-in, active time, total work time
  - **Description**: Create widget to display today's time metrics in an organized card layout with proper formatting.
  - **File**: `lib/features/dashboard/presentation/widgets/time_metrics_widget.dart`
  - **Acceptance Criteria**:
    - ✓ Accepts TimeMetrics model
    - ✓ Displays: clock-in time (e.g., "09:37 am"), active time (e.g., "02:17 hrs"), total time at work (e.g., "03:09 hrs")
    - ✓ Gracefully handles null clock-in time: shows "Not clocked in" or "—" [§13 Edge Cases]
    - ✓ Formats durations using DurationExtension (HH:MM)
    - ✓ Card layout with icons or visual hierarchy
    - ✓ Responsive design
    - ✓ Skeleton loading state when metrics are null
    - ✓ Widget tests: verify formatting, null handling, display accuracy
  - **Dependencies**: T002
  - **Effort**: S

- [X] T012 [P] Build LoadingStateWidget (reusable skeleton loader)
  - **Description**: Create reusable loading state widget with skeleton placeholders for dashboard sections.
  - **File**: `lib/features/dashboard/presentation/widgets/loading_state_widget.dart`
  - **Acceptance Criteria**:
    - ✓ Shows skeleton loaders for: header area, metrics area, active task card, task list items
    - ✓ Smooth shimmer or pulse animation
    - ✓ Maintains layout structure (no layout shift when loading completes)
    - ✓ Customizable: can show partial skeletons (e.g., header only, or full dashboard)
    - ✓ Widget tests: renders without errors, animations fire correctly
  - **Dependencies**: None
  - **Effort**: M

- [X] T013 [P] Build ErrorStateWidget (reusable error display with retry)
  - **Description**: Create reusable error state widget showing error message and retry button.
  - **File**: `lib/features/dashboard/presentation/widgets/error_state_widget.dart`
  - **Acceptance Criteria**:
    - ✓ Displays error message (user-friendly, not raw exception)
    - ✓ Provides "Retry" button with callback
    - ✓ Icon or visual indicator for error state
    - ✓ Responsive layout
    - ✓ Optional subtitle or support text
    - ✓ Widget tests: renders message, button tap triggers callback
  - **Dependencies**: None
  - **Effort**: S

- [X] T014 Build DashboardScreen scaffold integrating header, metrics, active task area, error/loading states
  - **Description**: Create main DashboardScreen that orchestrates HeaderWidget, TimeMetricsWidget, loading/error states, and serves as container for active task and task list.
  - **File**: `lib/features/dashboard/presentation/pages/dashboard_screen.dart`
  - **Acceptance Criteria**:
    - ✓ Consumes dashboardProvider from ViewModel to build UI (loading/error/data states)
    - ✓ Displays HeaderWidget and TimeMetricsWidget when data loaded
    - ✓ Shows LoadingStateWidget when loading
    - ✓ Shows ErrorStateWidget with retry on error [FR-010, FR-013]
    - ✓ Placeholder areas for ActiveTaskCard and TaskListWidget (to be added Phase 2-3)
    - ✓ Integrates with bottom navigation bar (Home tab selected) [FR-009]
    - ✓ Responsive layout: SingleChildScrollView or CustomScrollView for vertical scroll
    - ✓ Handles lifecycle: loads data on initState/mount
    - ✓ Widget tests: verify loading/error/data state renders, data displays correctly
  - **Dependencies**: T009, T010, T011, T012, T013
  - **Effort**: M

- [X] T015 [P] Add unit tests for Phase 1 domain and data components
  - **Description**: Write comprehensive unit tests for use cases, mappers, and repository impl with mock data.
  - **Files**:
    - `test/features/dashboard/domain/usecases/get_dashboard_data_usecase_test.dart`
    - `test/features/dashboard/domain/usecases/pause_active_task_usecase_test.dart`
    - `test/features/dashboard/data/mappers/dashboard_mapper_test.dart`
    - `test/features/dashboard/data/repositories/dashboard_repository_impl_test.dart`
  - **Acceptance Criteria**:
    - ✓ Test coverage ≥ 80% for domain and data layers
    - ✓ Use cases: verify calls to repository, return values, error handling
    - ✓ Mappers: verify DTO → Entity and reverse, enum/duration conversions
    - ✓ Repository: verify mock data structure, filters, error states
    - ✓ All tests pass, no flaky tests
  - **Dependencies**: T007, T004, T006
  - **Effort**: M

- [X] T016 Verify auth service integration and token injection in API calls
  - **Description**: Ensure existing auth service is properly integrated into repository; verify Bearer token is injected into mock/real API calls.
  - **File**: `lib/features/dashboard/data/repositories/dashboard_repository_impl.dart` (update)
  - **Acceptance Criteria**:
    - ✓ Repository constructor accepts and stores auth service
    - ✓ Mock API calls include Authorization header (logged for testing)
    - ✓ Session expiry redirects to login (stub if needed, real handling by auth interceptor)
    - ✓ Test: verify token is present in request
  - **Dependencies**: T006
  - **Effort**: XS

**Phase 1 Summary**:
- ✓ 15 tasks, ~15-18 story points
- ✓ Project structure, entities, models, repository, use cases, Riverpod providers, core widgets
- ✓ Deliverable: Header + Time Metrics displayed with loading/error states; data from mock repository
- ✓ Ready for Phase 2 (Active Task & Timer)

---

# Phase 2: Active Task & Live Timer (Week 2)

**Goal**: Implement active task display with live-updating timer, pause/complete/start task actions, and offline support for actions (queue & sync).

**Deliverable**: Active task card renders with live timer (1 Hz updates), pause/complete/start buttons functional, offline action queuing implemented, empty state when no active task.

---

- [ ] T017 Build ActiveTaskCard widget with live timer display
  - **Description**: Create prominent card widget showing active task info (project, description, billable tag) with elapsed time timer updating every 1 second.
  - **File**: `lib/features/dashboard/presentation/widgets/active_task_card.dart`
  - **Acceptance Criteria**:
    - ✓ Displays: project name, billable/non-billable tag, task description (truncated at 100 chars [Q4]), elapsed timer (HH:MM:SS)
    - ✓ Listens to activeTaskTimerProvider and rebuilds every 1 second [FR-014, Q2]
    - ✓ Pause and Complete action buttons
    - ✓ Card design: visually prominent, distinct from task list items
    - ✓ Formatted elapsed time via DurationExtension
    - ✓ Responsive layout
    - ✓ Widget tests: verify timer updates, buttons render, truncation works
  - **Dependencies**: T002, T008
  - **Effort**: M

- [ ] T018 Implement activeTaskTimerProvider (StreamProvider) emitting Duration every 1 second
  - **Description**: Create Riverpod StreamProvider that emits updated elapsed Duration every 1 second while task is active.
  - **File**: `lib/features/dashboard/presentation/viewmodels/dashboard_providers.dart` (add/update)
  - **Acceptance Criteria**:
    - ✓ Timer emits every 1000ms (1 Hz) [Q2 Answer]
    - ✓ Starts from active task's startedAt time
    - ✓ Accounts for paused state (timer stops if isPaused)
    - ✓ Auto-disposes when no listeners
    - ✓ Syncs with server periodically to correct drift (stub for Phase 4)
    - ✓ Unit tests: verify emission interval, pause behavior
  - **Dependencies**: T008, T002
  - **Effort**: M

- [ ] T019 [P] Implement PauseActiveTaskUseCase
  - **Description**: Use case to pause active task via repository, invalidate dashboard data, refresh UI.
  - **File**: `lib/features/dashboard/domain/usecases/pause_active_task_usecase.dart` (update/refine if needed)
  - **Acceptance Criteria**:
    - ✓ Takes taskId as input
    - ✓ Calls repository.pauseActiveTask(taskId)
    - ✓ Propagates exceptions (network, validation, etc.)
    - ✓ Unit tests: verify repository call, error handling
  - **Dependencies**: T005, T006
  - **Effort**: S

- [ ] T020 [P] Implement CompleteActiveTaskUseCase
  - **Description**: Use case to mark active task complete, update state, handle offline queuing.
  - **File**: `lib/features/dashboard/domain/usecases/complete_active_task_usecase.dart` (update/refine)
  - **Acceptance Criteria**:
    - ✓ Takes taskId as input
    - ✓ Calls repository.completeActiveTask(taskId)
    - ✓ Propagates exceptions
    - ✓ Unit tests: verify repository call, error handling
  - **Dependencies**: T005, T006
  - **Effort**: S

- [ ] T021 [P] Implement StartTaskUseCase
  - **Description**: Use case to start/resume a task, make it active, start timer.
  - **File**: `lib/features/dashboard/domain/usecases/start_task_usecase.dart` (update/refine)
  - **Acceptance Criteria**:
    - ✓ Takes taskId as input
    - ✓ Calls repository.startTask(taskId)
    - ✓ Returns the started Task
    - ✓ Propagates exceptions
    - ✓ Unit tests: verify repository call, return value
  - **Dependencies**: T005, T006
  - **Effort**: S

- [ ] T022 Wire pause/complete/start actions from ActiveTaskCard to repository via ViewModel
  - **Description**: Connect button callbacks in ActiveTaskCard to ViewModel actions, which call use cases and refresh UI state.
  - **File**: `lib/features/dashboard/presentation/pages/dashboard_screen.dart` (integrate with ActiveTaskCard)
  - **Acceptance Criteria**:
    - ✓ Pause button → ViewModel.pauseActiveTask() → invalidates dashboardProvider
    - ✓ Complete button → ViewModel.completeActiveTask() → refreshes state
    - ✓ (Task list) Start buttons → ViewModel.startTask(taskId) → refreshes state
    - ✓ UI updates immediately after action (optimistic or server-confirmed)
    - ✓ Loading indicator during action (prevent double-tap)
    - ✓ Error handling: show error message if action fails
    - ✓ Integration tests: verify actions work end-to-end
  - **Dependencies**: T017, T009, T019, T020, T021
  - **Effort**: M

- [ ] T023 Build EmptyStateWidget for "No active task" scenario
  - **Description**: Create reusable empty state widget for when no task is currently active.
  - **File**: `lib/features/dashboard/presentation/widgets/empty_state_widget.dart`
  - **Acceptance Criteria**:
    - ✓ Displays friendly message: "No active task"
    - ✓ Optional prompt: "Start a task from the list below"
    - ✓ Icon or illustration
    - ✓ Responsive layout
    - ✓ Widget tests: renders without errors
  - **Dependencies**: None
  - **Effort**: XS

- [ ] T024 Integrate EmptyStateWidget into ActiveTaskCard (when activeTask is null) [FR-011]
  - **Description**: Update ActiveTaskCard or DashboardScreen to show EmptyStateWidget when there's no active task.
  - **File**: `lib/features/dashboard/presentation/pages/dashboard_screen.dart` or `lib/features/dashboard/presentation/widgets/active_task_card.dart` (update)
  - **Acceptance Criteria**:
    - ✓ If activeTask is null, show EmptyStateWidget instead of card
    - ✓ EmptyStateWidget displays gracefully
    - ✓ User can still see task list below (can start a task from there)
    - ✓ Widget tests: verify state transition (no task → task → no task)
  - **Dependencies**: T017, T023
  - **Effort**: XS

- [ ] T025 Implement offline action queuing for pause/complete/start (Phase 2 foundation)
  - **Description**: Scaffold local queuing mechanism (in-memory or SQLite) to store pending actions when offline; sync on reconnection [Clarification Q1, §13 Edge Case].
  - **File**: `lib/features/dashboard/data/datasources/dashboard_local_datasource.dart` (update or create)
  - **Acceptance Criteria**:
    - ✓ Local storage: queue structure (action type, taskId, timestamp, status)
    - ✓ On offline action (pause/complete/start): add to queue, return optimistic success to UI
    - ✓ Detect online status change (via connectivity plugin or app resume)
    - ✓ On reconnection: attempt to sync queued actions (stub for full impl in Phase 4)
    - ✓ Show sync status to user: "Syncing..." → "Synced" or "Sync failed"
    - ✓ Unit tests: verify queue add, sync trigger, status updates
  - **Dependencies**: T006, T022
  - **Effort**: M

- [ ] T026 Add retry logic on fetch failure with exponential backoff
  - **Description**: Implement retry mechanism in repository for failed API calls (ERR-013).
  - **File**: `lib/features/dashboard/data/repositories/dashboard_repository_impl.dart` (update)
  - **Acceptance Criteria**:
    - ✓ Retry up to 3 times with exponential backoff (1s, 2s, 4s) on transient errors (timeout, 5xx)
    - ✓ Do not retry on permanent errors (401, 403, 404)
    - ✓ User can tap "Retry" button to re-attempt
    - ✓ Logging for retry attempts
    - ✓ Unit tests: verify retry count, backoff timing, error classification
  - **Dependencies**: T006
  - **Effort**: M

- [ ] T027 Test timer accuracy and lifecycle (app background, device sleep, resume)
  - **Description**: Manual/automated tests for timer behavior when app goes to background or device sleeps.
  - **File**: Manual testing + integration test stubs in `test/features/dashboard/presentation/active_task_card_test.dart`
  - **Acceptance Criteria**:
    - ✓ Timer pauses when app goes to background (lifecycle detection)
    - ✓ Timer resumes correctly when app returns to foreground
    - ✓ Elapsed time is accurate (verified against server)
    - ✓ No timer drift after extended background period
    - ✓ Timer continues to work after device sleep (local calculation + sync) [§13 Edge Case]
    - ✓ Integration tests: simulate background/resume, device sleep (or manual test doc)
  - **Dependencies**: T017, T018
  - **Effort**: M

- [ ] T028 [P] Add unit tests for Phase 2 timer and action logic
  - **Description**: Comprehensive tests for activeTaskTimerProvider, pause/complete/start use cases, and action handling.
  - **Files**:
    - `test/features/dashboard/presentation/viewmodels/active_task_timer_provider_test.dart`
    - `test/features/dashboard/domain/usecases/pause_active_task_usecase_test.dart` (if separate)
    - `test/features/dashboard/presentation/widgets/active_task_card_test.dart`
  - **Acceptance Criteria**:
    - ✓ Test coverage ≥ 80% for Phase 2 code
    - ✓ Timer provider: emission rate, pause/resume, cleanup
    - ✓ Use cases: action outcomes, state changes
    - ✓ Widgets: button interactions, state display
    - ✓ All tests pass
  - **Dependencies**: T017, T018, T019, T020, T021, T022, T025
  - **Effort**: M

**Phase 2 Summary**:
- ✓ 12 tasks, ~13-16 story points
- ✓ Active task card with live timer (1 Hz), pause/complete/start actions functional
- ✓ Offline action queuing scaffolded (full sync in Phase 4)
- ✓ Empty state when no active task
- ✓ Deliverable: Active task working end-to-end; timer accurate; actions offline-safe

---

# Phase 3: Task List, Search & Filter (Week 3)

**Goal**: Implement full task list with lazy-load pagination, search, status filters, and per-task quick actions (start/complete).

**Deliverable**: Task list loads first 20 items with "Load More" button [Q3], search filters tasks, status tabs filter by New/In Progress/Overdue/Complete [Q3], quick actions on task list items working, empty state for no tasks.

---

- [ ] T029 Build TaskListWidget container with SearchFieldWidget and TaskFilterTabs
  - **Description**: Create main task list container housing search input, filter tabs, and scrollable task list.
  - **File**: `lib/features/dashboard/presentation/widgets/task_list_widget.dart`
  - **Acceptance Criteria**:
    - ✓ Search field at top (SearchFieldWidget)
    - ✓ Status filter tabs below search (TaskFilterTabs): New, In Progress, Overdue, Complete with counts
    - ✓ Scrollable list area below tabs
    - ✓ Reactive: updates list when search or filter changes
    - ✓ Responsive layout
    - ✓ Contains TaskListViewWithPagination or similar for list items
    - ✓ Widget tests: verify layout, search/filter integration
  - **Dependencies**: None
  - **Effort**: S

- [ ] T030 [P] Build SearchFieldWidget for task search input
  - **Description**: Text input field for searching tasks by project name or description.
  - **File**: `lib/features/dashboard/presentation/widgets/search_field_widget.dart`
  - **Acceptance Criteria**:
    - ✓ Text input with placeholder: "Search tasks..."
    - ✓ Clear button (X) to reset search
    - ✓ Callback on text change: notifies parent/ViewModel
    - ✓ Debounce search input (300ms) to avoid excessive filtering
    - ✓ Responsive design
    - ✓ Widget tests: verify input, clear, callback firing
  - **Dependencies**: None
  - **Effort**: S

- [ ] T031 [P] Build TaskFilterTabs showing status counts (New, In Progress, Overdue, Complete)
  - **Description**: Horizontal tabs to filter task list by status, with counts per status.
  - **File**: `lib/features/dashboard/presentation/widgets/task_filter_tabs.dart`
  - **Acceptance Criteria**:
    - ✓ Tabs for: New, In Progress, Overdue, Complete, and All (optional)
    - ✓ Each tab shows count: e.g., "In Progress (5)"
    - ✓ Selected tab highlighted visually
    - ✓ Callback on tab selection → notifies ViewModel to filter
    - ✓ Responsive: wraps or scrolls if too many tabs
    - ✓ Widget tests: verify tab rendering, selection, callback
  - **Dependencies**: None
  - **Effort**: S

- [ ] T032 Build TaskItemWidget: individual task card for list
  - **Description**: Reusable card widget showing single task with project, description, elapsed time, and quick action buttons (Start/Resume, Complete).
  - **File**: `lib/features/dashboard/presentation/widgets/task_item_widget.dart`
  - **Acceptance Criteria**:
    - ✓ Displays: project name, billable/non-billable tag, task description (truncated at 100 chars [Q4]), elapsed time (if started)
    - ✓ Status badge or indicator (New, In Progress, Overdue, Complete)
    - ✓ Buttons: "Start" (if New), "Resume" (if paused), "Complete"
    - ✓ Button states change based on task status
    - ✓ Callback for start/complete actions
    - ✓ Responsive, compact design for list context
    - ✓ Visual distinction from active task card
    - ✓ Widget tests: verify content display, button rendering, action callbacks
  - **Dependencies**: T002
  - **Effort**: M

- [ ] T033 Build TaskListViewWithPagination using ListView.builder for lazy loading [FR-006, FR-007, Q3]
  - **Description**: Create ListView.builder widget that displays task list with pagination: load initial 20 items, show "Load More" button to fetch next batch.
  - **File**: `lib/features/dashboard/presentation/widgets/task_list_view_with_pagination.dart`
  - **Acceptance Criteria**:
    - ✓ Initially loads 20 tasks [Q3 Answer: 20-30 per page]
    - ✓ "Load More" button at bottom (when more items available)
    - ✓ Tap "Load More" → fetch next 20 items (offset += 20)
    - ✓ ListView.builder: only visible items rendered (performance optimization)
    - ✓ Loading indicator while fetching next batch
    - ✓ Error handling: "Load More" button shows error on failure
    - ✓ Responsive: adapts to screen size
    - ✓ Widget tests: verify initial load, pagination logic, error states
  - **Dependencies**: T032
  - **Effort**: M

- [ ] T034 Implement SearchTasksUseCase: search tasks by query and (optional) status filter
  - **Description**: Use case to search task list based on query string and optional status.
  - **File**: `lib/features/dashboard/domain/usecases/search_tasks_usecase.dart`
  - **Acceptance Criteria**:
    - ✓ Takes query string and optional status
    - ✓ Calls repository.searchTasks(query, status, limit, offset)
    - ✓ Returns filtered list of Task entities
    - ✓ Handles pagination (limit, offset)
    - ✓ Unit tests: verify repository call, return values, pagination
  - **Dependencies**: T005
  - **Effort**: S

- [ ] T035 [P] Implement FilterTasksByStatusUseCase
  - **Description**: Use case to filter tasks by status (New, In Progress, Overdue, Complete).
  - **File**: `lib/features/dashboard/domain/usecases/filter_tasks_by_status_usecase.dart`
  - **Acceptance Criteria**:
    - ✓ Takes status enum and optional pagination (limit, offset)
    - ✓ Calls repository.filterTasksByStatus(status, limit, offset)
    - ✓ Returns filtered list of Task entities
    - ✓ Unit tests: verify repository call, return values
  - **Dependencies**: T005
  - **Effort**: S

- [ ] T036 Create filteredTasksProvider: Riverpod derived provider for search + filter results
  - **Description**: Add/update Riverpod provider that combines dashboardProvider, search query, and status filter to produce reactive filtered task list.
  - **File**: `lib/features/dashboard/presentation/viewmodels/dashboard_providers.dart` (update)
  - **Acceptance Criteria**:
    - ✓ Provider reads: dashboardProvider (all tasks), taskFilterProvider (search + status)
    - ✓ Automatically recalculates when filter or search changes
    - ✓ Returns filtered List<Task>
    - ✓ Handles pagination offset
    - ✓ Unit tests: verify filtering logic, reactivity
  - **Dependencies**: T008, T034, T035
  - **Effort**: M

- [ ] T037 Integrate TaskListWidget into DashboardScreen below ActiveTaskCard
  - **Description**: Add task list widget to main dashboard, showing filtered tasks with search and filter tabs.
  - **File**: `lib/features/dashboard/presentation/pages/dashboard_screen.dart` (update)
  - **Acceptance Criteria**:
    - ✓ TaskListWidget rendered below active task card
    - ✓ Consumes filteredTasksProvider for task list
    - ✓ Passes task list and callbacks to TaskListWidget
    - ✓ Search and filter interact correctly with ViewModel
    - ✓ Responsive layout: scrollable container
    - ✓ Widget tests: verify integration, state flow
  - **Dependencies**: T029, T036, T009
  - **Effort**: M

- [ ] T038 Wire start/complete actions on task list items to ViewModel (call StartTaskUseCase, CompleteTaskUseCase)
  - **Description**: Connect TaskItemWidget action buttons to ViewModel, updating dashboard state reactively.
  - **File**: `lib/features/dashboard/presentation/pages/dashboard_screen.dart` (integrate with task list callbacks)
  - **Acceptance Criteria**:
    - ✓ Start/Resume button → ViewModel.startTask(taskId) → refreshes dashboard/active task
    - ✓ Complete button → ViewModel.completeActiveTask(taskId) → refreshes task list and active task area
    - ✓ UI updates immediately (optimistic or confirmed)
    - ✓ Loading/error states during action
    - ✓ Offline actions queued (via T025)
    - ✓ Integration tests: verify actions update list and active task correctly
  - **Dependencies**: T032, T022, T009, T019, T020, T021
  - **Effort**: M

- [ ] T039 Build ReusableTaskEmptyStateWidget for "No tasks" in list
  - **Description**: Create widget showing "No tasks found" or "No tasks in this status" message when list is empty.
  - **File**: `lib/features/dashboard/presentation/widgets/reusable_task_empty_state_widget.dart`
  - **Acceptance Criteria**:
    - ✓ Displays relevant message based on context (no tasks vs. no search results vs. no status matches)
    - ✓ Optional icon or illustration
    - ✓ Responsive layout
    - ✓ Widget tests: renders without errors
  - **Dependencies**: None
  - **Effort**: XS

- [ ] T040 Integrate ReusableTaskEmptyStateWidget into task list (when filtered list is empty) [FR-012]
  - **Description**: Update TaskListViewWithPagination or TaskListWidget to show empty state when no tasks match filter/search.
  - **File**: `lib/features/dashboard/presentation/widgets/task_list_widget.dart` or `task_list_view_with_pagination.dart` (update)
  - **Acceptance Criteria**:
    - ✓ If filtered tasks list is empty, show empty state widget
    - ✓ Message reflects reason: no tasks at all, no search results, or no tasks in status
    - ✓ Empty state replaces list, doesn't show blank area
    - ✓ Widget tests: verify state display
  - **Dependencies**: T039, T036
  - **Effort**: XS

- [ ] T041 Test performance with large task lists (lazy loading, ListView rendering)
  - **Description**: Manual/automated performance testing to verify smooth scrolling and filtering with 100+ tasks.
  - **File**: Perf test doc or integration test stub
  - **Acceptance Criteria**:
    - ✓ Scrolling is smooth (60 fps or device capability)
    - ✓ No visible lag when switching filter tabs
    - ✓ Search responds quickly (debounce effective)
    - ✓ Pagination: "Load More" fetches and renders smoothly
    - ✓ Memory usage stays reasonable with large task lists
    - ✓ Profiling data logged (if tools available)
  - **Dependencies**: T033, T036
  - **Effort**: M

- [ ] T042 [P] Add unit and widget tests for Phase 3 search/filter logic and list widgets
  - **Description**: Comprehensive tests for search, filter, task list rendering, and pagination.
  - **Files**:
    - `test/features/dashboard/domain/usecases/search_tasks_usecase_test.dart`
    - `test/features/dashboard/domain/usecases/filter_tasks_by_status_usecase_test.dart`
    - `test/features/dashboard/presentation/widgets/task_list_widget_test.dart`
    - `test/features/dashboard/presentation/widgets/task_item_widget_test.dart`
  - **Acceptance Criteria**:
    - ✓ Test coverage ≥ 80% for Phase 3 code
    - ✓ Search: verify filtering by query, pagination, empty results
    - ✓ Filter: verify status filtering, count updates
    - ✓ Widgets: rendering, interaction, state display
    - ✓ All tests pass
  - **Dependencies**: T029-T040
  - **Effort**: M

**Phase 3 Summary**:
- ✓ 14 tasks, ~12-15 story points
- ✓ Task list with lazy-load pagination (20 items/page), search, status filter tabs
- ✓ Start/complete quick actions on task items
- ✓ Empty states for no tasks
- ✓ Performance verified with large lists
- ✓ Deliverable: Full task list interaction working; search and filters reactive; quick actions functional

---

# Phase 4: Polish, Offline Sync, Error Handling & Testing (Week 4)

**Goal**: Finalize UI polish with animations, complete offline sync implementation, comprehensive error handling, performance optimization, and full test coverage.

**Deliverable**: Polished dashboard with smooth animations, offline mode fully functional with sync feedback, robust error handling (network, session expiry, slow API), performance optimized, test coverage ≥ 85%, ready for release.

---

- [ ] T043 [P] Refine loading skeletons with shimmer/pulse animations
  - **Description**: Polish LoadingStateWidget with smooth shimmer or pulse animations to improve perceived performance.
  - **File**: `lib/features/dashboard/presentation/widgets/loading_state_widget.dart` (update)
  - **Acceptance Criteria**:
    - ✓ Smooth shimmer animation across skeleton placeholders
    - ✓ Animation duration appropriate (not too fast/slow)
    - ✓ No jank or performance impact
    - ✓ Widgets tests: verify animation fires correctly
  - **Dependencies**: T012
  - **Effort**: S

- [ ] T044 [P] Add state transitions and animations (card layouts, state changes)
  - **Description**: Implement smooth transitions when UI state changes (active task → empty → active again), slide/fade animations for cards.
  - **File**: `lib/features/dashboard/presentation/pages/dashboard_screen.dart`, widget files (update)
  - **Acceptance Criteria**:
    - ✓ ActiveTaskCard: fade in/out when appearing/disappearing
    - ✓ TaskListWidget: slide-in animation when list loads
    - ✓ State transitions: smooth visual feedback
    - ✓ AnimationDuration: 300-500ms for user perception
    - ✓ No layout shifts or jank
    - ✓ Widget tests: verify animations render (or visual regression tests)
  - **Dependencies**: T017, T029, T037
  - **Effort**: M

- [ ] T045 Complete offline caching (SQLite) implementation for task list and time metrics
  - **Description**: Implement SQLite persistence for dashboard data (profile, metrics, tasks) and offline action queue; sync on reconnection.
  - **File**: `lib/features/dashboard/data/datasources/dashboard_local_datasource.dart` (implement fully)
  - **Acceptance Criteria**:
    - ✓ SQLite schema: tasks, metrics, pending_actions tables
    - ✓ Save dashboard data to SQLite on successful API fetch
    - ✓ Load data from SQLite on app start (fast startup)
    - ✓ Queue system: save pause/complete/start actions to pending_actions table
    - ✓ On reconnection (detect via connectivity plugin): sync pending actions to server
    - ✓ Delete synced actions from queue
    - ✓ Show user: "Syncing..." → "Synced" or "Sync failed"
    - ✓ Unit tests: verify database operations, queue management, sync logic
  - **Dependencies**: T025
  - **Effort**: L

- [ ] T046 Improve error handling and user-facing error messages [FR-013]
  - **Description**: Centralize error handling and provide user-friendly messages for various failure scenarios (network, server errors, validation, etc.).
  - **File**: `lib/features/dashboard/data/repositories/dashboard_repository_impl.dart` (update), error handling throughout
  - **Acceptance Criteria**:
    - ✓ Network errors: "No internet connection. Please try again later."
    - ✓ Server errors (5xx): "Server is temporarily unavailable. Please try again."
    - ✓ Unauthorized (401): "Session expired. Please log in again."
    - ✓ Validation errors: "Invalid task. Please try again."
    - ✓ Timeout errors: "Request timed out. Please try again."
    - ✓ All errors logged for debugging
    - ✓ Error state widget shows appropriate message + retry button
    - ✓ Integration tests: simulate various error scenarios
  - **Dependencies**: T006, T013
  - **Effort**: M

- [ ] T047 Test session expiry scenario: 401 response → redirect to login [§13 Edge Case, FR-015]
  - **Description**: Ensure dashboard gracefully handles session expiry by intercepting 401 responses and redirecting to login.
  - **File**: Integration test or manual test doc
  - **Acceptance Criteria**:
    - ✓ When API returns 401 (Unauthorized), app detects and redirects to login
    - ✓ User-friendly message: "Session expired. Please log in again."
    - ✓ Dashboard state cleared on logout
    - ✓ No sensitive data persisted or exposed
    - ✓ Integration test or manual test procedure documented
  - **Dependencies**: T006, T046
  - **Effort**: S

- [ ] T048 [P] Test offline mode: no internet, queued actions, sync feedback
  - **Description**: Manual/integration testing of offline behavior: actions queue, sync feedback, recovery on reconnection.
  - **File**: Manual test doc or integration test suite
  - **Acceptance Criteria**:
    - ✓ Turn off internet → dashboard shows cached data
    - ✓ Offline badge visible
    - ✓ User can pause/complete/start tasks offline
    - ✓ Actions queued with "Pending sync" indicator
    - ✓ Turn internet back on → app syncs queued actions
    - ✓ "Syncing..." → "Synced" or "Sync failed" shown to user
    - ✓ Manual or integration test procedure documented
  - **Dependencies**: T045, T025
  - **Effort**: M

- [ ] T049 Verify bottom navigation integration: Home tab selected, navigation to Activities/Projects/Notifications works
  - **Description**: Ensure dashboard integrates correctly with app's bottom navigation bar; Home tab selected when on Dashboard, tapping other tabs navigates correctly.
  - **File**: `lib/features/dashboard/presentation/pages/dashboard_screen.dart` (verify integration), integration test
  - **Acceptance Criteria**:
    - ✓ When on DashboardScreen, Home tab in bottom nav is selected/highlighted
    - ✓ Tapping Activities, Projects, Notifications navigates to those screens
    - ✓ Tapping Home on another screen returns to Dashboard
    - ✓ Navigation state is preserved (no unnecessary reloads)
    - ✓ Integration test: verify navigation flow
  - **Dependencies**: T014
  - **Effort**: S

- [ ] T050 Performance optimization: profile dashboard load time, optimize rebuilds (Riverpod selectors, widget memoization)
  - **Description**: Profile dashboard to ensure fast load time (target: <3 sec per SC-001), optimize rebuilds to avoid unnecessary Flutter redraws.
  - **File**: Performance test, optimization in ViewModel/providers
  - **Acceptance Criteria**:
    - ✓ Dashboard loads within 3 seconds (SC-001) on mid-range device
    - ✓ Profile shows no excessive rebuilds of widgets
    - ✓ Riverpod providers use selectors to limit widget dependencies
    - ✓ Heavy operations (API calls, filtering large lists) don't block UI
    - ✓ Memory usage stays reasonable
    - ✓ Performance report documented
  - **Dependencies**: T009, T036, T041
  - **Effort**: M

- [ ] T051 [P] Add comprehensive unit tests: repository, use cases, mappers (≥80% coverage)
  - **Description**: Ensure Phase 1-4 domain and data layers have ≥80% test coverage with thorough unit tests.
  - **Files**:
    - `test/features/dashboard/data/repositories/dashboard_repository_impl_test.dart` (update)
    - `test/features/dashboard/domain/usecases/*_test.dart` (all use cases)
    - `test/features/dashboard/data/mappers/dashboard_mapper_test.dart` (update)
    - `test/features/dashboard/data/datasources/dashboard_local_datasource_test.dart` (new)
  - **Acceptance Criteria**:
    - ✓ Test coverage ≥80% for all domain and data code
    - ✓ Edge cases tested: null values, empty lists, error scenarios
    - ✓ Mocking: use mockito or similar for repository/datasource mocks
    - ✓ All tests pass in CI
    - ✓ Coverage report generated
  - **Dependencies**: All domain/data tasks
  - **Effort**: L

- [ ] T052 [P] Add widget tests: key screens and widgets (DashboardScreen, ActiveTaskCard, TaskListWidget, etc.)
  - **Description**: Comprehensive widget tests for presentation layer; verify rendering, user interaction, state display.
  - **Files**:
    - `test/features/dashboard/presentation/pages/dashboard_screen_test.dart`
    - `test/features/dashboard/presentation/widgets/active_task_card_test.dart`
    - `test/features/dashboard/presentation/widgets/task_list_widget_test.dart`
    - `test/features/dashboard/presentation/widgets/header_widget_test.dart`
    - `test/features/dashboard/presentation/widgets/time_metrics_widget_test.dart`
  - **Acceptance Criteria**:
    - ✓ Widget tests for: DashboardScreen (all states), ActiveTaskCard, TaskListWidget, HeaderWidget, TimeMetricsWidget, state widgets
    - ✓ Test coverage ≥60% for presentation code
    - ✓ Load state, error state, data state tested
    - ✓ Button interactions and callbacks tested
    - ✓ All tests pass in CI
  - **Dependencies**: T014, T017, T029, T010, T011
  - **Effort**: L

- [ ] T053 [P] Add integration tests: critical user journeys (login → Dashboard → interact → offline)
  - **Description**: End-to-end integration tests covering key user flows.
  - **Files**:
    - `integration_test/dashboard_integration_test.dart`
  - **Acceptance Criteria**:
    - ✓ Journey 1: Login → Dashboard loads → view profile and metrics → see active task
    - ✓ Journey 2: Pause active task → complete task → see empty state → start task from list
    - ✓ Journey 3: Search/filter task list → interact with task items → actions working
    - ✓ Journey 4: (Optional) Offline scenario: go offline → take action → go online → sync
    - ✓ All journeys pass against test backend or mock server
    - ✓ Runs in CI
  - **Dependencies**: All Phase 1-4 tasks
  - **Effort**: L

- [ ] T054 Write comprehensive documentation for dashboard feature
  - **Description**: Create README and architecture doc for dashboard module covering structure, setup, usage, and testing.
  - **Files**:
    - `lib/features/dashboard/README.md` (feature overview, structure, key components)
    - `docs/dashboard-architecture.md` (detailed architecture, data flow, diagrams)
  - **Acceptance Criteria**:
    - ✓ README: feature purpose, folder structure, key files, how to run tests
    - ✓ Architecture doc: layers overview, data flow diagrams (text or ASCII), entity relationships, state management strategy
    - ✓ How-to: debugging, common issues, running specific test suites
    - ✓ Links to spec and plan docs
  - **Dependencies**: All tasks
  - **Effort**: M

- [ ] T055 Code review and cleanup: ensure constitution compliance, naming conventions, no dead code
  - **Description**: Final code review against InTimePro Constitution (§12 naming conventions, §3 architecture, §14 logging, etc.); remove dead code; ensure consistency.
  - **File**: All dashboard files (review and update)
  - **Acceptance Criteria**:
    - ✓ All files follow naming conventions: snake_case, PascalCase classes, camelCase functions
    - ✓ Imports: no unused, consistent package: and relative import usage
    - ✓ Null safety: all ? and ! usage justified, no unnecessary bangs
    - ✓ Logging: structured logging throughout (per §14)
    - ✓ No dead code or commented-out sections
    - ✓ Code formatted: `dart format` applied, `dart analyze` shows zero issues
    - ✓ Constitution §3-§15 compliance checked
  - **Dependencies**: All tasks
  - **Effort**: M

- [ ] T056 Final integration with app routing, dependency injection (Riverpod), and app-level setup
  - **Description**: Integrate dashboard route into app navigation, ensure Riverpod providers are properly registered at app level, verify initialization.
  - **File**: `lib/main.dart` (or routing/DI setup), `lib/app.dart` (or equivalent)
  - **Acceptance Criteria**:
    - ✓ Dashboard route registered: `/dashboard` or equivalent
    - ✓ Riverpod ProviderContainer initialized at app level
    - ✓ Dashboard accessible post-login (protected route)
    - ✓ App starts without errors
    - ✓ Hot reload works without issues
    - ✓ Manual test: navigate to dashboard, all widgets render
  - **Dependencies**: T014, T008
  - **Effort**: S

- [ ] T057 Release preparation: tag features, create release notes, final QA checklist
  - **Description**: Prepare dashboard for release: feature flags (if needed), release notes, QA checklist, deployment readiness.
  - **Files**:
    - `CHANGELOG.md` (update with dashboard feature)
    - Release notes (feature highlights, known issues, future work)
    - QA checklist doc
  - **Acceptance Criteria**:
    - ✓ CHANGELOG updated with dashboard feature and version
    - ✓ Release notes: summary, user-facing changes, known limitations
    - ✓ QA checklist: all critical flows tested on real device(s)
    - ✓ No critical bugs or regressions
    - ✓ Performance verified
    - ✓ Ready for app store submission (or internal deployment)
  - **Dependencies**: All tasks (T001-T056)
  - **Effort**: M

**Phase 4 Summary**:
- ✓ 15 tasks, ~16-20 story points
- ✓ Offline sync fully implemented
- ✓ Error handling robust
- ✓ Performance optimized (<3 sec load time)
- ✓ Test coverage ≥80% (unit), ≥60% (widget), critical journeys (integration)
- ✓ Documentation complete
- ✓ Deliverable: Production-ready, polished dashboard feature

---

# Final Phase: Cross-Cutting & Logistics

These tasks span multiple phases and are ongoing or necessary for completeness:

- [ ] T058 Setup CI/CD pipeline: ensure all tests run, lint checks pass, coverage reports generated
  - **Acceptance Criteria**:
    - ✓ GitHub Actions or equivalent CI configured
    - ✓ On PR: run dart analyze, unit tests, widget tests, coverage report
    - ✓ Coverage threshold: ≥75% (block merge if below)
    - ✓ On merge to main: run integration tests, deploy to test environment (if applicable)
  - **Dependencies**: All testing tasks
  - **Effort**: M

- [ ] T059 Create dashboard mockups/design reference (if not already done)
  - **Description**: Ensure UI designers/team have reference design for dashboard (Figma, Sketch, or similar) aligned with spec.
  - **Acceptance Criteria**:
    - ✓ Design reference available and linked in spec
    - ✓ All UI components shown (header, metrics, active task, task list, states)
    - ✓ Color palette, typography, spacing aligned with app theme
    - ✓ Responsive breakpoints shown (mobile, tablet if applicable)
  - **Dependencies**: Spec review
  - **Effort**: M (if design needed; skip if design already exists)

- [ ] T060 Create API integration task for backend team (if separate)
  - **Description**: Document API contracts and share with backend team for implementation (if they haven't already).
  - **File**: `docs/dashboard-api-contracts.md`
  - **Acceptance Criteria**:
    - ✓ All endpoints documented: GET /api/v1/dashboard, POST pause/complete/start, GET search/filter
    - ✓ Request/response schemas with examples
    - ✓ Error responses documented
    - ✓ Authenticated backend team ready to implement
  - **Dependencies**: Plan review
  - **Effort**: S

---

# Task Statistics & Planning

## By Phase

| Phase | Name | Tasks | Est. Points | Duration |
|-------|------|-------|-------------|----------|
| 1 | Core Setup & Architecture | 16 | 15-18 | 1 week |
| 2 | Active Task & Timer | 12 | 13-16 | 1 week |
| 3 | Task List, Search & Filter | 14 | 12-15 | 1 week |
| 4 | Polish, Offline, Testing | 15 | 16-20 | 1 week |
| Cross-cutting | CI/CD, Design, API | 3 | 3-5 | Ongoing |
| **TOTAL** | | **60** | **59-74** | **4 weeks (MVP)** |

## By User Story

| User Story | Tasks | Est. Points |
|------------|-------|-------------|
| **US1: Home Screen Layout** (Phase 1) | T001-T016 | 15-18 |
| **US2: Active Task + Timer** (Phases 1-2) | T009, T017-T028 | 17-22 |
| **US3: Task List, Search, Filter** (Phases 1,3) | T029-T042 | 12-15 |
| **US4: Loading/Error/Empty States** (All phases) | T012, T013, T023, T039, T046, T048 | Distributed |

## By Team Member (Suggested Distribution)

- **Frontend Lead** (A): Phases 1-2 (structure, entities, providers, core widgets)
- **Frontend Developer 1** (B): Phase 3 (task list, search, filters, pagination)
- **Frontend Developer 2** (C): Phase 4 (offline sync, error handling, animations, polish)
- **QA/Testing Lead** (D): Testing tasks (T051-T053), integration tests, CI/CD

## MVP (Minimum Viable Product) Scope

**Release 1** (Weeks 1-2): Phases 1 & 2
- ✓ Home screen with header, metrics
- ✓ Active task with live timer
- ✓ Pause, complete, start task actions
- ✓ Loading and error states
- ✓ Basic offline queueing (no sync yet)

**Release 2** (Weeks 3-4): Phases 3 & 4
- ✓ Task list with search and filters
- ✓ Pagination (20 items/page)
- ✓ Complete offline sync
- ✓ Performance optimization
- ✓ Full test coverage

---

# Dependencies & Blocking

**Critical Path** (longest dependency chain):
1. T002 → T003 → T004 → T006 → T007 → T008 → T009 → T014 (Phase 1 foundation)
2. T009 → T017 → T018 → T027 (Phase 2 timer logic)
3. T008 → T034 → T035 → T036 → T037 (Phase 3 filtering)
4. T045 → T046 → T048 (Phase 4 offline/error handling)

**Parallelizable Tasks** (marked [P]):
- Domain entities (T002) can run parallel with models (T003)
- Use cases (T007) can develop parallel with providers (T008)
- Widgets (T010, T011, T012, T013, T030, T031, T032) largely parallel
- Tests (T015, T028, T042, T051, T052, T053) can run parallel once code completed

---

# Acceptance & Quality Gates

### Phase 1 Gate
- ✓ All T001-T016 complete
- ✓ Test coverage ≥75% (domain, data, models)
- ✓ Code review: constitution compliance, naming conventions
- ✓ Manual QA: header and metrics render with mock data, loading/error states work

### Phase 2 Gate
- ✓ All T017-T028 complete
- ✓ Test coverage ≥75% (timer, actions, use cases)
- ✓ Manual QA: timer updates 1x/sec, pause/complete/start actions work, UI updates smoothly
- ✓ Performance test: no lag, app doesn't freeze on action

### Phase 3 Gate
- ✓ All T029-T042 complete
- ✓ Test coverage ≥75% (list, search, filters)
- ✓ Manual QA: search/filter work reactively, pagination loads 20 items at a time, "Load More" works, empty states display
- ✓ Performance test: scrolling smooth with 100+ tasks

### Phase 4 Gate (Release Ready)
- ✓ All T043-T057 complete
- ✓ Test coverage ≥80% (overall, unit), ≥60% (widget)
- ✓ Integration tests: all 4 user journeys passing
- ✓ Offline mode: actions queue, sync works, feedback shown
- ✓ Error handling: all error scenarios handled gracefully
- ✓ Performance: dashboard loads <3 sec, animations smooth
- ✓ Code quality: zero lint errors, full Constitution compliance
- ✓ Documentation: README, architecture doc, API contracts
- ✓ Manual QA on real device: all features working
- ✓ **Ready for app store or internal deployment**

---

## Notes

- **Effort estimates** are based on Flutter/Dart development experience; adjust per team velocity.
- **Dependencies** can be managed via Git branches and PRs for parallel development.
- **Testing strategy** integrates unit, widget, and integration tests per Constitution §9.
- **Offline-first approach** (per Constitution §2.2) is core to Phase 2-4, not added as afterthought.
- **Performance targets** (SC-001: <3 sec load) must be validated against real devices and network conditions.
- **MVP scope** allows shipping Phases 1-2 first for user feedback before Phases 3-4.
- **Future enhancements**: Real API integration, advanced caching strategies, biometric auth, offline conflict resolution.
