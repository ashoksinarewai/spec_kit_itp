# Close GitHub issues for completed tasks (T001-T014).
# Run from repo root after Phase 1 & 2 are done and tasks.md is updated.
# Requires: gh CLI installed and authenticated (gh auth login).

$ErrorActionPreference = 'Stop'
$Repo = "ashoksinarewai/spec_kit_itp"
$CompletedIssueNumbers = 4..17   # T001 (issue #4) through T014 (issue #17)
$Comment = "Completed in Phase 1 & 2 (Setup + Foundational). See tasks.md and branch 001-user-auth."

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Error "GitHub CLI (gh) not found. Install from https://cli.github.com/ and run: gh auth login"
    exit 1
}

foreach ($num in $CompletedIssueNumbers) {
    gh issue close $num --repo $Repo --comment $Comment
    Write-Host "Closed issue #$num"
}
Write-Host "Done. Closed issues #4-#17 (T001-T014)."
