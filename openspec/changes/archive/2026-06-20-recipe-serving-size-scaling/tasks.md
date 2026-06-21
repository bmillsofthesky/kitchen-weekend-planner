## 1. Data Model Migration

- [x] 1.1 Add `servingSize: Int` (default 1) and `costForRecipe: Double?` fields to `Recipe` SwiftData model in `Recipe.swift`; remove `costPerServing`
- [x] 1.2 Create a SwiftData migration stage that sets `servingSize = 1` and `costForRecipe = costPerServing` for all existing records
- [x] 1.3 Update `RecipeDTO` in `Recipe.swift` to include `servingSize` and `costForRecipe`; add backward-compat read of legacy `costPerServing` field

## 2. Sync and Import Updates

- [x] 2.1 Update `RecipeSyncService.makeRecipe` and `apply` to remove ingredient normalization — store amounts at native serving size
- [x] 2.2 Update `RecipeSyncService` to map `servingSize` and `costForRecipe` from DTO; fall back to `costPerServing * (servingSize ?? 1)` if source only provides `costPerServing`
- [x] 2.3 Update `ManualRecipeFormView` prefill logic to remove per-serving normalization of ingredient amounts
- [x] 2.4 Update `RecipeScraperService` to parse `recipeYield` from Schema.org markup and populate `servingSize` on the scraped DTO

## 3. Cost Logic

- [x] 3.1 Update `costLabel(headcount:)` in `Recipe.swift` to compute total cost as `(Double(headcount) / Double(servingSize)) * costForRecipe`
- [x] 3.2 Update `ManualRecipeFormView` cost field label from "Cost per serving ($)" to "Recipe cost ($)" and wire it to `costForRecipe`

## 4. Budget Calculator

- [x] 4.1 Update `BudgetCalculator.totalCost` in `BudgetCalculator.swift` to use `(Double(headcount) / Double(a.recipe?.servingSize ?? 1)) * (a.recipe?.costForRecipe ?? 0)`

## 5. Display Scaling

- [x] 5.1 Update `RecipeDetailView` to display ingredient amounts scaled to headcount: `amount * Double(headcount) / Double(servingSize)`
- [x] 5.2 Update `RecipeDetailView.formatAmount` to handle fractional results (already supports two decimal places — verify behavior)

## 6. Export

- [x] 6.1 Update `PlanExporter.ExportRecipe` struct to include `costForRecipe` and update `totalCost` calculation to `(Double(headcount) / Double(servingSize)) * costForRecipe`
- [x] 6.2 Update `PlanExporter` ingredient scaling to use `amount * Double(headcount) / Double(servingSize)`

## 7. Verification

- [ ] 7.1 Confirm existing locally-stored recipes display correctly after migration (servingSize=1, amounts unchanged)
- [ ] 7.2 Sync a remote recipe with `servingSize > 1` and verify ingredient amounts, cost label, and budget contribution are correct
- [ ] 7.3 Export a plan and verify exported ingredient amounts and totalCost values match expected scaled values
