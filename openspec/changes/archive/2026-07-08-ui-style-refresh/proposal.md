## Why

The app is functional but visually plain — default SwiftUI lists and minimal styling make it feel like a prototype rather than a polished product. Elevating the visual design to match the warmth and polish of apps like ReciMe will make the app more enjoyable to use day-to-day.

## What Changes

- **Recipe library**: Replace the flat `List` with a card grid (2-column) using large cover images, warmer background, and refined type hierarchy
- **Recipe detail view**: Improve the hero image treatment with a full-bleed edge-to-edge image, gradient overlay, and title overlaid on the image; tighten section spacing and ingredient row design
- **Meal planning**: Style the slot cards with warmer backgrounds, better recipe row design showing thumbnails; improve the editing panel
- **Color & typography system**: Introduce a warm neutral palette (warm off-white backgrounds, earthy accent), consistent corner radii (16pt for cards), and refined font weight usage across all views
- **Tab bar & navigation**: Clean up navigation title styles; use inline mode where the hero image provides context

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- none

## Impact

- Only `Views/` files are changed — no model, service, or data layer changes
- All existing behavior is preserved; this is purely visual
- Affected files: `RecipeLibraryView.swift`, `RecipeDetailView.swift`, `MealView.swift`, `MainTabView.swift`, and shared component files
