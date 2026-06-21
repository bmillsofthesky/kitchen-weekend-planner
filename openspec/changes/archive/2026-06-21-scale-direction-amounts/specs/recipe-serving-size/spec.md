## MODIFIED Requirements

### Requirement: Ingredient amounts scaled to headcount for display and export
When recipes are displayed or exported, ingredient amounts SHALL be scaled from the recipe's native `servingSize` to the active weekend headcount using the ratio `headcount / servingSize`. Direction text SHALL also have recognized unit-qualified quantities scaled by the same ratio at display time.

#### Scenario: Ingredient amounts scaled in export
- **WHEN** a plan is exported and a recipe has `servingSize = 4` and the headcount is 8
- **THEN** each ingredient's exported amount SHALL be multiplied by 2 (8 / 4)

#### Scenario: Ingredient amounts scaled in detail view
- **WHEN** a user views a recipe detail page during an active weekend plan
- **THEN** ingredient amounts SHALL be displayed scaled to the active headcount

#### Scenario: Direction quantities scaled in detail view
- **WHEN** a user views a recipe detail page during an active weekend plan
- **THEN** numeric quantities in direction text that precede a recognized cooking unit SHALL be displayed scaled to the active headcount

#### Scenario: Fractional scaling rounds to two decimal places
- **WHEN** the headcount / servingSize ratio produces a non-integer result
- **THEN** displayed and exported amounts SHALL be formatted to at most two decimal places
