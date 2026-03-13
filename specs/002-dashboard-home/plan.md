# Implementation Plan: Dashboard (Home) Module

**Feature Branch**: `002-dashboard-home`  
**Created**: 2026-03-13  
**Status**: Draft  
**Architecture**: Flutter (Dart) - Clean Architecture + MVVM  
**State Management**: Riverpod (chosen for reactive, declarative state)

---

## 1. Technical Context

### Framework & Ecosystem
- **Language**: Dart with null safety enabled
- **Framework**: Flutter
- **State Management**: Riverpod (for dependency injection, reactive state, and provider-based architecture)
- **Design Pattern**: MVVM (Model-View-ViewModel) + Clean Architecture
- **Database**: SQLite (via sqflite) for local task and time metric caching
- **API Layer**: REST API with Bearer token authentication (via existing auth service)
- **Data Synchronization**: Offline-first with eventual sync (per constitution §2.2)

### Architecture Layers
- **Presentation**: Screens and widgets using Riverpod notifiers for state management
- **Domain**: Entities, use cases (application services), and repository interfaces
- **Data**: Repository implementations, API clients, local database, and DTOs/mappers

### Integration Points
- **Auth Service**: Reuse existing authenticated session and token management
- **API Service**: Reuse existing REST client for profile, time metrics, and task data
- **Navigation**: Integrate with existing bottom navigation bar structure (Home, Activities, Projects, Notifications)
- **Theme**: Use existing theme system for consistency (colors, typography, spacing)

---

## 2. Constitution Check

**Alignment with InTimePro Constitution (v1.1.0)**:

- **§1 Project Vision**: Dashboard aligns with "Employee Productivity and Time Tracking" vision—core landing screen post-login.
- **§2.1 User-First**: Feature designed for employee workflow (clock-in, active task, task list, quick actions).
- **§2.2 Offline-Capable**: Active task timer, task state, and metrics cached locally; sync on reconnection.
- **§2.3 Consistency with Desktop**: Terminology and data model (active task, task status, time metrics) match desktop system.
- **§3 Architecture Standards**: Follows Clean Architecture + MVVM; layers properly separated; Riverpod for presentation.
- **§5 Folder Structure**: Feature-based structure with data, domain, and presentation sub-layers.
- **§6 UI/UX Guidelines**: Loading states (skeletons), error states (with retry), empty states, bottom navigation integration planned.
- **§8 State Management**: Riverpod notifiers for dashboard state, stream-based reactive updates for timer.
- **§12 Naming Conventions**: All file names snake_case, classes PascalCase, functions/vars camelCase; suffixes: *ViewModel, *Repository, *UseCase, *Screen.
- **§13 Performance**: List optimization via ListView.builder, real-time timer via Riverpod stream providers.

**No violations identified.** Dashboard design is compliant with constitution.

---

## 3. Feature Structure

### Folder Layout

