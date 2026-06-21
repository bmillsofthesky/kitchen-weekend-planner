## Context

Recipe directions often embed explicit quantities in prose (e.g., "Combine 2 cups flour with 1 tsp salt"). After the serving-size scaling change, ingredient amounts displayed in `RecipeDetailView` are already scaled to headcount. However, direction text is rendered verbatim, leaving the quantities in it tied to the recipe's native `servingSize`. A recipe written for 8 with headcount of 16 will show doubled ingredient amounts but directions still saying "divide into 8 portions."

Directions are not included in the export JSON (plan-export spec: "Directions SHALL NOT be included in the export"), so the change is scoped entirely to `RecipeDetailView`.

Relevant file:
- `KitchenPlanner/Sources/Views/Recipes/RecipeDetailView.swift` — renders directions

## Goals / Non-Goals

**Goals:**
- Scale numeric quantities embedded in direction text by `headcount / servingSize` ratio at display time
- Avoid incorrectly scaling non-quantity numbers (temperatures, times, step numbers, ordinals)
- Keep implementation simple and contained to a single utility function

**Non-Goals:**
- Scaling direction text in the export (directions are excluded from the export schema)
- Parsing ingredient names from direction text (text is too free-form for reliable extraction)
- Converting units (e.g., "16 tbsp" → "1 cup") after scaling
- Handling fractions written as "1/2" or "½" — only decimal and integer literals

## Decisions

### Decision: Unit-aware scaling — only scale quantities followed by known cooking measurement words

Rather than scaling every numeric token in direction text, only scale numbers immediately followed (with optional whitespace) by a recognized cooking unit word. This prevents incorrectly scaling temperatures ("350°F"), oven times ("45 minutes"), step references ("Step 1"), ordinals ("1st layer"), or portion counts without a unit ("divide into 8 portions").

**Recognized units** (case-insensitive, singular and plural):
`cup`, `tablespoon`, `tbsp`, `teaspoon`, `tsp`, `ounce`, `oz`, `pound`, `lb`, `gram`, `g`, `kilogram`, `kg`, `milliliter`, `ml`, `stick`, `whole`, `clove`, `sprig`, `can`, `package`, `bunch`, `piece`, `pinch`, `dash`

**Alternative considered**: Scale all numeric tokens. Rejected — would incorrectly scale "Bake at 350°F for 45 minutes", producing nonsense like "Bake at 700°F for 90 minutes" when headcount is doubled.

**Alternative considered**: Scale only numbers that match a known ingredient name from the recipe. Rejected — too brittle; direction prose doesn't reliably name ingredients the same way the ingredient list does.

### Decision: Utility function as a free function in a new `DirectionScaler.swift`

A standalone function `scaleDirectionText(_ text: String, ratio: Double) -> String` keeps the logic testable and isolated from the view. It's a pure string transformation with no model dependencies.

**Alternative considered**: Method on `Direction` or `Recipe`. Rejected — the scaling ratio is derived from a runtime headcount, not stored on the model. A free function accepting text + ratio is cleaner.

### Decision: Format scaled numbers consistently with ingredient amount formatting

Scaled values that are whole numbers are formatted as integers; fractional values are formatted to two decimal places. Matches the existing `formatAmount` behavior in `RecipeDetailView`.

## Risks / Trade-offs

- **False negatives**: Unit words not in the recognized list won't trigger scaling. A direction saying "add 2 stalks of celery" won't be scaled since "stalks" isn't in the list. This is acceptable — missing a unit is safer than incorrectly scaling a non-quantity number. The list can be extended.
- **Ambiguous prose**: "divide the dough into 8 equal pieces" — "8" is not followed by a unit word here (it's followed by "equal"), so it won't be scaled. "8 pieces" would be scaled. Some cases will be missed; this is an acknowledged limitation.
- **Ratio = 1.0**: When headcount equals servingSize, the function returns text unchanged. No visual difference.
