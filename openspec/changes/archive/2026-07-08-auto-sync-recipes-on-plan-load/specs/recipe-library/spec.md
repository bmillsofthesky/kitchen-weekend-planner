## MODIFIED Requirements

### Requirement: Sync recipes from public JSON source
The app SHALL fetch recipes from a configurable public JSON URL and upsert them into local storage. Only recipes with `isCustom = false` SHALL be updated by sync; user-created or user-edited recipes SHALL NOT be overwritten. A sync SHALL also be triggered automatically in the background when the active weekend plan loads.

#### Scenario: Sync updates non-custom recipes
- **WHEN** a sync is triggered and the remote source contains a recipe that exists locally with isCustom = false
- **THEN** the local recipe SHALL be updated with the remote data

#### Scenario: Sync does not overwrite custom recipes
- **WHEN** a sync is triggered and a recipe exists locally with isCustom = true
- **THEN** that recipe SHALL NOT be modified by the sync

#### Scenario: Sync adds new recipes
- **WHEN** a sync is triggered and the remote source contains a recipe not present locally
- **THEN** the new recipe SHALL be added to local storage with isCustom = false

#### Scenario: Auto-sync on plan load
- **WHEN** the active weekend plan becomes available on app launch or plan switch
- **THEN** the app SHALL automatically trigger a background recipe sync without any user interaction or visible loading state

#### Scenario: Auto-sync errors are silent
- **WHEN** the background sync fails (e.g., network unavailable)
- **THEN** no error SHALL be shown to the user and the existing local recipes SHALL remain unchanged
