## Context

`SettingsView` currently has a `Section("Budget")` containing `BudgetProgressBar` and a status label. This was added when budget was moved out of the global top bar. The subsequent `quick-budget-access` and `budget-button-navbar` changes added a sheet accessible from the nav bar on every tab, making the Settings section redundant.

## Goals / Non-Goals

**Goals:**
- Clean Settings list with no duplicate budget display

**Non-Goals:**
- Changing the budget sheet or toolbar button
- Removing `BudgetCalculator` helpers (still used by `BudgetSheetView`)

## Decisions

### Remove the Section block entirely

The `Section("Budget")` and its contents are deleted. The inline `let utilization = BudgetCalculator.utilization(...)` inside the `List` body goes with it. No other changes needed.
