## 1. Extract Status Label Helpers

- [x] 1.1 Add `budgetStatusLabel(_:) -> String` and `budgetStatusColor(_:) -> Color` as static methods on `BudgetCalculator` in `BudgetCalculator.swift`
- [x] 1.2 Update `SettingsView` to call `BudgetCalculator.budgetStatusLabel` and `BudgetCalculator.budgetStatusColor` instead of its local private methods, then remove the local copies

## 2. Budget Sheet View

- [x] 2.1 Create `BudgetSheetView.swift` with a compact sheet layout: title ("Budget"), `BudgetProgressBar` at 8pt height, status label and percentage using the shared `BudgetCalculator` helpers
- [x] 2.2 Register `BudgetSheetView.swift` in `project.pbxproj` (PBXFileReference, PBXBuildFile, group, Sources phase)

## 3. Toolbar Button in MainTabView

- [x] 3.1 Add `@State private var showBudgetSheet = false` to `MainTabView`
- [x] 3.2 Add a `ToolbarItem(placement: .bottomBar)` to the `TabView` with a `chart.bar.fill` button that sets `showBudgetSheet = true`
- [x] 3.3 Add `.sheet(isPresented: $showBudgetSheet) { BudgetSheetView(plan: plan, movement: movement) }` to `MainTabView`
