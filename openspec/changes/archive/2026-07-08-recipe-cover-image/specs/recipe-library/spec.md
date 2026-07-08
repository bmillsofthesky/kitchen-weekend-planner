## MODIFIED Requirements

### Requirement: Recipe data model
Each recipe SHALL store: title, description, costForRecipe (total cost for the recipe's native serving size), servingSize (number of servings the recipe ingredients are written for), type (Entree | Side | Dessert | Other), labels (Breakfast | Lunch | Dinner | Soup | Salad | Sauce | custom), ingredients (name, measurement, amount at native serving size, section), directions (order, text, section), notes, and an optional `coverImage` (URL string).

#### Scenario: Recipe displays all fields
- **WHEN** a user views a recipe's detail page
- **THEN** all populated fields SHALL be displayed: title, description, type, labels, ingredients (scaled to headcount) grouped by section, directions ordered by section and step, notes, and cover image (if present) at the top of the view

#### Scenario: Custom labels supported
- **WHEN** a user adds a label that is not in the predefined list
- **THEN** the custom label SHALL be saved and displayed with the recipe