```
lib/features/dashboard/
├── data/
│   ├── datasources/
│   │   └── dashboard_local_datasource.dart      # SQLite caching for metrics/tasks
│   ├── models/
│   │   ├── active_task_model.dart               # DTO for active task
│   │   ├── task_list_model.dart                 # DTO for task in list
│   │   ├── time_metrics_model.dart              # DTO for today's time metrics
│   │   └── employee_profile_model.dart          # DTO for user profile
│   ├── repositories/
│   │   └── dashboard_repository_impl.dart       # Implementation of dashboard repository
│   └── mappers/
│       └── dashboard_mapper.dart                # DTO ↔ Entity mapping
├── domain/
│   ├── entities/
│   │   ├── active_task.dart
│   │   ├── task.dart
│   │   ├── time_metrics.dart
│   │   └── employee_profile.dart
│   ├── repositories/
│   │   └── dashboard_repository.dart            # Abstract interface
│   └── usecases/
│       ├── get_dashboard_data_usecase.dart       # Fetch profile + metrics + tasks
│       ├── pause_active_task_usecase.dart
│       ├── complete_active_task_usecase.dart
│       ├── start_task_usecase.dart
│       ├── search_tasks_usecase.dart
│       └── filter_tasks_by_status_usecase.dart
├── presentation/
│   ├── pages/
│   │   └── dashboard_screen.dart                # Main dashboard screen
│   ├── widgets/
│   │   ├── header_widget.dart                   # User profile header
│   │   ├── time_metrics_widget.dart             # Today's metrics (clock-in, active, total)
│   │   ├── active_task_card.dart                # Prominent active task display with timer
│   │   ├── task_list_widget.dart                # Searchable/filterable task list
│   │   ├── task_item_widget.dart                # Individual task card in list
│   │   ├── task_filter_tabs.dart                # Status filter tabs (New, In Progress, Overdue, Complete)
│   │   ├── search_field_widget.dart             # Search input for tasks
│   │   ├── empty_state_widget.dart              # Reusable empty state (no active task, no tasks)
│   │   ├── loading_state_widget.dart            # Reusable loading skeleton
│   │   └── error_state_widget.dart              # Reusable error display with retry
│   └── viewmodels/
│       └── dashboard_viewmodel.dart             # Riverpod notifier for dashboard state
└── test/
    ├── domain/
    │   └── usecases/                            # Unit tests for use cases
    ├── data/
    │   └── repositories/                        # Unit tests for repository impl
    └── presentation/
        └── widgets/                             # Widget tests for key components

```

### Shared/Core Integration

```
lib/shared/
├── widgets/
│   └── bottom_navigation_bar.dart               # Reuse existing bottom nav (Home, Activities, Projects, Notifications)

lib/core/
├── constants/
│   └── dashboard_constants.dart                 # Timers, thresholds, UI constants
├── extensions/
│   └── duration_extension.dart                  # Format duration for display (HH:MM:SS)
└── theme/
    └── dashboard_theme.dart                     # Color, typography overrides for dashboard (if any)
```

---

## 4. Key Entities & Data Model

### Domain Entities

**EmployeeProfile**
```dart
class EmployeeProfile {
  final String id;
  final String displayName;
  final String role;
  final OnlineStatus onlineStatus; // Online, Offline, Away, etc.
  final String? avatarUrl;
}

enum OnlineStatus { online, offline, away, doNotDisturb }
```

**TimeMetrics**
```dart
class TimeMetrics {
  final DateTime? clockInTime;       // When user clocked in today
  final Duration activeTime;         // Time spent in active task(s)
  final Duration totalTimeAtWork;    // Total time at work today
  final DateTime? clockOutTime;      // When user clocked out (if applicable)
}
```

**Task**
```dart
class Task {
  final String id;
  final String projectName;
  final String description;
  final TaskStatus status; // New, InProgress, Overdue, Complete
  final bool isBillable;
  final Duration? elapsedTime;    // If task has been started
  final bool isActive;            // True if this is the currently active task
  final DateTime? startedAt;
  final DateTime? completedAt;
}

enum TaskStatus { new, inProgress, overdue, complete }
```

**ActiveTask (Specialized)**
```dart
class ActiveTask extends Task {
  final Timer? liveTimer;  // In-memory timer for UI updates
  final bool isPaused;
}
```

### Data Models (DTOs)

DTOs will mirror entities with JSON serialization for API responses and local caching. Example:

```dart
class TaskModel {
  final String id;
  final String projectName; 
  final String description;
  final String status; // API uses string; mapper converts to enum
  final bool isBillable;
  final int? elapsedSeconds;
  final bool isActive;
  
  // JSON factory and toJson for serialization
}
```

---

## 5. API Contracts

### Assumed Endpoints

