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
| Phase 2: Foundational | T004–T014, T014a | — |
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

## Sync task status to GitHub (close completed issues)

When you complete tasks and mark them `[x]` in `tasks.md`, sync that status to GitHub by closing the corresponding issues.

### Completed now (T001–T014, T014a)

| Task   | GitHub Issue | Link |
|--------|--------------|------|
| T001   | #4  | https://github.com/ashoksinarewai/spec_kit_itp/issues/4  |
| T002   | #5  | https://github.com/ashoksinarewai/spec_kit_itp/issues/5  |
| T003   | #6  | https://github.com/ashoksinarewai/spec_kit_itp/issues/6  |
| T004   | #7  | https://github.com/ashoksinarewai/spec_kit_itp/issues/7  |
| T005   | #8  | https://github.com/ashoksinarewai/spec_kit_itp/issues/8  |
| T006   | #9  | https://github.com/ashoksinarewai/spec_kit_itp/issues/9  |
| T007   | #10 | https://github.com/ashoksinarewai/spec_kit_itp/issues/10 |
| T008   | #11 | https://github.com/ashoksinarewai/spec_kit_itp/issues/11 |
| T009   | #12 | https://github.com/ashoksinarewai/spec_kit_itp/issues/12 |
| T010   | #13 | https://github.com/ashoksinarewai/spec_kit_itp/issues/13 |
| T011   | #14 | https://github.com/ashoksinarewai/spec_kit_itp/issues/14 |
| T012   | #15 | https://github.com/ashoksinarewai/spec_kit_itp/issues/15 |
| T013   | #16 | https://github.com/ashoksinarewai/spec_kit_itp/issues/16 |
| T014   | #17 | https://github.com/ashoksinarewai/spec_kit_itp/issues/17 |
| T014a  | *(not in script)* | Create manually: title **"[T014a] Add mock auth data and AuthMockRemoteDataSource"**, labels `feature/001-user-auth`, `phase: foundational`. Then close with comment: *Completed in branch 001-user-auth (mock data, abstract datasource, USE_MOCK_AUTH).* |

**Option A – Script (if `gh` is installed):**

```powershell
.\specs\001-user-auth\scripts\sync-task-status-to-github.ps1
```

This closes issues #4–#17 with a comment that they were completed in Phase 1 & 2.

**Option B – Manual:** Open each link above and click **Close issue**, or add a comment (e.g. "Done in Phase 1 & 2") then close.

**Option C – One command with `gh`:**

```powershell
gh issue close 4 5 6 7 8 9 10 11 12 13 14 15 16 17 --repo ashoksinarewai/spec_kit_itp --comment "Completed in Phase 1 & 2 (Setup + Foundational). See tasks.md and branch 001-user-auth."
```

---

## After syncing

- **Link tasks to user stories**: In each task issue, add a line in the body: `Epic: #<issue_number_of_user_story>` (after creating the 5 user story issues, note their numbers and add them to the script or to task bodies).
- **Branch**: Use branch `001-user-auth` and reference the task in commits, e.g. `feat(auth): T015 LoginViewModel` or `Closes #12` in PR description.
- **Labels**: Filter issues by `feature/001-user-auth` or `user-story: US1` to see all work for this feature or story.
