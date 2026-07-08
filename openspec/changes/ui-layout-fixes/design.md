## Context

The app uses `MainTabView` as the root, which wraps three `NavigationStack`s in a `TabView` and overlays a 4pt `BudgetProgressBar` at the top. SwiftUI's `.overlay(alignment: .top)` places the bar at the top of the `TabView`'s frame, which coincides with where the navigation bar renders — causing the two to stack on top of each other.

`MealView` embeds a second `TabView` for Recipes/Theme sub-navigation. SwiftUI renders nested `TabView`s with their own bottom tab bars, so `MealView`'s tab bar sits on top of the app-level tab bar.

## Goals / Non-Goals

**Goals:**
- Budget progress bar appears above navigation content without overlap
- MealView Recipes/Theme switching has no bottom tab bar of its own

**Non-Goals:**
- Restyling the progress bar or changing its height
- Changing the Recipes/Theme navigation to anything other than a simple two-option control

## Decisions

### 1. Use `.safeAreaInset(edge: .top)` for the budget bar

`.safeAreaInset` inserts content into the safe area, pushing all scroll and navigation content below it. This is the idiomatic SwiftUI way to add persistent chrome above scrollable content without overlapping it.

Current code:
```swift
.overlay(alignment: .top) {
    BudgetProgressBar(...)
        .frame(height: 4)
}
```

Fix:
```swift
.safeAreaInset(edge: .top, spacing: 0) {
    BudgetProgressBar(...)
        .frame(height: 4)
}
```

Considered: adding `.padding(.top, 4)` to each child view — rejected because it requires touching every child and doesn't account for dynamic safe area changes.

### 2. Replace nested `TabView` with a `Picker` in `.segmented` style in the toolbar

A `Picker` with `.pickerStyle(.segmented)` in `.principal` toolbar placement gives a compact two-option control in the navigation bar, which is the standard iOS pattern for this use case (e.g., Maps, Photos). It requires no bottom chrome and doesn't conflict with the outer `TabView`.

The `selectedTab` state binding remains; the two content views (`RecipesTab`, `ThemeTab`) are shown conditionally with an `if/else` inside a `VStack` or `Group`.

Considered: keeping `TabView` with `.tabViewStyle(.page)` — rejected because the page dots at the bottom still render near the tab bar and the swipe gesture can conflict.