**Get Dashboard Data** (composite fetch)
```
GET /api/v1/dashboard
Headers: Authorization: Bearer {token}
Response:
{
  "employee": {
    "id": "emp123",
    "displayName": "John Doe",
    "role": "Frontend Developer",
    "onlineStatus": "online",
    "avatarUrl": "https://..."
  },
  "timeMetrics": {
    "clockInTime": "2026-03-13T09:37:00Z",
    "activeTime": 8100,        // seconds (2 hrs 15 min)
    "totalTimeAtWork": 11160,  // seconds (3 hrs 6 min)
    "clockOutTime": null
  },
  "activeTask": {
    "id": "task123",
    "projectName": "Mobile App Redesign",
    "description": "Update home screen UI",
    "status": "in_progress",
    "isBillable": true,
    "elapsedSeconds": 15300,   // 4 hrs 15 min
    "isActive": true,
    "startedAt": "2026-03-13T09:45:00Z"
  },
  "tasks": [
    {
      "id": "task124",
      "projectName": "Backend API",
      "description": "Fix user endpoint",
      "status": "new",
      "isBillable": false,
      "elapsedSeconds": null,
      "isActive": false,
      "startedAt": null
    },
    ...
  ]
}
```

**Pause Active Task**
```
POST /api/v1/tasks/{taskId}/pause
Headers: Authorization: Bearer {token}
Response: { "status": "paused", "pausedAt": "2026-03-13T14:30:00Z" }
```

**Complete Task**
```
POST /api/v1/tasks/{taskId}/complete
Headers: Authorization: Bearer {token}
Response: { "status": "complete", "completedAt": "2026-03-13T14:35:00Z" }
```

**Start/Resume Task**
```
POST /api/v1/tasks/{taskId}/start
Headers: Authorization: Bearer {token}
Response: { "status": "in_progress", "startedAt": "2026-03-13T14:36:00Z" }
```

**Search/Filter Tasks**
```
GET /api/v1/tasks?status={status}&search={query}&limit=20&offset=0
Headers: Authorization: Bearer {token}
Response: { "tasks": [...], "total": 42 }
```

---

## 6. State Management (Riverpod)

### Providers

**1. Dashboard Data Provider** (Async)
```dart
final dashboardProvider = FutureProvider.autoDispose<DashboardState>((ref) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  return repo.getDashboardData();
});
```

**2. Active Task Timer Stream** (Real-time updates)
```dart
final activeTaskTimerProvider = StreamProvider.autoDispose<Duration>((ref) async* {
  // Emits updated elapsed time every second while task is active
  // Listens to active task state and updates timer
});
```

**3. Task Filter State** (Notifier)
```dart
final taskFilterProvider = StateNotifierProvider<TaskFilterNotifier, TaskFilterState>((ref) {
  return TaskFilterNotifier();
});

class TaskFilterNotifier extends StateNotifier<TaskFilterState> {
  // Manages selected filter (All, New, InProgress, Overdue, Complete)
  // Manages search query
}
```

**4. Filtered Tasks Provider** (Derived)
```dart
final filteredTasksProvider = Provider.autoDispose<List<Task>>((ref) {
  final allTasks = ref.watch(dashboardProvider).maybeWhen(
    data: (data) => data.tasks,
    orElse: () => [],
  );
  final filter = ref.watch(taskFilterProvider);
  
  return allTasks
    .where((task) => _matchesFilter(task, filter))
    .toList();
});
```

**5. Action Providers** (Methods)
```dart
final pauseActiveTaskProvider = FutureProvider.family<void, String>((ref, taskId) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  await repo.pauseActiveTask(taskId);
  // Invalidate dashboard provider to refresh
  ref.refresh(dashboardProvider);
});

// Similarly: completeTaskProvider, startTaskProvider
```

---

## 7. ViewModel

The **DashboardViewModel** (implemented as a FutureProvider or StreamNotifier) holds:

- Dashboard state (profile, time metrics, active task, task list)
- Loading and error states
- Derived state (is loading, has error, errors message)
- Actions (pause, complete, start task, filter, search)

```dart
class DashboardViewModel extends StateNotifier<DashboardState> {
  final DashboardRepository _repo;
  
  DashboardViewModel(this._repo) : super(DashboardState.initial());
  
  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await _repo.getDashboardData();
      state = DashboardState(
        isLoading: false,
        profile: data.profile,
        timeMetrics: data.timeMetrics,
        activeTask: data.activeTask,
        tasks: data.tasks,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  Future<void> pauseActiveTask() async { ... }
  Future<void> completeActiveTask() async { ... }
  Future<void> startTask(String taskId) async { ... }
}

class DashboardState {
  final bool isLoading;
  final EmployeeProfile? profile;
  final TimeMetrics? timeMetrics;
  final ActiveTask? activeTask;
  final List<Task> tasks;
  final String? error;
  
  DashboardState({...});
}
```

