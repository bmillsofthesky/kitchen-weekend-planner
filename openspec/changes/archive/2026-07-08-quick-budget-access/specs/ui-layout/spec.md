## ADDED Requirements

### Requirement: Budget accessible from any screen via toolbar
A budget button SHALL be present in the toolbar on every tab, allowing the user to view budget utilization without leaving their current screen.

#### Scenario: Budget sheet opens from Plan tab
- **WHEN** a user taps the budget button while on the Plan tab
- **THEN** a sheet SHALL appear showing the budget progress bar, utilization percentage, and status label

#### Scenario: Budget sheet opens from Recipes tab
- **WHEN** a user taps the budget button while on the Recipes tab
- **THEN** a sheet SHALL appear showing the budget progress bar, utilization percentage, and status label

#### Scenario: Budget sheet dismisses on swipe
- **WHEN** the budget sheet is open and the user swipes down
- **THEN** the sheet SHALL dismiss and return the user to their previous screen

#### Scenario: No monetary values in budget sheet
- **WHEN** the budget sheet is displayed
- **THEN** no dollar amounts SHALL be shown — only the progress bar, percentage, and status label
