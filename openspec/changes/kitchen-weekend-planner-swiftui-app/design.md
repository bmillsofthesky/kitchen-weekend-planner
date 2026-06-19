## Context

Christian retreat kitchen teams plan multi-day weekends (typically 3 days) for movements like Tres Dias and Vida Nueva. Currently this planning happens across spreadsheets and paper, making it hard to track budget, reuse recipes, and share a polished plan. This is a brand-new standalone iOS app; there is no existing codebase to migrate from.

The app must work fully offline (local persistence), with optional network access for recipe sync and web scraping. All weekend movement configurations are read-only — the kitchen team cannot accidentally corrupt the movement's structure.

## Goals / Non-Goals

**Goals:**
- Deliver a SwiftUI iOS app (iPhone and iPad) that covers the full kitchen planning workflow
- Local-first data persistence with SwiftData
- Recipe library with sync from a public JSON source, web scraping, file import, and manual entry
- Drag-and-drop meal slot assignment per meal (Main, Side, Dessert)
- Per-meal theme editor (description, design details with purchase links, skits)
- Abstract budget progress bar (no raw dollar amounts exposed to the user)
- Background email export of the formatted weekend plan

**Non-Goals:**
- Real-time multi-user collaboration or cloud sync between devices
- A backend API or server infrastructure
- Android or web versions
- Exposing raw cost figures to the user (budget is intentionally opaque)
- Modifying weekend movement configurations within the app

## Decisions

### Persistence: SwiftData
SwiftData (iOS 17+) is chosen over Core Data for its Swift-native model macros, simpler migration, and direct integration with SwiftUI. Given the data model (configs, plans, recipes, themes) is relational but not complex, SwiftData is sufficient and reduces boilerplate.

*Alternatives considered:* Core Data — more mature but verbose. SQLite directly — unnecessary overhead.

### Recipe Sync: Public JSON over HTTP
A publicly hosted JSON file (URL configurable via a bundled plist) acts as the canonical recipe source. On launch (or manual refresh), the app fetches the file and upserts recipes by a stable ID. This avoids a backend and lets the recipe maintainer push updates via a static host (GitHub, S3, etc.).

*Alternatives considered:* iCloud CloudKit — adds Apple account dependency. Custom API — unnecessary operational overhead.

### Web Scraping: WKWebView + Heuristic Extraction
For importing recipes from URLs, the app uses `WKWebView` to load the page and runs a JavaScript extraction heuristic targeting Schema.org `Recipe` structured data. Fallback: manual field entry pre-populated with scraped text. Full fidelity scraping is not guaranteed — the UI always allows the user to correct fields before saving.

*Alternatives considered:* Server-side scraping proxy — adds backend dependency. Third-party recipe API — cost and dependency risk.

### Budget Abstraction: Progress Bar with Hidden Figures
The progress bar renders as a color-coded arc/bar (green → yellow → red) driven by `(sum of headcount × cost_per_serving for all assigned recipes) / weekend budget`. No raw dollar values are shown anywhere in the UI.

### Export: Background Email via `MFMailComposeViewController` / `MessageUI`
The formatted plan (JSON or a human-readable Markdown/PDF) is attached to an email pre-addressed to the movement's configured email. The export runs on a background queue; the user sees a success/failure alert. `MFMailComposeViewController` is used so no SMTP credentials are stored.

*Alternatives considered:* Share Sheet — doesn't meet the "send to a specific address in background" requirement. Custom SMTP — security and credential management risk.

### Navigation: TabView with Contextual Drill-Down
Top-level tabs: **Plan** (overview cards), **Recipes** (library), **Settings**. Tapping a meal card navigates into the Meal View (recipes + theme tabs). Recipe detail and theme editor are pushed onto the navigation stack.

### Drag and Drop: SwiftUI `draggable` / `dropDestination`
Recipe cards in the library panel are `draggable`. Meal slot columns are `dropDestination` targets. Within a meal slot, recipes can be reordered via `List` with `.onMove`. This is SwiftUI-native and works on both iPhone (long-press to initiate) and iPad (pointer drag).

## Risks / Trade-offs

