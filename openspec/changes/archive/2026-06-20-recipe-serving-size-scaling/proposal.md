## Why

Recipes are currently stored as if they always serve 1 person, requiring ingredient amounts to be normalized on import — but this loses the original recipe fidelity and forces awkward math. Storing recipes with their native serving size and scaling at display/export time gives users accurate data and correct budget calculations for any headcount.

## What Changes

- **BREAKING**: Recipe data model replaces `cost_per_serving` with `cost_for_recipe` (the total cost for the recipe's native `serving_size`)
- **BREAKING**: Stored ingredient amounts are no longer normalized to 1 serving; they reflect the recipe's native `serving_size`
- Recipe display and export scale ingredient amounts from `serving_size` to the weekend headcount
- Budget calculation changes: total cost = sum of `(headcount / serving_size) × cost_for_recipe` for each assigned recipe
- Cost labels in the UI remain unchanged in appearance but are now derived from the new cost model

## Capabilities

### New Capabilities
- `recipe-serving-size`: Introduces `serving_size` and `cost_for_recipe` fields on the recipe model; defines scaling logic from native serving size to headcount

### Modified Capabilities
- `recipe-library`: Recipe data model changes (new fields, removed `cost_per_serving`, import normalization removed); cost label derivation updated
- `budget-tracker`: Budget calculation formula updated to use `cost_for_recipe` and `serving_size`
- `plan-export`: Exported recipe data must scale ingredient amounts to headcount before export

## Impact

- Recipe data model (Swift struct / JSON schema)
- Remote JSON sync source — existing recipes have `cost_per_serving`; migration or mapping needed
- Recipe import (URL scrape, file import) — no longer normalizes to 1 serving
- Budget progress bar calculation
- Recipe cost label logic
- Plan export output
- Any UI view that displays ingredient amounts (detail view, meal view)
