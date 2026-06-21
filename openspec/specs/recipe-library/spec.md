## Purpose

Defines the recipe data model, storage, and all methods by which recipes enter the library: sync from a remote JSON source, URL scraping, file import, and manual entry. Also covers cost labeling and ingredient normalization.

## Requirements

### Requirement: Recipe data model
Each recipe SHALL store: title, description, costForRecipe (total cost for the recipe's native serving size), servingSize (number of servings the recipe ingredients are written for), type (Entree | Side | Dessert | Other), labels (Breakfast | Lunch | Dinner | Soup | Salad | Sauce | custom), ingredients (name, measurement, amount at native serving size, section), directions (order, text, section), and notes.

#### Scenario: Recipe displays all fields
- **WHEN** a user views a recipe's detail page
- **THEN** all populated fields SHALL be displayed: title, description, type, labels, ingredients (scaled to headcount) grouped by section, directions ordered by section and step, and notes

#### Scenario: Custom labels supported
- **WHEN** a user adds a label that is not in the predefined list
- **THEN** the custom label SHALL be saved and displayed with the recipe

### Requirement: Sync recipes from public JSON source
The app SHALL fetch recipes from a configurable public JSON URL and upsert them into local storage. Only recipes with `isCustom = false` SHALL be updated by sync; user-created or user-edited recipes SHALL NOT be overwritten.

#### Scenario: Sync updates non-custom recipes
- **WHEN** a sync is triggered and the remote source contains a recipe that exists locally with isCustom = false
- **THEN** the local recipe SHALL be updated with the remote data

#### Scenario: Sync does not overwrite custom recipes
- **WHEN** a sync is triggered and a recipe exists locally with isCustom = true
- **THEN** that recipe SHALL NOT be modified by the sync

#### Scenario: Sync adds new recipes
- **WHEN** a sync is triggered and the remote source contains a recipe not present locally
- **THEN** the new recipe SHALL be added to local storage with isCustom = false

### Requirement: Import recipe from website URL
The user SHALL be able to enter a URL and have the app attempt to extract recipe data using Schema.org Recipe structured data. The extracted data SHALL be pre-populated into an editable form before saving.

#### Scenario: Successful scrape pre-populates form
- **WHEN** the user provides a URL and the page contains Schema.org Recipe markup
- **THEN** the recipe form SHALL be pre-populated with the extracted title, ingredients, and directions

#### Scenario: Failed scrape falls back to manual entry
- **WHEN** the user provides a URL and no structured recipe data can be extracted
- **THEN** the form SHALL open empty (or with any partial data found) so the user can fill it in manually

#### Scenario: User can edit before saving
- **WHEN** the scraped data is displayed in the form
- **THEN** all fields SHALL be editable before the recipe is saved

### Requirement: Import recipe from file
The user SHALL be able to import a recipe from a JSON file matching the recipe schema.

#### Scenario: Valid file imports recipe
- **WHEN** the user selects a valid recipe JSON file
- **THEN** the recipe SHALL be parsed and saved to local storage with isCustom = true

#### Scenario: Invalid file shows error
- **WHEN** the user selects a file that does not match the recipe schema
- **THEN** an error message SHALL be displayed and no recipe SHALL be saved

### Requirement: Manual recipe entry
The user SHALL be able to manually create a recipe by filling in all fields in a form. Manually created recipes SHALL be saved with isCustom = true.

#### Scenario: Recipe created manually
- **WHEN** the user completes the manual recipe form and saves
- **THEN** the recipe SHALL be saved to local storage with isCustom = true and appear in the recipe library

### Requirement: Recipe cost labeling
Each recipe SHALL display a cost label based on its `costForRecipe` scaled to the active weekend's headcount using the formula `(headcount / servingSize) * costForRecipe`. Cost tiers: Unknown (no cost data), $ (Inexpensive), $$ (Moderate), $$$ (Expensive), $$$$ (Very Expensive).

#### Scenario: Cost label shown in library and meal view
- **WHEN** a recipe is displayed in the library or a meal slot
- **THEN** the appropriate cost label SHALL be shown based on `(headcount / servingSize) * costForRecipe`

#### Scenario: Unknown label for missing cost
- **WHEN** a recipe has no `costForRecipe` value
- **THEN** the label SHALL display "Unknown"

