# Feature Specification: Dashboard (Home) Module

**Feature Branch**: `002-dashboard-home`  
**Created**: 2026-03-13  
**Status**: Draft  
**Input**: User description: "Feature: Dashboard (Home) module for InTimePro mobile app. As an employee, I want a Home/Dashboard screen after login so that I can see my profile, today's time metrics (clock-in time, active time, time at work), my currently active task with a live timer and pause/complete actions, and a searchable/filterable list of my tasks (New, In Progress, Overdue, Complete) with per-task timers and quick actions (start/complete). The screen should have a header with user name, role, and online status; a bottom navigation bar with Home, Activities, Projects, and Notifications. Include loading, empty, and error states; assume authenticated access only. Primary user: Employee."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Home Screen Layout and Profile Summary (Priority: P1)

As an employee, I want to land on a Home/Dashboard screen after login so that I can immediately see my profile (name, role, online status), today's time metrics, and the main structure of the screen.

**Why this priority**: Core post-login experience; defines the primary landing view and establishes trust that I am in the right context.

**Independent Test**: Can be tested by logging in and verifying the Home screen displays the header (name, role, online status), today's time metrics (clock-in time, active time, time at work), and the bottom navigation bar with Home, Activities, Projects, and Notifications.

**Acceptance Scenarios**:

1. **Given** I am authenticated, **When** I navigate to or land on the Home screen, **Then** I see a header showing my display name, my role (e.g. Frontend Developer), and my online status (e.g. Online) with an indicator (e.g. green dot) and optional dropdown.
2. **Given** I am on the Home screen, **When** the screen loads, **Then** I see today's time metrics: clock-in time (e.g. 09:37 am), active time (e.g. 02:17 hrs), and time at work (e.g. 03:09 hrs).
3. **Given** I am on the Home screen, **When** I look at the bottom of the screen, **Then** I see a bottom navigation bar with: Home (selected), Activities, Projects, and Notifications; tapping each navigates to the corresponding section.
4. **Given** I am authenticated, **When** the Home screen is loading, **Then** I see a loading state (e.g. skeleton or spinner) until data is ready; I do not see a blank or broken layout.

---

### User Story 2 - Currently Active Task with Live Timer and Actions (Priority: P1)

As an employee, I want to see my currently active task with a live timer and pause/complete actions so that I can track time and control the task without leaving the Home screen.

**Why this priority**: Central to time-tracking workflow; the active task is the primary focus when the user has one.

**Independent Test**: Can be tested by having an active task and verifying the Home screen shows the task (project name, billable status, description), a live-updating timer, and working pause and complete actions.

**Acceptance Scenarios**:

1. **Given** I have an active task, **When** I am on the Home screen, **Then** I see a prominent card showing: project name, billable/non-billable tag, task description (truncated if long), a live timer showing elapsed time (e.g. 04:18:22), and action buttons for Pause and Complete.
2. **Given** I am viewing the active task card, **When** time passes, **Then** the timer updates in real time (e.g. every second or at a defined interval) without requiring a manual refresh.
3. **Given** I have an active task, **When** I tap Pause, **Then** the task is paused (timer stops or reflects paused state) and the UI updates accordingly (e.g. option to resume).
4. **Given** I have an active task, **When** I tap Complete, **Then** the task is marked complete and the UI updates (e.g. active task area shows empty state or next task).
5. **Given** I have no active task, **When** I am on the Home screen, **Then** the active task area shows an empty state (e.g. message like "No active task" and optionally a prompt to start one from the list).

---

### User Story 3 - Searchable and Filterable Task List (Priority: P2)

As an employee, I want a searchable and filterable list of my tasks by status (New, In Progress, Overdue, Complete) with per-task timers and quick actions (start/complete) so that I can find and manage tasks from the Home screen.

**Why this priority**: Enables discovery and quick actions on all tasks; builds on the active task and layout.

**Independent Test**: Can be tested by opening the task list section, searching, switching filter tabs, and using start/complete on individual tasks.

**Acceptance Scenarios**:

