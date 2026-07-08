## 1. Budget Progress Bar Fix

- [x] 1.1 In `MainTabView`, replace `.overlay(alignment: .top)` with `.safeAreaInset(edge: .top, spacing: 0)` for the `BudgetProgressBar`

## 2. MealView Sub-Navigation Fix

- [x] 2.1 In `MealView`, replace the `TabView(selection:)` with a `Group` that conditionally shows `RecipesTab` or `ThemeTab` based on `selectedTab`
- [x] 2.2 Add a `Picker` with `.pickerStyle(.segmented)` as a `.principal` toolbar item in `MealView` to switch between Recipes (tag 0) and Theme (tag 1)
- [x] 2.3 Remove the `.tabItem` modifiers from `RecipesTab` and `ThemeTab` since they are no longer inside a `TabView`
