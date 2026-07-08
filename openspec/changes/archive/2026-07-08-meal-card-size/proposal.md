## Why

The meal cards in PlanOverviewView are too compact — the summary text is cramped and the card doesn't give enough visual weight to each meal. Making them larger improves scannability and makes the plan feel more intentional.

## What Changes

- Increase `MealCardView` height by approximately 2× via increased internal padding, larger fonts, and a fixed minimum height
- Allow summary text to wrap to more lines instead of being clipped at 2

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- `ui-visual-design`: MealCardView size and content density requirements are changing

## Impact

- `PlanOverviewView.swift` only — `MealCardView` struct within that file