1. **Given** I am on the Home screen, **When** I scroll to or view the task list section, **Then** I see a search field and filter tabs for: New, In Progress, Overdue, and Complete (with counts where applicable, e.g. 9+, 2, 1).
2. **Given** I am viewing the task list, **When** I enter text in the search field, **Then** the list is filtered to show only tasks matching the search (e.g. by project name or task description).
3. **Given** I am viewing the task list, **When** I tap a filter tab (e.g. In Progress), **Then** the list shows only tasks in that status and the selected tab is visually indicated.
4. **Given** the list shows tasks, **When** I view a task card, **Then** I see: project name, billable/non-billable tag, task description (truncated), elapsed time (if any), and quick actions: Start (or Resume) and Complete.
5. **Given** a task is in a startable state (e.g. New), **When** I tap Start, **Then** that task becomes the active task and the timer begins (or resumes); the active task card and list update.
6. **Given** a task is in progress or listed, **When** I tap Complete on that task card, **Then** the task is marked complete and the list/active area update accordingly.
7. **Given** I have no tasks in the selected filter or search, **When** I view the list, **Then** I see an empty state (e.g. "No tasks found" or "No tasks in this status") rather than a blank area.

---

### User Story 4 - Loading, Empty, and Error States (Priority: P2)

As an employee, I want clear loading, empty, and error states on the Home screen so that I always understand what is happening and what to do next.

**Why this priority**: Ensures a predictable and trustworthy UX when data is loading, missing, or failed.

**Independent Test**: Can be tested by simulating slow load, no data (no tasks, no active task), and network/API errors and verifying appropriate states are shown.

**Acceptance Scenarios**:

1. **Given** the Home screen is fetching profile, time metrics, or tasks, **When** data is not yet available, **Then** I see a loading state (e.g. skeletons, spinners, or placeholders) for the relevant sections; I do not see raw errors or blank content without indication.
2. **Given** I have no tasks at all, **When** I view the task list, **Then** I see an empty state (e.g. "You have no tasks" or similar) with optional guidance (e.g. "Tasks will appear when assigned").
3. **Given** I have no active task, **When** I view the active task area, **Then** I see an empty state (e.g. "No active task" with option to start from list) rather than a broken or missing block.
4. **Given** profile, time metrics, or task data fails to load (e.g. network error, server error), **When** the error occurs, **Then** I see an error state with a clear message (e.g. "Unable to load. Please try again.") and, where appropriate, a retry action; I do not see a permanent loading state or a crash.
5. **Given** I see an error state, **When** I tap Retry (if offered), **Then** the app attempts to reload the failed data and shows loading then success or error again.

---

### Edge Cases

