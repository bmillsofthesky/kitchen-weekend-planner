## Why

Some movement configurations have meals that must always be potlucks — not just eligible for it. Today `MealConfig` only has `potluckEligible`, which surfaces a toggle the user can turn on or off. There's no way to lock a meal as a required potluck so the planner automatically treats it as one without user intervention.

## What Changes

- Add `potluckRequired: Bool` field to `MealConfig` (defaults to `false` for backwards compatibility with existing JSON configs)
- When a meal's config has `potluckRequired: true`, `MealPlan.isPotluck` SHALL be forced to `true` automatically and the toggle SHALL not be shown
- Movement JSON configs can set `potluckRequired: true` on specific meals

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- `meal-planning`: MealConfig now supports a required-potluck state that overrides the user-toggled potluck flag

## Impact

- `MovementConfiguration.swift` — add `potluckRequired` to `MealConfig` with default `false`
- `MealView.swift` — read `potluckRequired` from config; if true, hide the toggle and ensure `isPotluck` is set
- `movements.json` — no required changes (existing entries get `false` by default via Codable)
