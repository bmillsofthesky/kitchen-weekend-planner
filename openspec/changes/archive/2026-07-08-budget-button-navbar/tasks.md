## 1. Clean Up MainTabView

- [x] 1.1 Remove `@State private var showBudgetSheet`, the `.toolbar` block, and the `.sheet` from `MainTabView`

## 2. Add Budget Button to Root Views

- [x] 2.1 In `PlanOverviewView`, add `@State private var showBudgetSheet = false`, a `.topBarTrailing` toolbar button (`chart.bar.fill`), and a `.sheet` presenting `BudgetSheetView`
- [x] 2.2 In `RecipeLibraryView`, add `@State private var showBudgetSheet = false`, a `.topBarTrailing` toolbar button (`chart.bar.fill`), and a `.sheet` presenting `BudgetSheetView`
- [x] 2.3 In `SettingsView`, add `@State private var showBudgetSheet = false`, a `.topBarTrailing` toolbar button (`chart.bar.fill`), and a `.sheet` presenting `BudgetSheetView`
