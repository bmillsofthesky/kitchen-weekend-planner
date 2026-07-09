## Purpose

Defines how users view and edit meal assignments within a weekend plan, including recipe slots, drag-and-drop assignment, potluck designation, and the dual recipe/theme tab layout.

## Requirements

### Requirement: Meal view with view and edit modes
Each meal SHALL have a dedicated Meal View with two modes: View (default) and Edit. In View mode the user can tap a recipe to see its details. In Edit mode the user can drag and drop recipes and reorder them.

#### Scenario: Default state is View mode
- **WHEN** the user navigates to a meal
- **THEN** the Meal View SHALL open in View mode with no drag or drop controls active

#### Scenario: Enter Edit mode
- **WHEN** the user taps the Edit button
- **THEN** the Meal View SHALL switch to Edit mode and enable drag-and-drop and reorder controls

#### Scenario: View recipe in View mode
- **WHEN** the user taps a recipe card in View mode
- **THEN** the full recipe detail page SHALL be displayed

### Requirement: Recipe slots per meal
Each meal SHALL have designated slots for Mains (Entrees/Soups), Sides, and Desserts. Multiple recipes can be added to each slot.

#### Scenario: Slots displayed per meal
- **WHEN** a meal is viewed
- **THEN** three distinct sections SHALL be visible: Mains, Sides, and Desserts

#### Scenario: Multiple recipes per slot
- **WHEN** the user adds more than one recipe to a slot
- **THEN** all added recipes SHALL be displayed in that slot

### Requirement: Drag and drop recipe assignment
In Edit mode the user SHALL be able to drag a recipe from the recipe library panel and drop it into a meal slot (Mains, Sides, or Desserts).

#### Scenario: Recipe dragged to correct slot
- **WHEN** the user drags a recipe from the library and drops it onto a meal slot
- **THEN** the recipe SHALL appear in that slot

#### Scenario: Recipe reordered within a slot
- **WHEN** the user long-presses and drags a recipe within a slot
- **THEN** the recipe order SHALL update to reflect the new position

### Requirement: MealConfig supports required-potluck designation
`MealConfig` SHALL include a `potluckRequired` boolean field (default `false`). When `potluckRequired` is `true`, the meal SHALL be treated as a potluck unconditionally — the user toggle SHALL be hidden, `MealPlan.isPotluck` SHALL be set to `true` automatically, and `MealPlan.isPotluck` SHALL be initialized to `true` at plan creation time. Navigation to any potluck meal (required or user-toggled) SHALL show `PotluckView` instead of the standard `MealView`.

#### Scenario: Required-potluck meal initialized at plan creation
- **WHEN** a new weekend plan is created for a movement that has `potluckRequired: true` on a meal
- **THEN** the corresponding `MealPlan.isPotluck` SHALL be `true` immediately, without requiring the user to open the meal first

#### Scenario: Required-potluck meal auto-set on view
- **WHEN** a user opens a meal whose config has `potluckRequired: true`
- **THEN** `MealPlan.isPotluck` SHALL be `true` and no potluck toggle SHALL be shown

#### Scenario: Potluck meal routes to PotluckView
- **WHEN** a user taps a meal card that has `isPotluck: true`
- **THEN** the app SHALL navigate to `PotluckView`, not the standard `MealView`

#### Scenario: Toggle potluck on eligible meal
- **WHEN** the user enables potluck for an eligible meal (not required)
- **THEN** the meal SHALL be marked as potluck and navigation SHALL route to `PotluckView`

#### Scenario: Potluck toggle hidden for ineligible or required-potluck meals
- **WHEN** the meal is not potluck-eligible, or it has `potluckRequired: true`
- **THEN** no potluck toggle SHALL be displayed

#### Scenario: Non-required meals unaffected
- **WHEN** a meal's config has `potluckRequired: false` (or the field is absent)
- **THEN** existing potluck-eligible toggle behavior SHALL be unchanged

#### Scenario: Existing movement configs decode without error
- **WHEN** a movement JSON config does not include `potluckRequired`
- **THEN** the field SHALL default to `false` and the meal SHALL behave as before

### Requirement: Recipe and theme tabs in Meal View
The Meal View SHALL contain two tabs: one for recipe planning and one for theme planning.

#### Scenario: Tabs visible in Meal View
- **WHEN** the user opens a meal
- **THEN** both a Recipes tab and a Theme tab SHALL be visible and selectable
