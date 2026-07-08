## MODIFIED Requirements

### Requirement: Budget progress bar does not overlap navigation content
The budget progress bar SHALL NOT be rendered as persistent chrome above navigation bars. Budget utilization SHALL be displayed in the Settings tab only.

#### Scenario: No budget bar visible outside Settings
- **WHEN** a user is on the Plan, Recipes, or any drill-down view
- **THEN** no budget progress bar SHALL be visible at the top of the screen

#### Scenario: Budget visible in Settings
- **WHEN** a user navigates to the Settings tab
- **THEN** a budget progress bar and utilization status label SHALL be displayed in a Budget section
