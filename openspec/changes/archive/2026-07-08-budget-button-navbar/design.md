## Context

SwiftUI toolbar items with navigation bar placements (`.topBarTrailing`, `.topBarLeading`) must be attached to a view that lives inside a `NavigationStack`, not on the `NavigationStack` or `TabView` themselves. The current `.bottomBar` item on `MainTabView`'s `TabView` works because `.bottomBar` is a tab-level placement. To get the button into the nav bar, it must be added inside each root view.

## Goals / Non-Goals

**Goals:**
- Budget button appears in the top-right of the navigation bar on all three main tabs
- Sheet behavior is identical to current implementation

**Non-Goals:**
- Changing the sheet content or presentation
- Sharing sheet state across tabs (not needed — each tab independently opens the sheet)

## Decisions

### 1. Each root view owns its own sheet state

Each of the three root views (`PlanOverviewView`, `RecipeLibraryView`, `SettingsView`) adds:
```swift
@State private var showBudgetSheet = false
```
and a `.toolbar` modifier with a `.topBarTrailing` button + `.sheet` presentation.

Considered: lifting state to `MainTabView` and passing `Binding<Bool>` to each view — rejected because it adds prop-drilling for trivial local UI state, and having multiple tabs open the sheet simultaneously is not a concern.

### 2. Remove `.toolbar` and `.sheet` from `MainTabView`

Once all three root views handle their own sheet, the `TabView`-level toolbar and sheet become redundant. Remove them and the `showBudgetSheet` state from `MainTabView` to keep it clean.

### 3. `SettingsView` already shows budget in its content

On the Settings tab, the budget button still appears in the nav bar for consistency, even though the Budget section is already visible in the list below. The sheet gives a quick overlay without scrolling, which remains useful.
