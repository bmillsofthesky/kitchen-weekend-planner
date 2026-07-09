## Why

There's currently no way to delete a weekend plan from within the app. Users who create a plan by mistake or want to start fresh have no recourse. The Settings page is the natural home for destructive plan management actions.

## What Changes

- Add a "Delete Plan" button to the Settings page in a dedicated Danger Zone section
- Tapping the button shows a confirmation alert before permanently deleting the plan and all its meal assignments

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- `plan-management`: The Settings page now supports permanent plan deletion with confirmation

## Impact

- `SettingsView.swift` only — add delete button, confirmation alert, and deletion logic
- No model changes needed — `WeekendPlan` already has `.cascade` delete rules on `mealPlans`, which cascade to `RecipeAssignment` and `Theme`
