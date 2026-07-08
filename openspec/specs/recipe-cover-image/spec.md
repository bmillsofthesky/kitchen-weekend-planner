## Purpose

Defines the optional cover image feature for recipes: storage of a cover image URL, display in the recipe detail view, and input in the recipe creation and editing form.

## Requirements

### Requirement: Recipe cover image field
A recipe SHALL support an optional `coverImage` field containing a URL string. The field SHALL be optional and default to nil/absent when not provided.

#### Scenario: Recipe with cover image URL is saved
- **WHEN** a user provides a valid URL string as the cover image when creating or editing a recipe
- **THEN** the `coverImage` URL SHALL be persisted with the recipe data

#### Scenario: Recipe without cover image is valid
- **WHEN** a user creates or edits a recipe and does not provide a cover image
- **THEN** the recipe SHALL be saved successfully with no cover image

### Requirement: Cover image displayed in recipe detail view
When a recipe has a `coverImage` URL, the detail view SHALL display the image prominently at the top of the screen. If the image URL is unavailable or loading, a placeholder SHALL be shown.

#### Scenario: Cover image shown in detail view
- **WHEN** a user opens a recipe that has a `coverImage` URL
- **THEN** the image SHALL be displayed at the top of the recipe detail view

#### Scenario: Placeholder shown when image is absent or unavailable
- **WHEN** a user opens a recipe with no `coverImage`, or the image fails to load
- **THEN** a placeholder (e.g., a generic food icon or empty space) SHALL be shown in place of the image

### Requirement: Cover image input in recipe creation and editing
The manual recipe entry and edit form SHALL include a text field for entering a cover image URL.

#### Scenario: User provides cover image URL during manual entry
- **WHEN** the user fills in the cover image URL field and saves the recipe
- **THEN** the URL SHALL be stored as the recipe's `coverImage`

#### Scenario: Cover image URL field is optional in the form
- **WHEN** the user leaves the cover image URL field empty and saves the recipe
- **THEN** the recipe SHALL be saved without a cover image and no validation error SHALL be shown
