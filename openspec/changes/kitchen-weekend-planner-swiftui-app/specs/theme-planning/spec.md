## ADDED Requirements

### Requirement: Theme data model per meal
Each meal SHALL support one theme containing: title, optional cover image, description (rich text), design details (text and a list of needed items), and optional skits.

#### Scenario: Theme fields displayed
- **WHEN** a user views the Theme tab of a meal
- **THEN** all populated theme fields SHALL be displayed: title, cover image (if set), description, design details, needed items, and skits

### Requirement: Theme description and cover image
The user SHALL be able to enter a rich-text description for the theme and optionally attach a cover image from the device photo library.

#### Scenario: Cover image attached
- **WHEN** the user selects a photo from the device library
- **THEN** the image SHALL be stored locally and displayed as the theme cover image

#### Scenario: Description supports formatted text
- **WHEN** the user enters a theme description
- **THEN** the field SHALL support basic rich text formatting (bold, italic, lists)

### Requirement: Design details with needed items and purchase links
The theme SHALL include a design details section with a free-text area and a list of needed items. Each item SHALL have a name, quantity, and optional URL link (e.g., Amazon).

#### Scenario: Add needed item with link
- **WHEN** the user adds a needed item and provides a URL
- **THEN** the item SHALL be saved with the name, quantity, and link and displayed in the design details list

#### Scenario: Open item link
- **WHEN** the user taps a needed item's link
- **THEN** the URL SHALL open in Safari or an in-app browser

#### Scenario: Needed item without link
- **WHEN** the user adds a needed item without a URL
- **THEN** the item SHALL be saved and displayed with name and quantity only

### Requirement: Skit entries per theme
The user SHALL be able to add zero or more skits to a theme. Each skit SHALL have a name and a details/script text field.

#### Scenario: Multiple skits added
- **WHEN** the user adds more than one skit
- **THEN** all skits SHALL be listed and individually accessible

#### Scenario: Skit detail view
- **WHEN** the user taps a skit
- **THEN** the full skit name and details/script SHALL be displayed in a detail view

### Requirement: Example images in theme
The user SHALL be able to attach multiple reference images to the design details section to visually illustrate the theme.

#### Scenario: Multiple images attached
- **WHEN** the user adds reference images
- **THEN** all images SHALL be displayed in a scrollable gallery within the design details section
