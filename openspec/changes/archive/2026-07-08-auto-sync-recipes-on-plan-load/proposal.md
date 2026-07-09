## Why

When a weekend plan loads, the recipe library may be stale relative to the remote JSON source. Users currently have to manually trigger a sync from the Recipe Library tab, which means newly added or updated recipes aren't available until they remember to do it.

## What Changes

- Automatically trigger `RecipeSyncService.sync` when the active plan is first loaded in `ContentView`
- Sync runs silently in the background; no UI blocking or required user interaction
- Errors are silently ignored (same behavior as the existing manual sync path)

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- `recipe-library`: Auto-sync on plan load is a new trigger for the existing sync requirement

## Impact

- `ContentView.swift` — add a `.task` or background `Task` triggered when `activePlan` becomes non-nil
- `RecipeSyncService.swift` — no changes needed; existing `sync` method is already async