- What happens when the user has no clock-in today? The time metrics should show an appropriate empty or default value (e.g. "—" or "Not clocked in") and not break the layout.
- What happens when the user has many tasks and the list is long? The list should be scrollable; search and filters reduce the visible set; performance remains acceptable (e.g. no visible lag when scrolling or filtering).
- What happens when the user starts a second task without pausing or completing the first? The system should either prevent starting another (one active task only) or define behavior (e.g. auto-pause first, or replace active); the spec assumes one active task at a time unless product says otherwise.
- What happens when the timer is running and the app goes to background or the device sleeps? The app should continue to account for elapsed time (e.g. via server sync or local calculation on resume) so the active task timer remains accurate when the user returns.
- What happens when the user's session expires while on the Home screen? The app should detect expired/invalid auth, clear the session, and redirect to login with an appropriate message (e.g. "Session expired. Please log in again.").
- What happens when online status cannot be determined (e.g. offline)? The header should show a sensible state (e.g. "Offline" or "Unknown") and not leave the status blank or misleading.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST show a Home/Dashboard screen as the default post-login landing view for an authenticated employee.
- **FR-002**: The Home screen MUST display a header with the authenticated user's display name, role, and online status (with visual indicator and optional dropdown).
- **FR-003**: The Home screen MUST display today's time metrics: clock-in time, active time, and time at work (with appropriate values or placeholders when data is missing).
- **FR-004**: The Home screen MUST display the user's currently active task (when one exists), including project name, billable/non-billable indicator, task description (truncated as needed), and a live-updating elapsed timer.
- **FR-005**: The system MUST provide Pause and Complete actions for the currently active task; Pause MUST pause the task timer and Complete MUST mark the task complete and update the UI.
- **FR-006**: The Home screen MUST display a list of the user's tasks with filter tabs for status: New, In Progress, Overdue, and Complete; counts per tab MAY be shown where available.
- **FR-007**: The task list MUST support search (e.g. by project name or task description) so that the list updates to show only matching tasks.
- **FR-008**: Each task in the list MUST show project name, billable/non-billable tag, task description (truncated), elapsed time (if applicable), and quick actions: Start (or Resume) and Complete, as applicable to task status.
- **FR-009**: The system MUST provide a bottom navigation bar with: Home, Activities, Projects, and Notifications; Home MUST be selectable and indicate the current screen when on Dashboard; tapping each item MUST navigate to the corresponding section.
- **FR-010**: The Home screen MUST show a loading state while profile, time metrics, or task data is being fetched; the user MUST NOT see a blank or broken layout during load.
- **FR-011**: The Home screen MUST show an empty state when there is no active task (e.g. "No active task" with optional guidance).
- **FR-012**: The Home screen MUST show an empty state when the task list (or filtered/search result) has no tasks (e.g. "No tasks" or "No tasks in this status").
- **FR-013**: When profile, time metrics, or task data fails to load (e.g. network or server error), the system MUST show an error state with a clear message and, where appropriate, a retry action.
- **FR-014**: The active task timer MUST update in real time (e.g. every second or at a defined interval) while the task is active and the user is on the Home screen.
- **FR-015**: Access to the Home/Dashboard screen MUST be restricted to authenticated users only; unauthenticated users MUST be redirected to login.

### Key Entities

- **Employee / User profile**: Display name, role (e.g. Frontend Developer), online status; used in the header. Sourced from authenticated session and/or profile API.
- **Today's time metrics**: Clock-in time (when the user clocked in today), active time (time spent in active task(s)), time at work (total time at work today). May be computed or provided by backend.
- **Task**: Represents a work item; has project name, billable/non-billable status, description, status (New, In Progress, Overdue, Complete), and elapsed time; may be the currently active task or an item in the list.
- **Active task**: The single task currently being timed; has a live timer and pause/complete actions.
- **Navigation item**: Home, Activities, Projects, Notifications; used in the bottom navigation bar for app-level navigation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: An authenticated employee can land on the Home screen after login and see profile (name, role, online status), today's time metrics, and bottom navigation within 3 seconds under normal conditions.
- **SC-002**: When the user has an active task, the elapsed timer on the Home screen updates in real time and pause/complete actions work without requiring a full screen refresh.
- **SC-003**: The user can search and filter the task list and see results update; start and complete actions on list items correctly update the active task and list.
- **SC-004**: Loading states are visible during data fetch; empty states are shown when there is no active task or no tasks in the list/filter; error states are shown on load failure with a retry option where appropriate.
- **SC-005**: The user can navigate from the Home screen to Activities, Projects, and Notifications via the bottom navigation bar; Home is clearly indicated when on the Dashboard.
- **SC-006**: Unauthenticated access to the Home/Dashboard is blocked and redirected to login; no Dashboard data is exposed without a valid session.

## Assumptions

- The user is already authenticated; login and auth flows are out of scope for this spec (covered by User Authentication spec).
- Profile data (name, role), online status, today's time metrics, and task list (including active task) are provided by backend APIs or equivalent; exact contracts are defined elsewhere.
- At most one task is "active" (being timed) at a time; starting a new task either requires completing/pausing the current one or the system auto-pauses/replaces per product rules.
- Bottom navigation items (Activities, Projects, Notifications) are separate modules; this spec only requires that the Home screen includes the nav bar and that tapping those items navigates to the correct destination (implementation of those screens is out of scope).
- Hamburger or other header menu (if present in the design) is for future or separate spec unless explicitly required; the spec focuses on the described header and bottom nav.
- Design reference: Header with name, role, online status; time metrics (clock-in, active time, time at work); prominent active task card with timer and pause/complete; task list with search, status tabs, and per-task start/complete, aligned with the provided InTimePro Home screen design.
