## Purpose

Enables the user to export the active weekend plan as a structured JSON file delivered via email to the movement configuration address, for consumption by a Claude AI shopping and cost analysis process.

## Requirements

### Requirement: Background export via email
The user SHALL be able to trigger an export of the active weekend plan. The app SHALL send a JSON file to the email address specified in the movement configuration. The export SHALL run in the background and the user SHALL receive a success or failure alert upon completion.

#### Scenario: Export triggered by user
- **WHEN** the user taps the Export button
- **THEN** the app SHALL begin composing and sending the email in the background without blocking the UI

#### Scenario: Success alert on export completion
- **WHEN** the email is sent successfully
- **THEN** the user SHALL see a success alert

#### Scenario: Failure alert on export error
- **WHEN** the email fails to send (e.g., no mail account configured, network error)
- **THEN** the user SHALL see a failure alert with a brief reason

#### Scenario: No file delivered to user
- **WHEN** the export completes
- **THEN** the user SHALL NOT receive a file in their Files app or share sheet — only an email is sent

### Requirement: Export uses movement configuration email
The export SHALL always be addressed to the email defined in the active weekend plan's movement configuration. The user SHALL NOT be prompted to enter or modify the recipient address.

#### Scenario: Email pre-addressed to movement email
- **WHEN** the export is triggered
- **THEN** the recipient SHALL be the email address from the movement configuration, with no user input required

### Requirement: Export file format — JSON
The exported file SHALL be a valid JSON file (`.json`) structured for machine consumption by a Claude AI shopping and cost analysis process. It SHALL NOT be a PDF, CSV, or human-formatted document.

#### Scenario: Export file is valid JSON
- **WHEN** the export file is generated
- **THEN** the file SHALL parse as valid JSON with no errors

### Requirement: Export JSON structure
The exported JSON SHALL conform to the following top-level structure:

```
plan        — name, movement (name, abbr, headcount, budget), exportedAt timestamp
meals[]     — ordered by day and meal type; each meal contains:
  day           — integer
  mealType      — "Breakfast" | "Lunch" | "Dinner"
  isPotluck     — boolean
  theme         — title and neededItems[] (name, amount, link)
  recipes[]     — each recipe contains:
    title         — string
    slot          — "Main" | "Side" | "Dessert"
    costForRecipe  — number (cost at native serving size)
    totalCost      — (headcount / servingSize) × costForRecipe
    ingredients[] — name, section, measurement, scaledAmount (amount scaled to headcount)
```

Directions SHALL NOT be included in the export.

#### Scenario: Meals ordered correctly
- **WHEN** the export file is generated
- **THEN** meals SHALL appear in ascending day order, with Breakfast before Lunch before Dinner within each day

#### Scenario: Ingredients scaled to headcount
- **WHEN** the export file is generated
- **THEN** each ingredient's `scaledAmount` SHALL equal the native-serving amount multiplied by `headcount / servingSize`

#### Scenario: Cost fields included despite UI hiding
- **WHEN** the export file is generated
- **THEN** `costForRecipe` and `totalCost` SHALL be included in each recipe even though these values are never displayed in the app UI

### Requirement: Recipe cost in export
The exported plan SHALL include each recipe's `costForRecipe` (native batch cost) and a calculated `totalCost` equal to `(headcount / servingSize) * costForRecipe`, representing the cost to feed the weekend headcount with that recipe.

#### Scenario: Export includes scaled total cost
- **WHEN** a plan is exported and a recipe has `costForRecipe = 20.00`, `servingSize = 4`, and headcount is 8
- **THEN** the exported recipe SHALL include `totalCost = 40.00`

#### Scenario: Export includes native cost for recipe
- **WHEN** a plan is exported
- **THEN** the exported recipe SHALL include `costForRecipe` reflecting the cost at the recipe's native serving size

### Requirement: Ingredients exported per-recipe without consolidation
The export SHALL include ingredients per recipe without consolidating or deduplicating across recipes. The consuming Claude AI process is responsible for consolidating ingredients and performing unit conversions (e.g., combining "4 cups flour" from one recipe with "5 cups flour" from another).

#### Scenario: Duplicate ingredients not merged
- **WHEN** two recipes both use the same ingredient
- **THEN** each recipe SHALL list that ingredient independently in its own `ingredients` array

### Requirement: Theme needed-items exported separately from food ingredients
Theme needed-items (decorations, props, table settings) SHALL be exported in a separate `theme.neededItems` array within each meal, distinct from food `ingredients`. They SHALL NOT be mixed into the recipe ingredient lists.

#### Scenario: Needed items in theme object
- **WHEN** a meal has theme needed-items
- **THEN** they SHALL appear under `meals[n].theme.neededItems` and not within any recipe's `ingredients`

### Requirement: Mail availability fallback
If the device does not have a configured Mail account, the app SHALL detect this and show a fallback option (e.g., share sheet) rather than failing silently.

#### Scenario: No mail account — fallback offered
- **WHEN** the user triggers export and the device cannot send mail
- **THEN** the app SHALL inform the user and offer an alternative way to share the JSON file (e.g., share sheet)
