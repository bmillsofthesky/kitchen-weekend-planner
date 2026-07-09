## Context

`MealConfig` is a `Codable` struct stored as JSON in `MovementConfiguration.daysData`. It currently has `mealType: MealType` and `potluckEligible: Bool`. `MealView` reads `potluckEligible` to decide whether to show the potluck toggle. When toggled, it sets `mealPlan.isPotluck` and saves.

## Goals / Non-Goals

**Goals:**
- Allow a movement JSON config to declare a meal as always-potluck
- Automatically set `isPotluck = true` on required-potluck meals so the rest of the app (card label, recipe slot logic) reflects it without user action

**Non-Goals:**
- Changing how `potluckEligible` works for non-required meals
- UI for editing `potluckRequired` at runtime (config-only)
- Migrating existing `movements.json` entries (they get `false` by default)

## Decisions

### Add `potluckRequired: Bool` to `MealConfig` with default `false`

`MealConfig` is `Codable`. Adding a field with a default value in the `init` and using a custom `CodingKeys` or `init(from:)` with a default allows existing JSON without the key to decode cleanly. Simplest approach: add `var potluckRequired: Bool = false` — Swift's synthesized `Codable` will use `false` if the key is absent during decoding.

### Enforce in MealView, not the model

Rather than enforcing in `MealPlan`, keep the logic in `MealView` where the toggle already lives. On appear (`.onAppear`), if `potluckRequired` is true, set `mealPlan.isPotluck = true` and save. Hide the toggle row when `potluckRequired` is true.

**Alternative considered:** Enforce in `MealPlan` via a computed override — rejected because `MealPlan` doesn't have a reference to `MovementConfiguration`, so it can't read `potluckRequired` without threading it through.
