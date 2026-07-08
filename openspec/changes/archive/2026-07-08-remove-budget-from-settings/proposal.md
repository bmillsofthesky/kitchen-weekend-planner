## Why

The Budget section in the Settings list is now redundant — the `chart.bar.fill` toolbar button gives quick access to the same information from every screen via a sheet. Having it in two places adds visual noise to the Settings page without adding value.

## What Changes

- **Remove** the `Section("Budget")` block from `SettingsView`, including the `BudgetProgressBar`, utilization label, and percentage text

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- none

## Impact

- `SettingsView.swift` only — remove the Budget section and its inline `let utilization` binding
- No other files change; `BudgetCalculator.statusLabel`/`statusColor` remain (still used by `BudgetSheetView`)
