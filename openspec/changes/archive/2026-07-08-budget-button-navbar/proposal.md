## Why

The budget button currently sits in `.bottomBar` placement, which renders it in the tab bar area and makes it easy to miss or accidentally tap. Moving it to the top navigation bar makes it more intentional, visible, and consistent with how iOS apps surface supplementary actions.

## What Changes

- **Move** the budget toolbar button from `.bottomBar` on the `TabView` to `.topBarTrailing` on each of the three root tab views (`PlanOverviewView`, `RecipeLibraryView`, `SettingsView`)
- **Remove** the `.bottomBar` toolbar item from `MainTabView`
- Each root view manages its own `showBudgetSheet` state and presents `BudgetSheetView` directly — no state threading required

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- none

## Impact

- `MainTabView.swift` — remove `.bottomBar` toolbar and sheet
- `PlanOverviewView.swift`, `RecipeLibraryView.swift`, `SettingsView.swift` — each gains a `@State private var showBudgetSheet` and a `.topBarTrailing` toolbar button presenting `BudgetSheetView`
- No model, service, or data changes
