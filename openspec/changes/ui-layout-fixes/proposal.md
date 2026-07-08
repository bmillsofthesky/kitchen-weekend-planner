## Why

Two layout bugs are causing UI elements to overlap: the budget progress bar at the top of the screen is being covered by navigation bar content on recipe and meal planning pages, and the Recipes/Theme segmented navigation inside `MealView` renders a second tab bar at the bottom that clashes with the main app tab bar.

## What Changes

- **Budget progress bar**: Replace `.overlay(alignment: .top)` with `.safeAreaInset(edge: .top)` in `MainTabView` so the 4pt bar claims its own space at the top of the safe area instead of floating over navigation content
- **MealView tab conflict**: Replace the nested `TabView` (which renders a bottom tab bar) with a `Picker` in segmented style, placed in the navigation toolbar, to switch between Recipes and Theme without generating a competing tab bar

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- none

## Impact

- Only `MainTabView.swift` and `MealView.swift` are changed
- No model, service, or data changes
- Behavior is identical — same two views accessible in `MealView`, same progress bar visible everywhere
