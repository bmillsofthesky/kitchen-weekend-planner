## Why

Budget is now only visible in the Settings tab, which requires leaving whatever screen you're on to check it. When actively assigning recipes to meals, it's useful to glance at budget utilization without a full tab switch. A lightweight, on-demand sheet gives quick access without cluttering any screen permanently.

## What Changes

- **Add a budget toolbar button** to `MainTabView` that appears on every tab, presenting a compact budget sheet on tap
- **Budget sheet** shows the progress bar, utilization percentage, and status label — the same information already in Settings, no monetary values
- The existing Budget section in `SettingsView` remains unchanged

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- none

## Impact

- `MainTabView.swift` — add toolbar button and sheet state
- New `BudgetSheetView.swift` — compact sheet view reusing `BudgetProgressBar` and the status label logic
- No model, service, or data changes
