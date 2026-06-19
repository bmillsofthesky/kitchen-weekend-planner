## 1. Remove Config Import UI from SettingsView

- [x] 1.1 Delete the `@State private var showImportConfig = false` property from `SettingsView`
- [x] 1.2 Remove the "Configuration" `Section` block (containing the "Import Movement Config" button) from `SettingsView.body`
- [x] 1.3 Remove the `.sheet(isPresented: $showImportConfig) { ConfigImportView() }` modifier from `SettingsView`

## 2. Remove ConfigImportView

- [x] 2.1 Delete the `ConfigImportView` struct and its `// MARK: - Config Import` section from `SettingsView.swift`

## 3. Clean Up ConfigurationSeeder

- [x] 3.1 Check `ConfigurationSeeder.swift` for `importFromURL` — confirm it has no callers other than the deleted `ConfigImportView`
- [x] 3.2 Delete the `importFromURL` method from `ConfigurationSeeder`
- [x] 3.3 Remove any imports in `ConfigurationSeeder` that were only needed by `importFromURL` (e.g. `UniformTypeIdentifiers` if present)

## 4. Clean Up SettingsView Imports

- [x] 4.1 Remove `import UniformTypeIdentifiers` from `SettingsView.swift` if it is no longer referenced after the deletion
