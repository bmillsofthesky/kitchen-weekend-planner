## Why

When a new weekend plan is created, `MealPlan` entries are pre-created for each meal slot in the movement config. The creation code always sets `isPotluck = false` regardless of whether `MealConfig.potluckRequired` is `true`. As a result, required-potluck meals appear as normal meals in the Plan Overview on first load — the potluck state is only applied later when the user opens the individual meal view (via `.onAppear` in `RecipesTab`).

## What Changes

- When pre-creating `MealPlan` entries in `NewPlanFormView`, check `slot.meal.potluckRequired` and set `isPotluck = true` immediately if it's required

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- `meal-planning`: Required-potluck meals SHALL be initialized with `isPotluck = true` at plan creation time

## Impact

- `NewPlanFormView.swift` only — one line change in the meal slot loop
