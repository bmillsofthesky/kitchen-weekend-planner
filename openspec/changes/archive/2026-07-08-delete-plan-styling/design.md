## Context

`SettingsView` has four sections in this order: Active Plan, Plan Management, Danger Zone, Export. The Danger Zone block needs to move after Export. The button uses `role: .destructive` but SwiftUI only applies the system destructive tint in certain contexts (e.g., swipe actions, menus); in a plain `List` row it may render in the default tint color. Adding `.foregroundStyle(.red)` to the `Label` ensures consistent red rendering.

## Goals / Non-Goals

**Goals:**
- Danger Zone is the last section on the Settings page
- Delete Plan button label is visually red

**Non-Goals:**
- Changing the confirmation dialog behavior
- Removing `role: .destructive` (keep it for accessibility semantics)

## Decisions

### Apply `.foregroundStyle(.red)` to the `Label`, not the `Button`

Applying it to the `Label` colors both the icon and the text red. Applying it to the `Button` may be overridden by the list row styling. This is the most reliable approach.
