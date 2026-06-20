## Purpose

Defines the weekend plan lifecycle: first-launch startup flow, creating, loading, and importing plans, the Plan Overview, and persistent navigation controls for switching between plans.

## Requirements

### Requirement: First-launch startup flow
On first launch the app SHALL present three options: New Weekend Plan, Load Weekend Plan, and Import Weekend Plan.

#### Scenario: First launch shows startup options
- **WHEN** the app is launched and no previous weekend plan exists
- **THEN** the startup screen SHALL display New Weekend Plan, Load Weekend Plan, and Import Weekend Plan buttons

#### Scenario: Subsequent launch loads last active plan
- **WHEN** the app is launched and a previously active weekend plan exists
- **THEN** the app SHALL load directly into the Plan Overview for the last active weekend plan

### Requirement: Create new weekend plan
The user SHALL be able to create a new weekend plan by providing a unique name and selecting a movement configuration.

#### Scenario: Successful plan creation
- **WHEN** the user provides a unique name and selects a movement configuration and submits the form
- **THEN** a new weekend plan SHALL be created, saved to local storage, set as the active plan, and the Plan Overview SHALL be displayed

#### Scenario: Duplicate name rejected
- **WHEN** the user attempts to create a plan with a name that already exists in local storage
- **THEN** an error SHALL be displayed and the plan SHALL NOT be created

### Requirement: Load existing weekend plan
The user SHALL be able to view a list of all locally stored weekend plans and select one to set as the active plan.

#### Scenario: Plan list displayed
- **WHEN** the user opens Load Weekend Plan
- **THEN** all locally stored weekend plans SHALL be listed with their name and associated movement

#### Scenario: Selecting a plan activates it
- **WHEN** the user selects a plan from the list
- **THEN** that plan SHALL become the active plan and the Plan Overview SHALL be displayed

### Requirement: Import weekend plan from file
The user SHALL be able to import a weekend plan from an external file. If the plan already exists locally, the user SHALL be prompted to overwrite or merge.

#### Scenario: Import with overwrite
- **WHEN** the user imports a plan that matches an existing plan name and chooses overwrite
- **THEN** the existing plan SHALL be deleted and replaced with the imported plan, then loaded as active

#### Scenario: Import with merge — no conflicts
- **WHEN** the user imports a plan and chooses merge and there are no conflicting fields
- **THEN** all non-conflicting data from the imported plan SHALL be merged into the existing plan

#### Scenario: Import with merge — conflicts present
- **WHEN** the user imports a plan and chooses merge and conflicts exist
- **THEN** the user SHALL be shown each conflict and prompted to accept either the local or imported value before completing the merge

#### Scenario: Import sets plan as active
- **WHEN** an import (overwrite or merge) completes successfully
- **THEN** the imported plan SHALL be set as the active plan and the Plan Overview SHALL be displayed

### Requirement: Plan Overview
The active weekend plan SHALL display a card for each meal ordered by day and meal type. Each card SHALL show the day and meal name, the theme title (if set), and a summary of assigned recipes (Mains with Sides and Desserts).

#### Scenario: Cards ordered by date and meal
- **WHEN** the Plan Overview is displayed
- **THEN** meal cards SHALL appear in chronological order: day 1 Breakfast, day 1 Lunch, day 1 Dinner, day 2 Breakfast, etc.

#### Scenario: Card summary format
- **WHEN** a meal has recipes assigned
- **THEN** the card SHALL display: `<Day> <Meal>: <Theme Title>` and `<Main> w/ <Sides> and <Dessert> for dessert`

#### Scenario: Empty meal card
- **WHEN** a meal has no recipes assigned
- **THEN** the card SHALL indicate that no recipes have been selected yet

### Requirement: Navigation to manage plans
At any time after initial startup the user SHALL be able to navigate to: start a new weekend plan, load a different plan, import plan updates, or import a new weekend configuration.

#### Scenario: Navigation controls always accessible
- **WHEN** a weekend plan is active
- **THEN** controls to switch or create plans SHALL be reachable from the main navigation (e.g., Settings tab or navigation menu)
