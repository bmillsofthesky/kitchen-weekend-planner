## 1. Direction Scaler Utility

- [x] 1.1 Create `DirectionScaler.swift` with a `scaleDirectionText(_ text: String, ratio: Double) -> String` free function that uses a regex to find `<number> <unit>` patterns (case-insensitive, singular/plural) and replaces the number with `number * ratio`, formatted as an integer if whole or to two decimal places if fractional
- [x] 1.2 Define the recognized cooking unit list: cup(s), tablespoon(s), tbsp, teaspoon(s), tsp, ounce(s), oz, pound(s), lb(s), gram(s), g, kilogram(s), kg, milliliter(s), ml, stick(s), whole, clove(s), sprig(s), can(s), package(s), bunch(es), piece(s), pinch(es), dash(es)

## 2. RecipeDetailView Integration

- [x] 2.1 In `RecipeDetailView`, apply `scaleDirectionText` to each direction's `text` when rendering, passing the same `headcount / servingSize` ratio used for ingredient scaling
- [x] 2.2 Verify that ratio = 1.0 (headcount == servingSize) produces no visible change to direction text

## 3. Verification

- [x] 3.1 View a recipe with `servingSize > 1` in the detail view and confirm direction quantities with recognized units are scaled while temperatures and times are not
- [x] 3.2 View a recipe with `servingSize = 1` at any headcount and confirm directions are scaled correctly (ratio = headcount)
