## MODIFIED Requirements

### Requirement: Recipe data model
Each recipe SHALL store: title, description, costForRecipe (total cost for the recipe's native serving size), servingSize (number of servings the recipe ingredients are written for), type (Entree | Side | Dessert | Other), labels (Breakfast | Lunch | Dinner | Soup | Salad | Sauce | custom), ingredients (name, measurement, amount at native serving size, section), directions (order, text, section), and notes.

#### Scenario: Recipe displays all fields
- **WHEN** a user views a recipe's detail page
- **THEN** all populated fields SHALL be displayed: title, description, type, labels, ingredients (scaled to headcount) grouped by section, directions ordered by section and step, and notes

#### Scenario: Custom labels supported
- **WHEN** a user adds a label that is not in the predefined list
- **THEN** the custom label SHALL be saved and displayed with the recipe

### Requirement: Recipe cost labeling
Each recipe SHALL display a cost label based on its `costForRecipe` scaled to the active weekend's headcount using the formula `(headcount / servingSize) * costForRecipe`. Cost tiers: Unknown (no cost data), $ (Inexpensive), $$ (Moderate), $$$ (Expensive), $$$$ (Very Expensive).

#### Scenario: Cost label shown in library and meal view
- **WHEN** a recipe is displayed in the library or a meal slot
- **THEN** the appropriate cost label SHALL be shown based on `(headcount / servingSize) * costForRecipe`

#### Scenario: Unknown label for missing cost
- **WHEN** a recipe has no `costForRecipe` value
- **THEN** the label SHALL display "Unknown"

## REMOVED Requirements

### Requirement: Recipe converted to single-serving on import
**Reason**: Recipes now store ingredient amounts at their native serving size. Normalizing to single-serving is no longer performed.
**Migration**: Existing locally-stored recipes have `servingSize = 1` after migration, so their stored amounts remain correct. New imports retain native serving size amounts.
