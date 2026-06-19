## MODIFIED Requirements

### Requirement: Read-only movement configurations
Users SHALL NOT be able to create, edit, or delete movement configurations through the app UI. Configurations are managed exclusively by the bundled `movements.json` resource file — no runtime file import is supported.

#### Scenario: No edit controls exposed
- **WHEN** a user views a movement configuration
- **THEN** no edit, delete, or save controls SHALL be displayed

#### Scenario: No import option in Settings
- **WHEN** a user navigates to the Settings screen
- **THEN** no "Import Movement Config" button or configuration import section SHALL be present

## REMOVED Requirements

### Requirement: Import overwrites existing configuration
**Reason**: Runtime configuration import is removed. Movement configs are now exclusively bundled in `movements.json` and cannot be updated by end users through the UI.
**Migration**: Update `movements.json` in the app bundle to change configuration data; no user-facing migration needed as existing SwiftData records are preserved.
