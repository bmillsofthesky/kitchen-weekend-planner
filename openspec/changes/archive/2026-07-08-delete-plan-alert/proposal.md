## Why

The deletion confirmation currently uses a `.confirmationDialog`, which presents as a bottom action sheet. The preference is for a popup alert instead — a centered modal that feels more deliberate and less like a system sheet.

## What Changes

- Replace `.confirmationDialog` with `.alert` for the delete confirmation in `SettingsView`

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- `plan-management`: Deletion confirmation uses an alert popup instead of an action sheet

## Impact

- `SettingsView.swift` only — swap `.confirmationDialog` for `.alert`
