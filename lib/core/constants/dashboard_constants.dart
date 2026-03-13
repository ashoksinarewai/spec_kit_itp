/// Dashboard feature constants: timers, thresholds, UI limits.
/// Used by dashboard widgets and viewmodels.
library;

/// Timer update interval for active task display (milliseconds).
const int kDashboardTimerIntervalMs = 1000;

/// Default task list page size for pagination.
const int kDashboardTaskListPageSize = 20;

/// Max task description length to show in list/card (chars).
const int kDashboardTaskDescriptionMaxChars = 100;

/// Retry delays for API calls (seconds): 1, 2, 4.
const List<int> kDashboardRetryDelaysSeconds = [1, 2, 4];

/// Max retry attempts for transient errors.
const int kDashboardMaxRetries = 3;
