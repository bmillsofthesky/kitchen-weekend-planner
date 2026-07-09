## Purpose

Defines the dedicated potluck meal screen, which replaces the standard recipe/theme planning interface when a meal is marked as a potluck.

## Requirements

### Requirement: Potluck meals display a dedicated coordination view
When a meal is marked as a potluck, the planner SHALL display a `PotluckView` instead of the standard recipe/theme planning interface. The view SHALL clearly communicate that the meal is a potluck and allow the user to store a link to a coordination service.

#### Scenario: Potluck view shown for potluck meals
- **WHEN** a user taps a meal card that has `isPotluck: true`
- **THEN** the app SHALL navigate to `PotluckView`, not the standard `MealView`

#### Scenario: User can enter a coordination service URL
- **WHEN** a user is on `PotluckView`
- **THEN** a text field SHALL be present for entering a URL to a potluck coordination service (e.g., SignUpGenius)

#### Scenario: Entered URL is persisted
- **WHEN** a user types a URL into the coordination link field
- **THEN** the URL SHALL be saved to `MealPlan.potluckUrl` and persist across app launches

#### Scenario: Saved URL is tappable
- **WHEN** a coordination URL has been entered and the user taps the "Open link" button
- **THEN** the URL SHALL open in the system browser via `openURL`

#### Scenario: No URL entered shows placeholder
- **WHEN** no coordination URL has been entered
- **THEN** the URL field SHALL show placeholder text indicating what to enter
