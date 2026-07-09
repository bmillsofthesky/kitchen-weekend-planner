## Context

`PlanOverviewView` renders a `NavigationLink` per meal that always goes to `MealView`. `MealPlan` has `isPotluck: Bool` but no field for a coordination URL. The potluck state is set either by user toggle (in `RecipesTab`) or automatically on appear (when `potluckRequired` is true).

## Goals / Non-Goals

**Goals:**
- Replace the recipe/theme tab content with a purpose-built potluck screen when `isPotluck` is true
- Store and display a coordination service URL on that screen

**Non-Goals:**
- Validating or opening the URL in-app (system `openURL` is sufficient)
- Changing how `isPotluck` is set — that remains in `RecipesTab`/`MealView`

## Decisions

### Add `potluckUrl: String?` to `MealPlan`

A nullable string stored directly on the SwiftData model. Simple and avoids a separate relationship. The URL is optional — most potluck meals won't have one immediately.

### Route at the `NavigationLink` level in `PlanOverviewView`

Rather than branching inside `MealView`, swap the destination entirely. When `mealPlan.isPotluck` is true, the link goes to `PotluckView`; otherwise it goes to `MealView`. This keeps each view focused and avoids adding more branching to an already-complex `MealView`.

**Alternative considered:** Branch inside `MealView` itself — rejected because it would make `MealView` responsible for two completely different layouts and muddy its toolbar/tab logic.

### `PotluckView` layout

- Navigation title: "Day N · MealType · Potluck"
- Hero area: `person.3.fill` icon with "This meal is a potluck" heading
- URL field: a `TextField` bound to `mealPlan.potluckUrl` (empty string ↔ nil bridging), with a save-on-change pattern. If a URL is set, show a tappable "Open link" button below it using `Link`.
- Warm canvas background consistent with the app's visual design.

### Register `PotluckView.swift` in `project.pbxproj`

Same manual pattern used for `AppColors.swift` and `BudgetSheetView.swift`. File goes in the `MealPlanning` group.
