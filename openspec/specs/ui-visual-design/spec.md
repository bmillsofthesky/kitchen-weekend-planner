## Purpose

Defines the visual design language for the app: layout patterns, color palette, image treatment, and component styling across all views.

## Requirements

### Requirement: Recipe library displays as card grid
The recipe library SHALL display recipes in a 2-column card grid. Each card SHALL show the cover image (or a warm placeholder), the recipe title (max 2 lines), the type badge, and the cost label.

#### Scenario: Grid renders with cover images
- **WHEN** a user opens the recipe library and recipes have cover images
- **THEN** each recipe SHALL be displayed as a card with the image filling the top portion of the card

#### Scenario: Placeholder shown for recipes without cover image
- **WHEN** a recipe has no cover image
- **THEN** a styled placeholder (warm gradient with a food icon) SHALL occupy the image area of the card

### Requirement: Recipe detail view has full-bleed hero image
When a recipe has a cover image, the detail view SHALL display the image edge-to-edge at the top, extending behind the navigation bar. The recipe title SHALL be overlaid on a gradient at the bottom of the image.

#### Scenario: Hero image with title overlay
- **WHEN** a user opens a recipe with a cover image
- **THEN** the image SHALL fill the full width, and the recipe title SHALL appear in white text over a dark gradient at the image bottom

#### Scenario: Detail view without cover image
- **WHEN** a user opens a recipe with no cover image
- **THEN** the view SHALL render without a hero image block, with the title shown normally in the navigation bar

### Requirement: Warm neutral color palette applied consistently
The app SHALL use a warm off-white canvas color for list/grid backgrounds and card surfaces. The accent color for type badges and section headers SHALL be an earthy orange tone.

#### Scenario: Card backgrounds are warm white
- **WHEN** any recipe card or content card is displayed
- **THEN** the card background SHALL use the warm neutral surface color, not the system default gray

#### Scenario: Type badges use earthy orange accent
- **WHEN** a recipe type badge is displayed
- **THEN** it SHALL use the earthy orange accent color for its text and tinted background

### Requirement: Meal cards have generous sizing and readable content
Each meal card in the Plan overview SHALL use increased padding and font sizes to produce a card that is approximately twice the height of a default compact card. Summary text SHALL wrap to up to 4 lines rather than being clipped at 2.

#### Scenario: Card occupies meaningful vertical space
- **WHEN** a meal card is displayed in the Plan overview
- **THEN** the card SHALL have a minimum height of approximately 100pt and use at least 20pt of vertical padding on each side

#### Scenario: Summary text is readable at body size
- **WHEN** a meal card displays a recipe summary
- **THEN** the summary text SHALL use `.body` font size and allow up to 4 lines before truncating
