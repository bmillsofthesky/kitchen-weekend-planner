## 1. Data Model

- [x] 1.1 Add optional `coverImage: String?` field to the `Recipe` model
- [x] 1.2 Update `Codable` conformance / JSON encoding-decoding to include `coverImage`

## 2. Recipe Form (Create & Edit)

- [x] 2.1 Add a "Cover Image URL" text field to the manual recipe entry form
- [x] 2.2 Add the same field to the recipe edit form
- [x] 2.3 Bind the field to `coverImage` on save

## 3. Recipe Detail View

- [x] 3.1 Display `AsyncImage` at the top of the recipe detail view when `coverImage` is non-nil
- [x] 3.2 Show a placeholder (generic food icon or empty space) when `coverImage` is nil or fails to load

## 4. Recipe Library Card

- [x] 4.1 Show a thumbnail version of `coverImage` in the recipe card in the library list view
- [x] 4.2 Show a placeholder icon in the card when no cover image is set
