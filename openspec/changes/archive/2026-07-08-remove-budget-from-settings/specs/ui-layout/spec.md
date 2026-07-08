## MODIFIED Requirements

### Requirement: Budget accessible from any screen via toolbar
A budget button SHALL be present in the top navigation bar on every main tab. The Settings page SHALL NOT display a dedicated Budget section — budget information is accessible exclusively via the toolbar sheet.

#### Scenario: No budget section in Settings list
- **WHEN** a user navigates to the Settings tab
- **THEN** no Budget section SHALL appear in the Settings list

#### Scenario: Budget button still visible in Settings nav bar
- **WHEN** a user is on the Settings tab
- **THEN** the budget toolbar button SHALL still be visible in the top-right navigation bar

#### Scenario: Budget sheet opens from Settings
- **WHEN** a user taps the budget button on the Settings tab
- **THEN** the budget sheet SHALL appear with the progress bar, percentage, and status label
