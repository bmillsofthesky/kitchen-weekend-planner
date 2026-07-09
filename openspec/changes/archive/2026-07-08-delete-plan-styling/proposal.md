## Why

The "Danger Zone" section with the Delete Plan button currently sits above the Export section, not at the bottom of the page. The delete button also doesn't render in red because `role: .destructive` on a `List` `Button` does not guarantee a red label color — it needs an explicit `foregroundStyle`.

## What Changes

- Move the "Danger Zone" section to the bottom of the Settings list (below Export)
- Add `.foregroundStyle(.red)` to the Delete Plan button label so it always renders red

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- none (visual/ordering adjustment only, no requirement changes)

## Impact

- `SettingsView.swift` only — reorder sections and add foreground color modifier
