## MODIFIED Requirements

### Requirement: Budget accessible from any screen via toolbar
A budget button SHALL be present in the top navigation bar on every main tab, allowing the user to view budget utilization without leaving their current screen.

#### Scenario: Budget button visible in top navigation bar on Plan tab
- **WHEN** a user is on the Plan tab
- **THEN** a budget button SHALL be visible in the top-right of the navigation bar

#### Scenario: Budget button visible in top navigation bar on Recipes tab
- **WHEN** a user is on the Recipes tab
- **THEN** a budget button SHALL be visible in the top-right of the navigation bar

#### Scenario: Budget button visible in top navigation bar on Settings tab
- **WHEN** a user is on the Settings tab
- **THEN** a budget button SHALL be visible in the top-right of the navigation bar

#### Scenario: Budget sheet opens on tap
- **WHEN** a user taps the budget button in the navigation bar
- **THEN** a sheet SHALL appear showing the budget progress bar, utilization percentage, and status label

#### Scenario: Budget sheet dismisses on swipe
- **WHEN** the budget sheet is open and the user swipes down
- **THEN** the sheet SHALL dismiss and return the user to their previous screen

#### Scenario: No monetary values in budget sheet
- **WHEN** the budget sheet is displayed
- **THEN** no dollar amounts SHALL be shown — only the progress bar, percentage, and status label
