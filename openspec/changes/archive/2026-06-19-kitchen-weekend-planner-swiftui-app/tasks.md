## 1. Project Setup

- [x] 1.1 Create new Xcode project with SwiftUI and SwiftData, targeting iOS 17+
- [x] 1.2 Configure app entitlements: network access, photo library, mail
- [x] 1.3 Add bundled movement configuration JSON file (NGVN, TDNG, GMVN, etc.) to app bundle
- [x] 1.4 Set up SwiftData model container and persistence stack

## 2. Data Models

- [x] 2.1 Define `MovementConfiguration` SwiftData model (name, abbr, days, meals, headcount, budget, exportEmail)
- [x] 2.2 Define `DayConfig` and `MealConfig` embedded types with potluck eligibility flag
- [x] 2.3 Define `WeekendPlan` SwiftData model (name, movement reference, createdAt, isActive)
- [x] 2.4 Define `MealPlan` SwiftData model (day, mealType, isPotluck, recipeAssignments, theme)
- [x] 2.5 Define `Recipe` SwiftData model (all fields from spec including isCustom flag)
- [x] 2.6 Define `Ingredient` and `Direction` embedded types with section support
- [x] 2.7 Define `Theme` SwiftData model (title, coverImage, description, designDetails, skits)
- [x] 2.8 Define `NeededItem` and `Skit` embedded types
- [x] 2.9 Define `RecipeAssignment` join model (mealPlan, recipe, slot: Main/Side/Dessert, order)

## 3. Weekend Configuration Seeding

- [x] 3.1 Write `ConfigurationSeeder` that reads bundled JSON on first launch and inserts `MovementConfiguration` records
- [x] 3.2 Implement import of a new movement configuration JSON file (overwrites existing by abbreviation)
- [x] 3.3 Verify configurations are read-only in the UI (no edit/delete controls)

## 4. Startup & Plan Management

- [x] 4.1 Build `StartupView` showing New / Load / Import plan buttons when no active plan exists
- [x] 4.2 Implement auto-load of last active plan on subsequent launches
- [x] 4.3 Build `NewPlanFormView` (unique name field + movement picker) with duplicate-name validation
- [x] 4.4 Build `LoadPlanView` listing all stored plans; selecting one sets it as active
- [x] 4.5 Implement plan file import with overwrite flow (delete existing, import, set active)
- [x] 4.6 Implement plan file import with merge flow (auto-merge non-conflicts, present conflict resolution UI)
- [x] 4.7 Expose plan management navigation from Settings tab (reachable at all times)

## 5. Plan Overview

- [x] 5.1 Build `PlanOverviewView` displaying meal cards in day + meal order
- [x] 5.2 Implement meal card component showing day, meal name, theme title, and recipe summary line
- [x] 5.3 Handle empty state cards for meals with no recipes assigned

## 6. Recipe Library

- [x] 6.1 Build `RecipeLibraryView` with search/filter by title, type, and labels
- [x] 6.2 Implement recipe sync: fetch public JSON from configurable URL (plist key `RecipeSyncURL`), upsert non-custom recipes
- [x] 6.3 Implement web scraping via `WKWebView` + JavaScript Schema.org Recipe extraction
- [x] 6.4 Build `RecipeImportView` (URL entry → scrape → editable form → save as isCustom = true)
- [x] 6.5 Build `RecipeFileImportView` using document picker for JSON file import
- [x] 6.6 Build `ManualRecipeFormView` for manual recipe creation (all fields, sections for ingredients/directions)
- [x] 6.7 Implement single-serving normalization on import (scale ingredient amounts by 1/servings)
- [x] 6.8 Implement cost label calculation (headcount × cost_per_serving → $/$$/$$$/$$$$) with "Unknown" fallback
- [x] 6.9 Build `RecipeDetailView` showing all recipe fields grouped by section

## 7. Meal Planning

- [x] 7.1 Build `MealView` with Recipes tab and Theme tab
- [x] 7.2 Implement View mode: recipe cards tappable to show `RecipeDetailView`
- [x] 7.3 Implement Edit mode toggle; show drag handles and drop targets in Edit mode
- [x] 7.4 Build recipe slot columns: Mains, Sides, Desserts using `dropDestination` targets
- [x] 7.5 Implement `draggable` on recipe cards in the library panel within Meal View
- [x] 7.6 Implement within-slot reorder using `List` `.onMove`
- [x] 7.7 Implement potluck toggle (shown only for potluck-eligible meals per movement config)

## 8. Theme Planning

- [x] 8.1 Build `ThemeEditorView` with fields for title, cover image, description (rich text)
- [x] 8.2 Implement cover image picker from device photo library using `PhotosPicker`
- [x] 8.3 Build design details section with free-text area and needed items list
- [x] 8.4 Implement add/edit/delete `NeededItem` (name, quantity, URL link)
- [x] 8.5 Implement tappable URL links in needed items (open in `SafariServices.SFSafariViewController`)
- [x] 8.6 Build reference images gallery (multi-image picker, scrollable display)
- [x] 8.7 Build `SkitEditorView` for adding/editing skits (name + details/script text)
- [x] 8.8 Support multiple skits per theme with a list and drill-down detail view

## 9. Budget Tracker

- [x] 9.1 Implement `BudgetCalculator` service: sum headcount × cost_per_serving for all assigned recipes
- [x] 9.2 Build persistent `BudgetProgressBar` view component (arc or bar)
- [x] 9.3 Apply green/yellow/red color thresholds based on percentage of budget consumed
- [x] 9.4 Integrate progress bar into app chrome (toolbar or persistent header) visible whenever a plan is active
- [x] 9.5 Ensure no dollar amounts are exposed in any budget-related UI

## 10. Plan Export

- [x] 10.1 Implement `PlanExporter` service that generates a formatted export file (ingredients scaled to headcount)
- [x] 10.2 Check `MFMailComposeViewController.canSendMail()` before initiating export
- [x] 10.3 Compose email pre-addressed to movement configuration's export email with plan file attached
- [x] 10.4 Send email in background; show success alert on completion
- [x] 10.5 Show failure alert with reason if send fails
- [x] 10.6 Implement share sheet fallback if Mail is not configured on the device

## 11. Navigation & App Shell

- [x] 11.1 Build `TabView` with Plan, Recipes, and Settings tabs
- [x] 11.2 Wire navigation stack for meal card → `MealView` → recipe/theme detail drill-down
- [x] 11.3 Build `SettingsView` with access to plan management, configuration import, and recipe sync trigger
- [x] 11.4 Handle first-launch vs. returning-user routing at app startup
