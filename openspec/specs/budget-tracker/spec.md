## Purpose

Tracks recipe cost against the weekend budget and provides a persistent visual indicator of budget status — without ever displaying raw dollar amounts.

## Requirements

### Requirement: Abstract budget progress bar always visible
When a weekend plan is active, the app SHALL display a persistent budget progress bar. The bar SHALL represent how close the total recipe cost is to the weekend budget without showing any dollar amounts.

#### Scenario: Progress bar visible during active plan
- **WHEN** a weekend plan is loaded
- **THEN** the budget progress bar SHALL be visible at all times (e.g., in a persistent header or toolbar)

#### Scenario: No dollar amounts displayed
- **WHEN** the budget progress bar is displayed
- **THEN** no raw cost figures, budget totals, or per-recipe prices SHALL appear anywhere in the UI

### Requirement: Budget calculation
The total recipe cost SHALL be calculated as the sum of (headcount × cost_per_serving) for every recipe assigned to any meal in the active weekend plan. Recipes with no cost_per_serving SHALL contribute $0 to the total.

#### Scenario: Cost updates when recipe assigned
- **WHEN** the user assigns a recipe to a meal slot
- **THEN** the progress bar SHALL update to reflect the new total cost

#### Scenario: Cost updates when recipe removed
- **WHEN** the user removes a recipe from a meal slot
- **THEN** the progress bar SHALL decrease accordingly

#### Scenario: Recipes with unknown cost excluded
- **WHEN** a recipe has no cost_per_serving
- **THEN** it SHALL contribute $0 to the budget calculation

### Requirement: Color-coded progress indication
The progress bar SHALL change color to indicate budget status: green (well under budget), yellow (approaching budget), red (at or over budget).

#### Scenario: Green state
- **WHEN** total cost is below a low threshold of the budget
- **THEN** the progress bar SHALL be displayed in green

#### Scenario: Yellow state
- **WHEN** total cost is in a moderate range approaching the budget
- **THEN** the progress bar SHALL be displayed in yellow

#### Scenario: Red state
- **WHEN** total cost meets or exceeds the budget
- **THEN** the progress bar SHALL be displayed in red
