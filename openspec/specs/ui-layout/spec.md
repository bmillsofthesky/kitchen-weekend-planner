## Purpose

Defines layout rules for persistent chrome, navigation bar placement, and sub-navigation patterns across all views.

## Requirements

### Requirement: Budget progress bar does not overlap navigation content
The budget progress bar SHALL NOT be rendered as persistent chrome above navigation bars. Budget utilization SHALL be displayed in the Settings tab only.

#### Scenario: No budget bar visible outside Settings
- **WHEN** a user is on the Plan, Recipes, or any drill-down view
- **THEN** no budget progress bar SHALL be visible at the top of the screen

#### Scenario: Budget visible in Settings
- **WHEN** a user navigates to the Settings tab
- **THEN** a budget progress bar and utilization status label SHALL be displayed in a Budget section

### Requirement: MealView sub-navigation does not render a bottom tab bar
The Recipes/Theme navigation inside MealView SHALL NOT produce a tab bar at the bottom of the screen. The control for switching between Recipes and Theme SHALL be rendered in the navigation bar area.

#### Scenario: No double tab bar in MealView
- **WHEN** a user opens a meal planning view
- **THEN** only the main app tab bar SHALL be visible at the bottom; no secondary tab bar SHALL appear

#### Scenario: Recipes and Theme views remain accessible
- **WHEN** a user is in MealView
- **THEN** they SHALL be able to switch between the Recipes and Theme views using a control in the navigation bar
