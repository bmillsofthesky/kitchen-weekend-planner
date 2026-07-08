## Context

Recipes are stored locally and can be synced from a remote JSON source or created manually. Currently the `Recipe` model has no visual asset. This change adds an optional `coverImage` field and updates the UI to display it in recipe cards (library view) and recipe detail views.

## Goals / Non-Goals

**Goals:**
- Add `coverImage` (optional URL or local asset path) to the `Recipe` model
- Display cover images as thumbnails in recipe library cards
- Display cover images prominently at the top of the recipe detail view
- Allow users to provide a cover image URL when creating or editing a recipe manually

**Non-Goals:**
- On-device image upload or file picker (URL input only for now)
- Automatic image extraction during URL scraping (out of scope for initial implementation)
- Image caching or pre-fetching beyond what AsyncImage provides natively

## Decisions

**String URL field (not a dedicated image type)**
Cover images are stored as an optional `String?` URL on the `Recipe` model. This keeps the model simple and compatible with the existing JSON sync format. If local asset support is needed in the future, a discriminated union can replace the string.

**Display with AsyncImage**
Since images are URLs, `AsyncImage` (SwiftUI) handles fetching and placeholder rendering. No third-party image library is needed.

**Sync compatibility**
The remote JSON source may include a `coverImage` field; if absent it defaults to `nil`. Non-custom recipes will have their cover image updated on sync like other fields, unless the recipe is `isCustom = true`.

## Risks / Trade-offs

- [Risk] Remote images may be slow to load or unavailable → `AsyncImage` shows a placeholder; no blocking behavior
- [Risk] Existing persisted recipes lack `coverImage` → optional field defaults to `nil` gracefully, no migration needed
