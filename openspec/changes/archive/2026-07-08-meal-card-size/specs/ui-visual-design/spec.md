## MODIFIED Requirements

### Requirement: Meal cards have generous sizing and readable content
Each meal card in the Plan overview SHALL use increased padding and font sizes to produce a card that is approximately twice the height of a default compact card. Summary text SHALL wrap to up to 4 lines rather than being clipped at 2.

#### Scenario: Card occupies meaningful vertical space
- **WHEN** a meal card is displayed in the Plan overview
- **THEN** the card SHALL have a minimum height of approximately 100pt and use at least 20pt of vertical padding on each side

#### Scenario: Summary text is readable at body size
- **WHEN** a meal card displays a recipe summary
- **THEN** the summary text SHALL use `.body` font size and allow up to 4 lines before truncating
