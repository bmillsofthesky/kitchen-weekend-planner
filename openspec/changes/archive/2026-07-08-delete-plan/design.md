## Context

`SettingsView` already has access to `@Environment(\.modelContext)`, `var plan: WeekendPlan`, and `@Query private var allPlans: [WeekendPlan]`. `WeekendPlan` has `@Relationship(deleteRule: .cascade) var mealPlans` which cascades to `RecipeAssignment` and `Theme` — so calling `context.delete(plan)` removes everything. After deletion, `ContentView.loadActivePlan()` fires via `.onChange(of: plans)` and finds no active plan, naturally returning the user to the startup screen.

## Goals / Non-Goals

**Goals:**
- Permanently delete the current plan and all its data with one confirmed tap
- Return the user to the startup/load screen after deletion

**Non-Goals:**
- Soft delete or archiving
- Deleting plans other than the currently active one from this screen (Load Plan covers that)

## Decisions

### Place in a "Danger Zone" section at the bottom of the Settings list

A visually distinct section with a red destructive-style button signals the severity clearly. SwiftUI's `.destructive` button role applies the system red color automatically.

### Use SwiftUI `.confirmationDialog` (action sheet) instead of `.alert`

`.confirmationDialog` is the iOS convention for destructive actions — it presents as an action sheet on iPhone with a prominent red destructive button and a cancel option. An `.alert` is better for short informational messages; an action sheet is better for irreversible actions.

### Delete via `context.delete(plan)` then `try? context.save()`

Cascade rules handle child records. After save, `ContentView`'s `@Query` fires `.onChange`, which calls `loadActivePlan()` — finds no active plan — and shows the startup screen. No extra navigation code needed.
