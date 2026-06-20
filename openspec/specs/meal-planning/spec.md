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

### Requirement: Potluck designation for eligible meals
If the active meal is potluck-eligible (per the movement configuration), the user SHALL be able to toggle the meal as a potluck. A potluck meal SHALL not require recipe assignments.

#### Scenario: Toggle potluck on eligible meal
- **WHEN** the user enables potluck for an eligible meal
- **THEN** the meal SHALL be marked as potluck and recipe slots SHALL be indicated as optional

#### Scenario: Potluck toggle hidden for ineligible meals
- **WHEN** the meal is not potluck-eligible
- **THEN** no potluck toggle SHALL be displayed

### Requirement: Recipe and theme tabs in Meal View
The Meal View SHALL contain two tabs: one for recipe planning and one for theme planning.

#### Scenario: Tabs visible in Meal View
- **WHEN** the user opens a meal
- **THEN** both a Recipes tab and a Theme tab SHALL be visible and selectable
