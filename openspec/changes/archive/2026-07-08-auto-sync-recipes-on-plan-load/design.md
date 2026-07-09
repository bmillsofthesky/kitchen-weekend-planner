## Context

`RecipeSyncService.sync` exists and works correctly. It's currently invoked manually from `RecipeLibraryView`. `ContentView` already detects when an active plan loads via `loadActivePlan()` called from `.onAppear` and `.onChange(of: plans)`. The movement configuration (which carries `recipesUrl`) is also available in `ContentView` via `@Query`.

## Goals / Non-Goals

**Goals:**
- Trigger a background recipe sync whenever an active plan becomes available in `ContentView`
- Keep the sync silent — no loading indicator, no error surface to the user

**Non-Goals:**
- Syncing on every app foreground (only on plan load)
- Showing sync progress or errors to the user
- Retry logic or offline queuing

## Decisions

### Trigger location: `ContentView` via `.onChange(of: activePlan)`

`ContentView` is the earliest point where both `activePlan` and `movement` are resolved together. Adding a `.onChange(of: activePlan)` that fires when the value transitions to non-nil is the cleanest hook — it runs once per plan load without duplicating the `loadActivePlan` logic.

Alternative considered: trigger from `MainTabView.onAppear`. Rejected because `MainTabView` reappears on tab switches and sheet dismissals, which would fire the sync too often.

### Error handling: silent discard

`RecipeSyncService.sync` is already `throws`. Wrapping the call in `try? await` keeps the auto-sync invisible to the user, consistent with how other background operations in the app work. Network failures on launch are common (airplane mode, poor signal) and shouldn't surface an error the user didn't ask for.

## Risks / Trade-offs

- **Extra network request on every cold launch**: Low impact — the JSON payload is small and the request is skippable when `recipesUrl` is empty (already handled in `RecipeSyncService`).
- **Race with SwiftData queries**: The sync writes to `ModelContext` on `@MainActor`. Since `ContentView` and `RecipeSyncService` both run on `@MainActor`, there's no concurrency issue.
