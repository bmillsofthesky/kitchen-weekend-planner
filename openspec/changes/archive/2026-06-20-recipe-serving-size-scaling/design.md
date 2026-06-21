## Context

Recipes are currently stored with ingredients normalized to 1 serving and a `costPerServing` field. The app scales ingredient amounts to headcount at export time and multiplies cost by headcount for budget calculations. This normalization loses the original recipe's serving size, which makes cost data ambiguous (cost for what?). The change replaces the single-serving model with native serving sizes stored on the recipe, and shifts all headcount scaling to be driven by `servingSize`.

Relevant files:
- `KitchenPlanner/Sources/Models/Recipe.swift` — data model and `RecipeDTO`
- `KitchenPlanner/Sources/Services/BudgetCalculator.swift` — budget math
- `KitchenPlanner/Sources/Services/PlanExporter.swift` — export scaling
- `KitchenPlanner/Sources/Services/RecipeSyncService.swift` — remote sync and normalization
- `KitchenPlanner/Sources/Services/RecipeScraperService.swift` — URL scrape
- `KitchenPlanner/Sources/Views/ManualRecipeFormView.swift` — manual entry form
- `KitchenPlanner/Sources/Views/RecipeDetailView.swift` — ingredient display

## Goals / Non-Goals

**Goals:**
- Store `servingSize: Int` and `costForRecipe: Double?` on each recipe, replacing `costPerServing`
- Preserve ingredient amounts at native serving size (no normalization on import)
- Scale ingredient display and export output from `servingSize` to headcount at read time
- Update budget calculation to use `costForRecipe / servingSize * headcount`
- Update cost labels to derive from the new fields
- Migrate existing locally-stored recipes and the remote JSON sync mapping

**Non-Goals:**
- Changing the visual design of cost labels or the budget progress bar
- Supporting fractional serving sizes
- Storing multiple cost tiers per recipe

## Decisions

### Decision: Replace `costPerServing` with `costForRecipe` + `servingSize`

Rather than keeping `costPerServing` and inferring total cost, we store the cost for the recipe's native batch and its serving size. This makes cost semantically unambiguous and allows ingredient amounts to stay at their native scale.

**Alternative considered**: Keep `costPerServing`, add `servingSize` only for ingredient scaling. Rejected because it means cost and serving size could drift independently and the cost label would still be per-serving rather than per-batch.

### Decision: Scale ingredients at display/export time, not at storage time

Ingredient amounts are stored at the recipe's native `servingSize`. Scaling to headcount is applied when rendering `RecipeDetailView` and when generating export JSON. `ManualRecipeFormView` displays and accepts amounts at native serving size.

**Alternative considered**: Store scaled amounts separately. Rejected — unnecessary duplication and sync complexity.

### Decision: Migration via model version + default values

SwiftData schema migration adds `servingSize` (default 1) and `costForRecipe` (derived from existing `costPerServing * 1` = same value, since stored amounts were at 1 serving). `costPerServing` is removed. Existing recipes already have amounts stored for 1 serving, so `servingSize = 1` is a lossless migration.

For the remote JSON sync source: the DTO gains `servingSize` and `costForRecipe`; if a remote recipe only has the old `costPerServing` field, the sync service maps it: `costForRecipe = costPerServing * (servingSize ?? 1)`.

### Decision: Budget formula becomes `(headcount / servingSize) * costForRecipe`

This calculates how many batches of the recipe are needed to feed the headcount, then multiplies by the cost per batch. Integer division is not used — floating point ratio correctly handles headcounts that don't divide evenly.

## Risks / Trade-offs

- **Existing custom recipes lose original serving context** → Mitigation: migration defaults `servingSize` to 1 and sets `costForRecipe = costPerServing`, which is lossless for recipes already normalized to 1 serving.
- **Remote JSON source may not have `costForRecipe`/`servingSize` yet** → Mitigation: sync service falls back to `costPerServing` mapping so old-format remote data continues to work.
- **Ingredient amounts displayed in detail view will now reflect native serving size, not headcount** → This is intentional; the UI should show what the recipe produces, not what's needed for the weekend. Export continues to scale to headcount.

## Migration Plan

1. Add `servingSize: Int` (default 1) and `costForRecipe: Double?` to `Recipe` SwiftData model
2. Remove `costPerServing` field; add a lightweight SwiftData migration stage that sets `costForRecipe = costPerServing` and `servingSize = 1` for existing records
3. Update `RecipeDTO` to include `servingSize` and `costForRecipe`; keep backward-compat read of `costPerServing` in sync service
4. Remove ingredient normalization in `RecipeSyncService` and `ManualRecipeFormView`
5. Update `RecipeDetailView` to scale displayed amounts: `amount * Double(headcount) / Double(servingSize)`
6. Update `BudgetCalculator.totalCost` formula
7. Update `PlanExporter` cost and ingredient scaling
8. Update `costLabel(headcount:)` to use `costForRecipe`
9. Update `ManualRecipeFormView` cost field label to reflect new semantics

## Open Questions

- Should the recipe detail view show ingredients scaled to headcount or to native serving size? (Design decision above says native serving size — confirm with user if needed.)
