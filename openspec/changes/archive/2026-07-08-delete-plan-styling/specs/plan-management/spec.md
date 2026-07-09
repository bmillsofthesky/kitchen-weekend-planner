## MODIFIED Requirements

### Requirement: Settings page provides plan lifecycle management
The Settings page SHALL provide controls for creating, loading, importing, exporting, and permanently deleting the active plan. The Delete Plan button SHALL appear as the bottommost action on the page and SHALL be rendered in red to signal its destructive nature.

#### Scenario: Delete Plan button is the last item on the Settings page
- **WHEN** a user scrolls to the bottom of the Settings page
- **THEN** the Delete Plan button SHALL be the last visible action

#### Scenario: Delete Plan button is red
- **WHEN** the Delete Plan button is displayed
- **THEN** its label and icon SHALL render in red

#### Scenario: Confirmation required before deletion
- **WHEN** a user taps "Delete Plan"
- **THEN** a confirmation action sheet SHALL appear naming the plan and warning that the action is permanent

#### Scenario: Plan deleted on confirmation
- **WHEN** the user confirms deletion
- **THEN** the active plan and all its meal assignments SHALL be permanently deleted and the user SHALL be returned to the startup screen

#### Scenario: Deletion cancelled
- **WHEN** the user dismisses the confirmation without confirming
- **THEN** no data SHALL be deleted and the user SHALL remain on the Settings page
