## Purpose

Defines the structure and lifecycle of weekend movement configurations — the bundled, read-only definitions of movement names, days, meals, headcount, budget, and export email.

## Requirements

### Requirement: Preloaded movement configurations
The app SHALL ship with a set of preloaded weekend movement configurations bundled as a JSON file. Each configuration SHALL include: name, abbreviation, days (with ordered day numbers and assigned meals), headcount, budget, and export email address.

#### Scenario: Configurations available on first launch
- **WHEN** the app is launched for the first time
- **THEN** all bundled movement configurations SHALL be available for selection without any network request

#### Scenario: Configuration fields are complete
- **WHEN** a movement configuration is loaded
- **THEN** it SHALL contain name, abbreviation, at least one day, meals per day, headcount, budget, and export email

### Requirement: Read-only movement configurations
Users SHALL NOT be able to create, edit, or delete movement configurations through the app UI. Configurations are managed only by bundled data or by importing a new configuration file.

#### Scenario: No edit controls exposed
- **WHEN** a user views a movement configuration
- **THEN** no edit, delete, or save controls SHALL be displayed

### Requirement: Meal slot definitions per movement
Each movement configuration SHALL define which meals (Breakfast, Lunch, Dinner) appear on each day of the weekend, in sequential day order starting at day 1 with no gaps.

#### Scenario: Days are ordered sequentially
- **WHEN** a weekend plan is loaded for a movement
- **THEN** days SHALL be displayed in sequential order from day 1 through the last day with no missing day numbers

#### Scenario: Only configured meals appear
- **WHEN** a user views a day in the meal planner
- **THEN** only the meal slots defined in the movement configuration for that day SHALL be displayed

### Requirement: Potluck eligibility flag per meal
The movement configuration SHALL support marking individual meal slots as potluck-eligible.

#### Scenario: Potluck option available for eligible meals
- **WHEN** a meal slot is flagged as potluck-eligible in the configuration
- **THEN** the user SHALL be able to designate that meal as a potluck in the weekend plan

#### Scenario: Potluck option unavailable for ineligible meals
- **WHEN** a meal slot is NOT flagged as potluck-eligible
- **THEN** no potluck toggle SHALL be shown for that meal slot
