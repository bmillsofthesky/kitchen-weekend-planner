## Context

`SettingsView` currently uses `.confirmationDialog` (bottom action sheet) for deletion confirmation. SwiftUI's `.alert` modifier presents a centered popup dialog, which is what the user wants.

## Goals / Non-Goals

**Goals:**
- Centered popup alert for delete confirmation instead of a bottom action sheet

**Non-Goals:**
- Changing the confirmation message, button labels, or deletion behavior

## Decisions

### Use `.alert` with title, message, and two buttons

SwiftUI's `.alert(_:isPresented:actions:message:)` presents a centered popup with the plan name in the title. The destructive button calls `deletePlan()` and a cancel button dismisses without action. The same `showDeleteConfirmation` state bool drives it — only the modifier changes.
