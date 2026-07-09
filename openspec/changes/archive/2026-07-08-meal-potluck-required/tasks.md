## 1. Model

- [x] 1.1 In `MealConfig`, add `var potluckRequired: Bool = false`

## 2. MealView enforcement

- [x] 2.1 In `MealView`, expose `isPotluckRequired: Bool` computed from `mealConfig?.potluckRequired ?? false`
- [x] 2.2 Pass `isPotluckRequired` down to `RecipesTab` (add parameter)
- [x] 2.3 In `RecipesTab`, add `.onAppear` that sets `mealPlan.isPotluck = true` and saves when `isPotluckRequired` is true
- [x] 2.4 In `RecipesTab`, hide the potluck toggle row when `isPotluckRequired` is true
