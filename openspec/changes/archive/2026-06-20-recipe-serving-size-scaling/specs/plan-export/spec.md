## MODIFIED Requirements

### Requirement: Recipe cost in export
The exported plan SHALL include each recipe's `costForRecipe` (native batch cost) and a calculated `totalCost` equal to `(headcount / servingSize) * costForRecipe`, representing the cost to feed the weekend headcount with that recipe.

#### Scenario: Export includes scaled total cost
- **WHEN** a plan is exported and a recipe has `costForRecipe = 20.00`, `servingSize = 4`, and headcount is 8
- **THEN** the exported recipe SHALL include `totalCost = 40.00`

#### Scenario: Export includes native cost for recipe
- **WHEN** a plan is exported
- **THEN** the exported recipe SHALL include `costForRecipe` reflecting the cost at the recipe's native serving size
