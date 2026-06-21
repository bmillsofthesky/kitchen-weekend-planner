## Why

Recipe directions often contain explicit quantity references (e.g., "add 2 cups of flour", "divide into 8 portions"). Now that ingredient amounts are stored at native serving size and scaled to headcount at display/export time, directions with embedded quantities are inconsistent — they still reflect the recipe's native serving size regardless of how many people are being fed. This change extends the headcount scaling already applied to ingredient lists to any quantity mentions within direction text.

## What Changes

- Direction text shown in `RecipeDetailView` will have numeric quantity references scaled by the same `headcount / servingSize` ratio used for ingredient amounts
- Exported directions in `PlanExporter` will apply the same scaling to direction text
- A utility function will parse numeric tokens (integers and decimals) from direction text and replace them with scaled equivalents, preserving surrounding text

## Capabilities

### New Capabilities
- `direction-scaling`: Parsing and scaling of numeric quantity references embedded in recipe direction text, applied at display and export time using the headcount/servingSize ratio

### Modified Capabilities
- `recipe-serving-size`: Display and export of direction text now includes scaled quantities, consistent with ingredient amount scaling
- `plan-export`: Exported direction text reflects headcount-scaled quantities

## Impact

- `RecipeDetailView.swift` — scale direction text when rendering
- `PlanExporter.swift` — scale direction text in export JSON (if directions are exported)
- New utility function (likely in `Recipe.swift` or a new `DirectionScaler.swift`) to scale numeric tokens in a string