---

## 8. Use Cases

**GetDashboardDataUseCase**
- Input: None (uses authenticated session)
- Output: Combined dashboard data (profile, metrics, active task, task list)
- Process: Calls repository, handles caching/sync

**PauseActiveTaskUseCase**
- Input: Task ID
- Output: Paused task state
- Process: Calls repository to pause, invalidates active task in cache

**CompleteActiveTaskUseCase**
- Input: Task ID
- Output: Completed task state
- Process: Calls repository to complete, updates dashboard state

**StartTaskUseCase**
- Input: Task ID
- Output: Active task state
- Process: Calls repository to start/resume, becomes new active task

**SearchTasksUseCase**
- Input: Search query, optional status filter
- Output: Filtered list of tasks
- Process: Local filtering (already loaded tasks) + API search for fresh results

**FilterTasksByStatusUseCase**
- Input: Task status (New, InProgress, Overdue, Complete)
- Output: Filtered list of tasks
- Process: Local filtering of loaded tasks

---

## 9. Data Flow

### Initial Load Flow
```
DashboardScreen
  → initState() / mounted check
    → loadDashboard() [via ViewModel/Riverpod]
      → API: GET /api/v1/dashboard
        ← Response: { profile, timeMetrics, activeTask, tasks }
      → Cache to local DB (SQLite)
      → Update ViewModel state
    → UI re-renders with data or loading state
```

### Real-Time Timer Update
```
Active task is shown, timer ticks every 1 second
  → Riverpod StreamProvider emits updated Duration
    → activeTaskTimerProvider listeners notified
      → ActiveTaskCard rebuilds with new elapsed time
```

### Pause/Complete Action Flow
```
User taps Pause/Complete
  → ViewModel action: pauseActiveTask() / completeActiveTask()
    → API: POST /api/v1/tasks/{taskId}/pause or /complete
      ← Response: updated task state
      → Update local cache
      → Refresh dashboard state (invalidate FutureProvider)
    → UI updates: active task area changes or shows empty state
```

### Search & Filter Flow
```
User types in search field or taps filter tab
  → Update TaskFilterState (search query, status filter)
    → filteredTasksProvider recalculates automatically via Riverpod
      → TaskListWidget observes filteredTasksProvider
        → UI re-renders with filtered list
```

---

## 10. Components & Widgets

### Screens
- **DashboardScreen**: Main container; orchestrates header, metrics, active task, task list, error/loading states

### Widgets (Dumb/Presentational)
- **HeaderWidget**: Displays profile (name, role, online status with indicator)
- **TimeMetricsWidget**: Shows clock-in time, active time, total time at work
- **ActiveTaskCard**: Displays active task with live timer and pause/complete buttons
- **TaskListWidget**: Container for search, filter tabs, and task items
- **TaskItemWidget**: Individual task card (project, description, elapsed time, start/complete buttons)
- **TaskFilterTabs**: Clickable tabs for status filtering (New, In Progress, Overdue, Complete)
- **SearchFieldWidget**: Input field for task search
- **EmptyStateWidget**: Reusable "No active task" or "No tasks found" message
- **LoadingStateWidget**: Skeleton loader for dashboard sections
- **ErrorStateWidget**: Error message + retry button

---

## 11. Implementation Phases

### Phase 1: Core Structure & Header (Week 1)
**Tasks**:
- [ ] Set up feature folder structure (data, domain, presentation layers)
- [ ] Define domain entities (EmployeeProfile, TimeMetrics, Task, ActiveTask)
- [ ] Create data models and mappers (DTO → Entity)
- [ ] Implement DashboardRepository interface and basic implementation
- [ ] Create Riverpod providers for dashboard data and state
- [ ] Build HeaderWidget and TimeMetricsWidget (static mockup first)
- [ ] Integrate with existing auth service (verify token passed to API calls)
- [ ] Add loading and error states for header/metrics section

