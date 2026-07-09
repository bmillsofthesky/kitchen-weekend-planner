# Plan Management Spec

## Purpose

Defines requirements for managing the lifecycle of a weekend kitchen plan, including creation, loading, import/export, and deletion from the Settings page.

## Requirements

### Requirement: Settings page provides plan lifecycle management
The Settings page SHALL provide controls for creating, loading, importing, exporting, and permanently deleting the active plan. The Delete Plan button SHALL appear as the bottommost action on the page in red. Tapping it SHALL present a centered alert popup (not a bottom action sheet) to confirm deletion.

#### Scenario: Delete Plan button visible in Settings
- **WHEN** a user navigates to the Settings tab
- **THEN** a "Delete Plan" button SHALL be visible in a Danger Zone section at the bottom of the list

#### Scenario: Delete Plan button is the last item on the Settings page
- **WHEN** a user scrolls to the bottom of the Settings page
- **THEN** the Delete Plan button SHALL be the last visible action

#### Scenario: Delete Plan button is red
- **WHEN** the Delete Plan button is displayed
- **THEN** its label and icon SHALL render in red

#### Scenario: Delete confirmation shown as centered alert
- **WHEN** a user taps "Delete Plan"
- **THEN** a centered alert popup SHALL appear with the plan name and a warning that the action is permanent

#### Scenario: Plan deleted on confirmation
- **WHEN** the user confirms deletion in the alert
- **THEN** the active plan and all its meal assignments SHALL be permanently deleted and the user SHALL be returned to the startup screen

#### Scenario: Deletion cancelled
- **WHEN** the user taps Cancel in the alert
- **THEN** no data SHALL be deleted and the user SHALL remain on the Settings page
