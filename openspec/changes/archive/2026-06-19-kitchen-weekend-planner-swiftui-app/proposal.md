## Why

Christian retreat kitchen teams (e.g., Tres Dias, Vida Nueva) currently plan meals, themes, and shopping lists using disconnected tools, making it difficult to collaborate, track budget, and export a cohesive plan. A dedicated iOS app will centralize meal planning, theme design, and cost tracking in one place for these weekend events.

## What Changes

- New iOS app built with SwiftUI targeting the kitchen team workflow for multi-day Christian retreat weekends
- Preloaded weekend movement configurations (NGVN, TDNG, GMVN, etc.) define days, meals, and budget — read-only to users
- Users can create, load, and import weekend plans tied to a movement configuration
- Recipe library synced from a public JSON source and stored locally; supports web scraping, file import, and manual entry
- Drag-and-drop meal planning with slots for Mains, Sides, and Desserts per meal; first meal can be marked potluck
- Per-meal theme planning with description, design details, needed-item links (Amazon etc.), and skits
- Abstract budget progress bar showing recipe cost vs. weekend budget (exact figures hidden from user)
- Export weekend plan as a formatted file emailed in the background to the movement's configured address

## Capabilities

### New Capabilities

- `weekend-configuration`: Preloaded, read-only movement configs defining days, meals, headcount, budget, and export email
- `weekend-plan`: Create, load, import, and manage weekend plans tied to a movement configuration
- `recipe-library`: Store, sync, scrape, import, and manually create recipes with ingredients, directions, cost-per-serving, and labels
- `meal-planning`: Assign recipes to meal slots (Main, Side, Dessert) via drag-and-drop; support potluck designation for first meal
- `theme-planning`: Per-meal theme editor with description, design details, purchase links, and skits
- `budget-tracker`: Abstract progress bar comparing total recipe cost (headcount × cost-per-serving) against weekend budget
- `plan-export`: Background export of the weekend plan as a formatted file sent via email

### Modified Capabilities

## Impact

- New standalone SwiftUI iOS app — no existing codebase affected
- Requires network access for recipe sync (public JSON source) and web scraping
- Requires email entitlement for background export
- Local persistence via SwiftData or Core Data for plans, recipes, and configurations
- No backend server required; all data local with optional sync from a public recipe source
