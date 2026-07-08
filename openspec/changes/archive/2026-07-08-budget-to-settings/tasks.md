## 1. Remove Budget Bar from MainTabView

- [x] 1.1 In `MainTabView`, remove the `.safeAreaInset` block and the `BudgetProgressBar` reference

## 2. Add Budget Section to SettingsView

- [x] 2.1 In `SettingsView`, add a `Section("Budget")` between "Active Plan" and "Plan Management" containing `BudgetProgressBar`
- [x] 2.2 Add a utilization status label below the bar: "On track" (< 70%, green), "Approaching limit" (70–99%, yellow), "Over budget" (≥ 100%, red) — no monetary values
