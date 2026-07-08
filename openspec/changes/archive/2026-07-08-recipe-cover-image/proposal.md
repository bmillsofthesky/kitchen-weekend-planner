## Why

Recipes currently lack visual representation, making it hard to quickly identify dishes at a glance. Adding a cover image to each recipe improves the browsing experience and makes the app feel more polished and food-forward.

## What Changes

- Recipes gain an optional `coverImage` field (local asset reference or URL)
- The recipe library view displays cover images in recipe cards
- The recipe detail view shows the cover image prominently at the top
- Adding/editing a recipe includes an option to set a cover image

## Capabilities

### New Capabilities
- `recipe-cover-image`: Associate an optional cover image with a recipe; display in recipe card and detail views

### Modified Capabilities
- `recipe-library`: Recipe cards now display a cover image thumbnail when available

## Impact

- `Recipe` model: add optional `coverImage` field
- Recipe list/card UI: updated to show thumbnail
- Recipe detail view: image displayed at top
- Recipe add/edit form: image picker or URL input