**Deliverable**: Header and time metrics displayed with loader and error handling; data fetched from API mock or test backend

---

### Phase 2: Active Task & Timer (Week 2)
**Tasks**:
- [ ] Build ActiveTaskCard widget (project, description, billable indicator)
- [ ] Implement live timer updates via Riverpod StreamProvider
- [ ] Create pauseActiveTaskUseCase, completeActiveTaskUseCase, startTaskUseCase
- [ ] Wire pause/complete button actions to API calls and state refresh
- [ ] Handle empty state (no active task)
- [ ] Add retry logic on fetch failure
- [ ] Test timer accuracy and lifecycle (app background/foreground, device sleep)

**Deliverable**: Active task displayed with live timer; pause, complete, and start actions working; timer syncs with backend

---

### Phase 3: Task List, Search & Filter (Week 3)
**Tasks**:
- [ ] Build TaskListWidget with ListView.builder (lazy loading)
- [ ] Build TaskItemWidget with start/complete quick actions
- [ ] Implement TaskFilterTabs for status (New, In Progress, Overdue, Complete)
- [ ] Implement SearchFieldWidget and search filtering logic
- [ ] Create filteredTasksProvider to auto-update list on search/filter change
- [ ] Add empty state for no tasks in filter/search
- [ ] Test performance with large task lists (pagination/lazy load if needed)

**Deliverable**: Full task list with search, filter, and quick actions; list updates reactively; empty states shown appropriately

---

### Phase 4: Polish & States (Week 4)
**Tasks**:
- [ ] Refine loading skeletons (polish placeholders)
- [ ] Add transitions and animations (e.g., task card slide-in, state changes)
- [ ] Implement offline caching (SQLite) for task list and metrics
- [ ] Test error scenarios (network failure, session expiry, slow API)
- [ ] Verify bottom navigation integration (Home tab highlights, navigation works)
- [ ] Performance optimization: profile large task lists, optimize rebuilds
- [ ] Unit tests: use cases, repository, mappers
- [ ] Widget tests: HeaderWidget, ActiveTaskCard, TaskItemWidget
- [ ] Integration tests: Full dashboard flow (load → interact → state change)

**Deliverable**: Polish dashboard with animations, offline support, comprehensive error handling, full test coverage

---

## 12. Dependencies & External Services

### Riverpod Packages
- `riverpod` — Main state management
- `riverpod_generator` — Code generation for providers
- `flutter_riverpod` — Flutter integration

### HTTP & Serialization
- `dio` — HTTP client (likely already used by existing API service)
- `json_serializable` — JSON serialization for models

### Local Storage
- `sqflite` — SQLite for local caching
- `shared_preferences` — Simple key-value storage for preferences

### Utilities
- `intl` — Date/time formatting ("09:37 am", durations)
- `logger` — Structured logging (per constitution §14)

### Existing Services (Reuse)
- Auth service (token management, session)
- API client (base URL, interceptors, token injection)
- Navigation service (bottom nav integration)
- Theme system (colors, typography)

---

## 13. Edge Cases & Resilience

### No Clock-In Today
- TimeMetrics shows "—" or "Not clocked in" gracefully
- Layout does not break

### No Active Task
- ActiveTaskCard shows empty state ("No active task" with optional prompt)
- Task list is primary focus

### Many Tasks (100+)
- ListView.builder ensures only visible tasks are rendered
- Search/filter reduces visible set
- Consider pagination if first load is slow

### Timer Accuracy
- Use local calculation when app is in background (track start time, calculate on return)
- Sync with server periodically to correct drift
- Handle timezone changes (unlikely but possible)

### Session Expiry
- Auth service should intercept 401 responses and redirect to login
- Dashboard gracefully shows error state, not a crash

### Offline Mode
- Last fetched data cached locally; user sees cached state with "offline" badge
- Actions (pause, complete, start) queued locally and synced on reconnection
- Clear indication to user that actions may not sync until online

