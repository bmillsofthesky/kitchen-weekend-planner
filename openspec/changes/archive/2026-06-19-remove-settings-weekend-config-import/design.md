## Context

`SettingsView` currently has a "Configuration" section with an "Import Movement Config" button that opens `ConfigImportView`. This allows users to load a JSON file at runtime to update `MovementConfiguration` records in SwiftData. The intent was to support field updates to movement configs, but this creates an unnecessary surface: configs are stable, curated data that should ship with the app via `movements.json`.

`ConfigurationSeeder` has two responsibilities: seeding from the bundled resource on first launch, and `importFromURL` for the now-to-be-removed runtime import. After this change, `importFromURL` becomes dead code.

## Goals / Non-Goals

**Goals:**
- Remove the "Import Movement Config" UI entry point from Settings entirely
- Remove `ConfigImportView` struct and all wiring in `SettingsView`
- Remove or mark dead `ConfigurationSeeder.importFromURL` (delete if it has no other callers)
- Keep `movements.json` and the seeder's first-launch seeding path untouched

**Non-Goals:**
- Changing the data model for `MovementConfiguration`
- Modifying how configs are seeded on first launch
- Adding any new UI in place of the removed section

## Decisions

**Remove `importFromURL` entirely rather than keeping it private**
It has one call site (`ConfigImportView`) which is being deleted. Dead code with no external callers should be removed, not preserved. If a future admin/debug need arises, it can be re-added with proper scoping then.

**No migration needed**
Users who previously imported a custom config will retain their SwiftData records — nothing is wiped. The removal only eliminates the ability to import new ones. This is acceptable since configs are managed by the app bundle.

## Risks / Trade-offs

- [Power-user regression] A user relying on the import to override a config loses that path → Acceptable; this use case is out of scope and configs should be updated via app releases.
- [Dead code warning] `ConfigurationSeeder.importFromURL` becomes unused → Mitigated by deleting it in the same change.
