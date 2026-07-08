## Context

`MealCardView` is defined in `PlanOverviewView.swift`. Currently it uses `.padding()` (16pt all sides), `.subheadline` for summary text clipped at 2 lines, and `.headline` for the theme title. The card has no fixed height — it sizes to content, which produces a compact card (~80pt tall) that feels sparse.

## Goals / Non-Goals

**Goals:**
- Increase card visual size to roughly 2× current height
- Make better use of the card surface area with larger text and more padding

**Non-Goals:**
- Changing card layout structure or adding new content
- Modifying the navigation behavior or card tap target

## Decisions

### Increase padding and text sizes

Bump horizontal and vertical padding to `20pt` horizontal / `20pt` vertical (from 16), set a `.minHeight` of `100pt` on the VStack so the card never collapses smaller, increase summary text from `.subheadline` to `.body`, and raise the line limit from `2` to `4`. This naturally grows the card to ~2× the current height without hard-coding a fixed height that would break on Dynamic Type.

**Alternative considered:** Set a fixed `.frame(height: 160)` — rejected because it clips text on larger Dynamic Type sizes and wastes space when the meal has no theme.
