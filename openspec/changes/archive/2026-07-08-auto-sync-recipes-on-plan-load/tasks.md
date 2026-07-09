## 1. Auto-sync on plan load

- [x] 1.1 In `ContentView`, add `.onChange(of: activePlan)` that fires when `activePlan` transitions from nil to non-nil; inside the handler, find the matching `movement` from `movements` and call `Task { try? await RecipeSyncService.sync(movement: movement, context: context) }`
