## 1. Swap confirmation dialog for alert

- [x] 1.1 In `SettingsView`, replace `.confirmationDialog(...)` with `.alert("Delete \(plan.name)?", isPresented: $showDeleteConfirmation)` containing a destructive "Delete permanently" button calling `deletePlan()` and a Cancel button, with a message body warning the action is permanent
