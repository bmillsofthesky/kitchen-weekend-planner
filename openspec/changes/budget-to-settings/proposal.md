## Why

The persistent budget progress bar at the top of every screen causes layout collisions with navigation bars and isn't information users need constantly visible. Moving it to the Settings tab removes the layout problem entirely and puts budget info where it naturally belongs — alongside the other plan-level details — while keeping it a quick tab-switch away from anywhere in the app.

## What Changes

- **Remove** the `BudgetProgressBar` overlay/inset from `MainTabView` — no more persistent top bar
- **Add** a Budget section to `SettingsView` showing the progress bar and a utilization status label (no monetary values displayed)
- **Clean up** the `.safeAreaInset` added in `ui-layout-fixes` — it becomes unnecessary once the bar is removed

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- none

## Impact

- `MainTabView.swift` — remove `.safeAreaInset` and `BudgetProgressBar`
- `SettingsView.swift` — add Budget section with `BudgetProgressBar` and status label
- `BudgetProgressBar.swift` — no changes needed, reused as-is
- No model, service, or data changes
