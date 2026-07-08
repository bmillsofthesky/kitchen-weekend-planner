## Context

`BudgetProgressBar` is currently rendered as a 4pt overlay at the top of `MainTabView`, visible on every screen. This causes it to sit flush against navigation bars. `BudgetCalculator.utilization()` returns a `Double` (0.0–1.0+) and already drives color thresholds: green < 70%, yellow 70–99%, red ≥ 100%.

`SettingsView` already shows plan-level metadata (name, movement, headcount) in a List. Budget is natural to add there.

## Goals / Non-Goals

**Goals:**
- Budget progress bar visible in Settings, not globally
- Status label derived from utilization (no dollar amounts shown)
- `MainTabView` has no persistent chrome above navigation bars

**Non-Goals:**
- Quick-access budget from other views (future consideration)
- Showing monetary values anywhere

## Decisions

### 1. Remove `BudgetProgressBar` from `MainTabView`

Delete the `.safeAreaInset` block entirely. `MainTabView` becomes a plain `TabView` with no top chrome.

### 2. Add a Budget section to `SettingsView`

Place a new `Section("Budget")` between "Active Plan" and "Plan Management" containing:
- `BudgetProgressBar` at its natural height (4pt), full width
- A `Text` status label derived from utilization:
  - < 70% → "On track"
  - 70–99% → "Approaching limit"  
  - ≥ 100% → "Over budget"
- Label colored to match the bar (green / yellow / red) using the same thresholds

### 3. No monetary display

`BudgetCalculator.totalCost` and `movement.budget` are not surfaced in the UI. Only the proportional bar and status text are shown.
