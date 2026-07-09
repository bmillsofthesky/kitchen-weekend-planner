## 1. Delete Plan in SettingsView

- [x] 1.1 Add `@State private var showDeleteConfirmation = false` to `SettingsView`
- [x] 1.2 Add a `Section("Danger Zone")` at the bottom of the `List` with a `Button("Delete Plan", role: .destructive)` that sets `showDeleteConfirmation = true`
- [x] 1.3 Add `.confirmationDialog("Delete \(plan.name)?", isPresented: $showDeleteConfirmation, titleVisibility: .visible)` with a destructive "Delete permanently" action that calls `deletePlan()` and a cancel button
- [x] 1.4 Add `private func deletePlan()` that calls `context.delete(plan)` and `try? context.save()`
