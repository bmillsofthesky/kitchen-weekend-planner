## Context

`MainTabView` wraps three `NavigationStack`s in a `TabView`. A toolbar item added to the `TabView` itself will appear across all tabs. The budget data (`BudgetCalculator`, `BudgetProgressBar`) is already available and the status label logic exists in `SettingsView` — it can be extracted into the new sheet view without duplication.

## Goals / Non-Goals

**Goals:**
- One-tap budget glance from any tab
- Sheet dismisses easily (swipe down)
- No monetary values displayed
- Reuses existing `BudgetProgressBar` component

**Non-Goals:**
- Editing the budget from the sheet
- Showing recipe-level cost breakdown
- Replacing the Settings budget section

## Decisions

### 1. Toolbar button on `MainTabView` with `.bottomBar` placement

A `ToolbarItem(placement: .bottomBar)` on the `TabView` renders a button in the tab bar area across all tabs — unobtrusive but always reachable. Using a `chart.bar.fill` or `dollarsign.circle` SF Symbol keeps it recognizable.

Considered: `.topBarTrailing` on each individual `NavigationStack` — rejected because it requires threading state into every child view.

Considered: long-press gesture on the tab bar — rejected because it's not discoverable.

### 2. `BudgetSheetView` as a self-contained `.sheet`

A small dedicated view presented as a sheet keeps the logic contained. It takes `plan` and `movement` as inputs (same as `BudgetProgressBar`), computes utilization, and renders:
- A title ("Budget")
- `BudgetProgressBar` at a slightly larger height (8pt) for readability
- Status label + percentage, matching the Settings presentation

### 3. Status label helpers extracted — not duplicated

Move `budgetStatusLabel(_:)` and `budgetStatusColor(_:)` out of `SettingsView` into a small free function or a `BudgetCalculator` extension so both `SettingsView` and `BudgetSheetView` share the same logic.
