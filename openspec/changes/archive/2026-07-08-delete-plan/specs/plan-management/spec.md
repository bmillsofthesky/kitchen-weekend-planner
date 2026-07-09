## MODIFIED Requirements

### Requirement: Settings page provides plan lifecycle management
The Settings page SHALL provide controls for creating, loading, importing, exporting, and permanently deleting the active plan.

#### Scenario: Delete Plan button visible in Settings
- **WHEN** a user navigates to the Settings tab
- **THEN** a "Delete Plan" button SHALL be visible in a Danger Zone section at the bottom of the list

#### Scenario: Confirmation required before deletion
- **WHEN** a user taps "Delete Plan"
- **THEN** a confirmation action sheet SHALL appear naming the plan and warning that the action is permanent

#### Scenario: Plan deleted on confirmation
- **WHEN** the user confirms deletion
- **THEN** the active plan and all its meal assignments SHALL be permanently deleted and the user SHALL be returned to the startup screen

#### Scenario: Deletion cancelled
- **WHEN** the user dismisses the confirmation without confirming
- **THEN** no data SHALL be deleted and the user SHALL remain on the Settings page
