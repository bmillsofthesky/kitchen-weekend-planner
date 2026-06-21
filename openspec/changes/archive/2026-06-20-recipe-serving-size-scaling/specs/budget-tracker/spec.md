## MODIFIED Requirements

### Requirement: Budget calculation
The total recipe cost SHALL be calculated as the sum of `(headcount / servingSize) * costForRecipe` for every recipe assigned to any meal in the active weekend plan. Recipes with no `costForRecipe` SHALL contribute $0 to the total.

#### Scenario: Cost updates when recipe assigned
- **WHEN** the user assigns a recipe to a meal slot
- **THEN** the progress bar SHALL update to reflect the new total cost

#### Scenario: Cost updates when recipe removed
- **WHEN** the user removes a recipe from a meal slot
- **THEN** the progress bar SHALL decrease accordingly

#### Scenario: Recipes with unknown cost excluded
- **WHEN** a recipe has no `costForRecipe`
- **THEN** it SHALL contribute $0 to the budget calculation

#### Scenario: Cost scales correctly with serving size
- **WHEN** a recipe has `servingSize = 4`, `costForRecipe = 20.00`, and headcount is 8
- **THEN** that recipe SHALL contribute $40.00 to the total budget cost
