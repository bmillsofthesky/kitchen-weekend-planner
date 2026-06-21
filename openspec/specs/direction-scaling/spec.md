## Purpose

Defines how numeric quantities embedded in recipe direction text are identified and scaled to the active weekend headcount at display time.

## Requirements

### Requirement: Direction text scaled to headcount at display time
When displaying recipe directions, the app SHALL scale numeric quantities that appear immediately before a recognized cooking measurement unit by the ratio `headcount / servingSize`. Scaling SHALL be applied at display time only — stored direction text SHALL remain at native serving size.

#### Scenario: Quantity with unit scaled correctly
- **WHEN** a recipe has `servingSize = 4`, headcount is 8, and a direction reads "Add 2 cups of flour"
- **THEN** the displayed direction SHALL read "Add 4 cups of flour"

#### Scenario: Quantities without recognized units are not scaled
- **WHEN** a direction contains a number not followed by a recognized cooking unit (e.g., "Bake at 350°F for 45 minutes" or "divide into 8 portions")
- **THEN** those numbers SHALL remain unchanged in the displayed direction

#### Scenario: Multiple quantities in one direction are each scaled
- **WHEN** a direction contains multiple unit-qualified quantities (e.g., "Mix 2 cups flour with 1 tsp salt")
- **THEN** each qualifying quantity SHALL be independently scaled by the headcount / servingSize ratio

#### Scenario: Ratio of 1.0 produces no change
- **WHEN** headcount equals `servingSize`
- **THEN** direction text SHALL be displayed unchanged

#### Scenario: Fractional scaled values formatted to two decimal places
- **WHEN** scaling a quantity produces a non-integer result
- **THEN** the displayed value SHALL be formatted to at most two decimal places (e.g., 1.33 not 1.333333)

### Requirement: Recognized cooking units for direction scaling
The system SHALL recognize the following unit words (case-insensitive, singular and plural) as triggers for numeric scaling in direction text: cup, tablespoon, tbsp, teaspoon, tsp, ounce, oz, pound, lb, gram, g, kilogram, kg, milliliter, ml, stick, whole, clove, sprig, can, package, bunch, piece, pinch, dash.

#### Scenario: Case-insensitive unit matching
- **WHEN** a direction contains "2 Cups" or "2 CUPS" or "2 cups"
- **THEN** the quantity SHALL be scaled in all cases

#### Scenario: Plural unit forms recognized
- **WHEN** a direction contains "2 tablespoons" or "1 tablespoon"
- **THEN** both forms SHALL trigger scaling
