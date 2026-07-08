## ADDED Requirements

### Requirement: Budget progress bar does not overlap navigation content
The budget progress bar SHALL be rendered in the top safe area inset so that navigation titles, toolbar buttons, and page content are not hidden behind it.

#### Scenario: Navigation bar fully visible on recipe pages
- **WHEN** a user navigates to the recipe library or a recipe detail page
- **THEN** the navigation title and toolbar items SHALL be fully visible and not overlapped by the budget progress bar

#### Scenario: Navigation bar fully visible on meal planning pages
- **WHEN** a user navigates to a meal planning view
- **THEN** the navigation title and toolbar items SHALL be fully visible and not overlapped by the budget progress bar

### Requirement: MealView sub-navigation does not render a bottom tab bar
The Recipes/Theme navigation inside MealView SHALL NOT produce a tab bar at the bottom of the screen. The control for switching between Recipes and Theme SHALL be rendered in the navigation bar area.

#### Scenario: No double tab bar in MealView
- **WHEN** a user opens a meal planning view
- **THEN** only the main app tab bar SHALL be visible at the bottom; no secondary tab bar SHALL appear

#### Scenario: Recipes and Theme views remain accessible
- **WHEN** a user is in MealView
- **THEN** they SHALL be able to switch between the Recipes and Theme views using a control in the navigation bar