- **Web scraping reliability** → Mitigation: Always show an editable form after scraping so users can fix broken fields; log failures silently.
- **SwiftData iOS 17+ requirement** → Mitigation: Set deployment target to iOS 17; document this requirement clearly. Kitchen teams likely have modern devices.
- **Email availability on device** (`MFMailComposeViewController` requires a configured Mail account) → Mitigation: Check `canSendMail()` and show a fallback share sheet if Mail is not configured.
- **Recipe JSON sync conflicts** (user edited a synced recipe, then sync overwrites it) → Mitigation: User-created and user-edited recipes are flagged `isCustom = true` and are never overwritten by sync; only recipes with `isCustom = false` are updated.
- **Large recipe library performance** → Mitigation: Use SwiftData `@Query` with `SortDescriptor` and predicate filtering; lazy-load lists.

## Resolved Decisions

### Recipe Source: Per-Movement GitHub URL
Each movement configuration defines its own `recipesUrl` field pointing to a raw GitHub-hosted JSON file. Movements maintain independent recipe libraries. The sync logic fetches from the URL defined in the active plan's movement configuration — there is no global recipe source.

### Export Email: Single Address Per Movement
One `exportEmail` field per movement configuration. If the movement wants multiple recipients, they use a group list address. The app has no multi-recipient UI.

### Export Format: JSON for Claude AI Shopping Pipeline
The weekend plan is exported as a structured JSON file designed to feed an AI-powered shopping and cost analysis process. The export schema must be designed for machine readability and Claude AI reasoning, not human presentation. See the Export Schema section below.

### Potluck Eligibility: Per-Meal Flag in Movement Configuration
Each meal entry in the movement configuration includes a `potluckEligible` boolean. The movement decides which meals can be designated as potluck. The app renders the potluck toggle only for flagged meals.

## Export Schema

The export JSON feeds a Claude AI process responsible for shopping, delivery coordination, and cost analysis. The schema must serve that process, not the kitchen team's UI concerns.

### Key design principles

- **Cost data is included** even though it is hidden from the kitchen team UI. The AI shopping process needs it for cost analysis.
- **Ingredients are scaled to headcount** (amount × headcount) so the AI receives purchase quantities directly.
- **Theme needed-items are included** alongside food ingredients — they are purchases too and the shopping process should handle them.
- **Units should be normalized** where possible to avoid ambiguity (e.g., avoid mixing "3 lbs" and "48 oz" for the same ingredient type).

### Proposed export structure

```json
{
  "plan": {
    "name": "",
    "movement": { "name": "", "abbr": "", "headcount": 0, "budget": 0.00 },
    "exportedAt": ""
  },
  "meals": [
    {
      "day": 1,
      "mealType": "Breakfast | Lunch | Dinner",
      "isPotluck": false,
      "theme": {
        "title": "",
        "neededItems": [
          { "name": "", "amount": 0, "link": "" }
        ]
      },
      "recipes": [
        {
          "title": "",
          "slot": "Main | Side | Dessert",
          "costPerServing": 0.00,
          "totalCost": 0.00,
          "ingredients": [
            {
              "name": "",
              "section": "",
              "measurement": "",
              "scaledAmount": ""
            }
          ]
        }
      ]
    }
  ],
  "summary": {
    "totalFoodCost": 0.00,
    "budgetUtilization": 0.00,
    "allIngredients": []
  }
}
```

### Ingredient consolidation: per-recipe, Claude consolidates

The app exports ingredients per-recipe without consolidation. The Claude shopping process is responsible for consolidating across recipes and performing unit conversions (e.g., "4 cups flour" + "5 cups flour" → "9 cups flour"; "2 lbs butter" + "3 sticks butter" → resolved total). This avoids building a unit conversion library in Swift and lets Claude handle the fuzzy, real-world messiness of recipe units.

The `summary.allIngredients` field is therefore omitted — the Claude process derives its own consolidated list from `meals[*].recipes[*].ingredients`.

### Food vs. décor: separate arrays

Theme `neededItems` (decorations, table settings, props) are kept in a separate array from food ingredients. Food purchasing and decoration purchasing are typically handled by different people or vendors in the retreat context. The Claude process can route them independently — grocery order vs. Amazon/décor order.

### Directions: excluded from export

Directions are not included in the export. The shopping process does not need them. If a downstream "cooking plan" use case emerges, directions can be added as an opt-in field later.