### Multiple Tabs/Instances
- If user logs in on another device, session expires on this device; handled by auth interceptor
- Deep linking to dashboard should check auth first

---

## 14. Testing Strategy

### Unit Tests (Domain & Data)
- GetDashboardDataUseCase: Returns correctly mapped entities
- PauseActiveTaskUseCase: Calls repository, returns paused state
- Task filtering logic: Correctly filters by status and search query
- Data mappers: DTO → Entity and vice versa

### Widget Tests
- DashboardScreen loads and displays header
- TimeMetricsWidget displays clock-in, active time, total time
- ActiveTaskCard displays task info and timer updates every second
- TaskListWidget renders task items and responds to start/complete
- Empty and error states display correctly with retry button

### Integration Tests
- Full flow: Login → Dashboard loads → View active task → Pause → Complete → View task list → Search

---

## 15. Success Criteria (Checklist)

- [x] Architecture follows Clean Architecture + MVVM pattern (per constitution)
- [x] Feature-based folder structure implemented
- [x] All data models and entities defined
- [x] API contracts documented (mock endpoints for reference)
- [x] Riverpod providers set up for state management
- [x] Core widgets identified and component hierarchy clear
- [x] Use cases defined for all major actions
- [x] Data flow diagrams (text-based) provided
- [x] Implementation phased into 4 weeks with clear deliverables
- [x] Edge cases identified and mitigation strategies outlined
- [x] Testing strategy defined (unit, widget, integration)
- [x] Offline caching and sync strategy documented
- [x] Timer accuracy and background handling addressed
- [x] Dependencies listed and reuse of existing services confirmed
- [x] Naming conventions align with constitution §12

---

## 16. Appendix: File Checklist

### Domain Layer
- [ ] `active_task.dart` — ActiveTask entity
- [ ] `task.dart` — Task entity
- [ ] `time_metrics.dart` — TimeMetrics entity
- [ ] `employee_profile.dart` — EmployeeProfile entity
- [ ] `dashboard_repository.dart` — Repository interface
- [ ] `get_dashboard_data_usecase.dart`
- [ ] `pause_active_task_usecase.dart`
- [ ] `complete_active_task_usecase.dart`
- [ ] `start_task_usecase.dart`
- [ ] `search_tasks_usecase.dart`
- [ ] `filter_tasks_by_status_usecase.dart`

### Data Layer
- [ ] `active_task_model.dart`
- [ ] `task_list_model.dart`
- [ ] `time_metrics_model.dart`
- [ ] `employee_profile_model.dart`
- [ ] `dashboard_repository_impl.dart`
- [ ] `dashboard_mapper.dart`
- [ ] `dashboard_local_datasource.dart`

### Presentation Layer
- [ ] `dashboard_screen.dart`
- [ ] `dashboard_viewmodel.dart` (Riverpod notifier)
- [ ] `header_widget.dart`
- [ ] `time_metrics_widget.dart`
- [ ] `active_task_card.dart`
- [ ] `task_list_widget.dart`
- [ ] `task_item_widget.dart`
- [ ] `task_filter_tabs.dart`
- [ ] `search_field_widget.dart`
- [ ] `empty_state_widget.dart`
- [ ] `loading_state_widget.dart`
- [ ] `error_state_widget.dart`

### Tests
- [ ] Unit tests for use cases
- [ ] Unit tests for repository
- [ ] Unit tests for mappers
- [ ] Widget tests for key screens/widgets
- [ ] Integration tests for critical flow

---

## Notes

- This plan assumes Riverpod is chosen for state management (per project decision). If Bloc is chosen instead, adapt providers to Bloc notifiers/events.
- API endpoints are assumed based on common REST patterns; actual endpoints must be confirmed with backend team.
- Performance assumptions (3-second load, scrolling without lag) should be measured post-implementation and optimized if needed (see constitution §13).
- The plan is structured to allow parallel development (e.g., Phase 1 UI and Phase 2 timer can overlap with Phase 3 list features).
