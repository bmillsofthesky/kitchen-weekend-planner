## Purpose

Defines how recipes store and use their native serving size to correctly scale ingredient amounts and costs to the active weekend headcount.

## Requirements

### Requirement: Recipe native serving size
Each recipe SHALL store a `servingSize: Int` representing the number of servings the recipe's ingredient amounts are written for. This value defaults to 1 for manually entered recipes and is parsed from source data on import.

#### Scenario: Serving size stored from sync source
- **WHEN** a recipe is synced from the remote JSON source and the source includes a `servingSize` field
- **THEN** the recipe SHALL store that value as its `servingSize`

#### Scenario: Serving size defaults to 1 for manual entry
- **WHEN** a user creates a recipe manually without specifying a serving size
- **THEN** the recipe SHALL store `servingSize = 1`

#### Scenario: Serving size preserved on URL import
- **WHEN** a recipe is imported from a URL with Schema.org Recipe markup that includes a `recipeYield`
- **THEN** the recipe SHALL store the parsed integer yield as its `servingSize`

### Requirement: Recipe cost stored as cost for recipe batch
Each recipe SHALL store `costForRecipe: Double?` representing the total cost to prepare the recipe at its native `servingSize`. A nil value means cost is unknown.

#### Scenario: Cost for recipe stored on sync
- **WHEN** a recipe is synced from the remote JSON source
- **THEN** `costForRecipe` SHALL be stored as provided by the source (or derived from `costPerServing * servingSize` if the source only provides `costPerServing`)

#### Scenario: Unknown cost when not provided
- **WHEN** a recipe has no cost data provided
- **THEN** `costForRecipe` SHALL be nil

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
