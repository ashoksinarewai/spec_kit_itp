# Sync Tasks & User Stories to GitHub

**Feature**: 001-user-auth  
**Repo**: [spec_kit_itp](https://github.com/ashoksinarewai/spec_kit_itp)

This document and the script below sync **tasks** from `tasks.md` and **user stories** from `spec.md` to GitHub Issues so you can track work and link PRs.

---

## Option 1: Use the script (recommended)

**Prerequisites**: [GitHub CLI (`gh`)](https://cli.github.com/) installed and authenticated (`gh auth login`).

From the **repository root**:

```powershell
.\specs\001-user-auth\scripts\sync-tasks-to-github.ps1
```

The script will:

1. Create labels: `feature/001-user-auth`, `phase: setup`, `phase: foundational`, `phase: us1` … `phase: us8`, `user-story: US1` … `user-story: US5`, `priority: P1`, `priority: P2`.
2. Create **5 User Story issues** (epics) with titles and bodies from the spec.
3. Create **41 Task issues** (T001–T041) with title, body, and labels for phase + user story.

---

## Option 2: Create issues manually

Use the tables below in the GitHub Issues UI (New issue) or run individual `gh issue create` commands.

### User stories (create these first as epics)

| # | Title | Labels | Body summary |
|---|--------|--------|---------------|
| US1 | [US1] Email and Password Login (P1) MVP | `user-story: US1`, `priority: P1`, `feature/001-user-auth` | As an employee, I want to log in with email and password so that I can access the InTimePro app. Independent Test: valid credentials → Dashboard; invalid → error; network off → notified; password masked. |
| US2 | [US2] Remember Me (P2) | `user-story: US2`, `priority: P2`, `feature/001-user-auth` | As an employee, I want "Remember Me" so I stay logged in on this device. Independent Test: Remember Me on → reopen → Dashboard; off → reopen → Login; tokens stored securely. |
| US3 | [US3] Forgot Password (P2) | `user-story: US3`, `priority: P2`, `feature/001-user-auth` | As an employee, I want to reset my password via "Forgot Password" and receive reset link/OTP. Independent Test: generic success/error; no account enumeration. |
| US4 | [US4] Social Login – Microsoft & Google (P2) | `user-story: US4`, `priority: P2`, `feature/001-user-auth` | As an employee, I want to log in with Microsoft or Google. Independent Test: success → Dashboard; cancel/fail → login + message; only tokens stored. |
| US5 | [US5] Error Handling and Security (P1) | `user-story: US5`, `priority: P1`, `feature/001-user-auth` | Clear feedback when login fails; credentials and session handled securely. Independent Test: error messages; password masked; tokens secure; no credentials in logs. |

Full text for each user story is in `spec.md` (User Scenarios & Testing).

### Task → User Story mapping

| Phase | Task IDs | User Story label |
|-------|----------|------------------|
| Phase 1: Setup | T001–T003 | — |
| Phase 2: Foundational | T004–T014 | — |
| Phase 3 | T015–T020 | US1 |
| Phase 4 | T021–T024 | US2 |
| Phase 5 | T025–T028 | US3 |
| Phase 6 | T029–T034 | US4 |
| Phase 7 | T035–T038 | US5 |
| Phase 8: Polish | T039–T041 | — |

---

## Option 3: Use `/speckit.taskstoissues` (when GitHub MCP is enabled)

The SpecKit command **`/speckit.taskstoissues`** creates GitHub issues from `tasks.md` via the GitHub MCP server. If your Cursor environment has the GitHub MCP configured and the `issue_write` (or `create_issue`) tool available, run:

```
/speckit.taskstoissues
```

That will create one issue per task in the repository for the current feature.

---

## After syncing

- **Link tasks to user stories**: In each task issue, add a line in the body: `Epic: #<issue_number_of_user_story>` (after creating the 5 user story issues, note their numbers and add them to the script or to task bodies).
- **Branch**: Use branch `001-user-auth` and reference the task in commits, e.g. `feat(auth): T015 LoginViewModel` or `Closes #12` in PR description.
- **Labels**: Filter issues by `feature/001-user-auth` or `user-story: US1` to see all work for this feature or story.
