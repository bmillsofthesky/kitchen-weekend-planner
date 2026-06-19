## Why

The Settings view exposes an "Import Movement Config" button that lets users load a JSON file to update weekend configuration at runtime. This is unnecessary complexity — the movement configuration is static data that belongs in the bundled `movements.json` resource file, not imported by end users.

## What Changes

- Remove the "Configuration" section from `SettingsView` (the "Import Movement Config" button)
- Remove the `ConfigImportView` struct and all associated state (`showImportConfig`, `.sheet(isPresented: $showImportConfig)`)
- Remove `ConfigurationSeeder.importFromURL` usage from the UI layer (seeder may remain for internal use)
- The `movements.json` resource file remains the sole source of movement configuration data

## Capabilities

### New Capabilities
<!-- None introduced — this is a removal change -->

### Modified Capabilities
- `weekend-configuration`: Removing user-facing file import; configuration is now exclusively sourced from the bundled `movements.json` resource

## Impact

- `KitchenPlanner/Sources/Views/Settings/SettingsView.swift` — remove `ConfigImportView`, related state, and sheet modifier
- `KitchenPlanner/Sources/Services/ConfigurationSeeder.swift` — `importFromURL` method may become dead code; evaluate for removal
- No API or data model changes required
