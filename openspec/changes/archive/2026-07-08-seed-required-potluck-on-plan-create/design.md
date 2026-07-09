## Context

In `NewPlanFormView.createPlan()`, `movement.allMealSlots` is iterated to pre-create `MealPlan` entries. Each `slot` is a `(day: Int, meal: MealConfig)` tuple. `MealConfig` now has `potluckRequired: Bool`. The `MealPlan` initializer sets `isPotluck = false` unconditionally.

## Goals / Non-Goals

**Goals:**
- Required-potluck meals have `isPotluck = true` from the moment the plan is created

**Non-Goals:**
- Changing how `isPotluck` is set for non-required potluck-eligible meals (still user-toggled)
- Backfilling existing plans (existing data is unaffected; the `.onAppear` enforcement in `RecipesTab` remains as a safety net)

## Decisions

### Set `isPotluck` in the creation loop, not in `MealPlan.init`

The `MealPlan` model has no reference to `MovementConfiguration`, so it can't self-determine `potluckRequired`. The right place is the caller that already has both the meal slot and the config — `NewPlanFormView.createPlan()`. After creating `mp`, set `mp.isPotluck = slot.meal.potluckRequired`.
