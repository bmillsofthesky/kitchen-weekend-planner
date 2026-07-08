## Context

The app currently uses default SwiftUI `List` and `NavigationStack` styling with minimal visual customization. Cover images exist in the data model and are already rendered, but the overall layout lacks the warmth and polish of consumer recipe apps. The reference for the target aesthetic is the ReciMe app — card grids, large imagery, warm neutral backgrounds, bold typography, generous whitespace.

No model, service, or routing changes are needed. All changes are confined to `Views/`.

## Goals / Non-Goals

**Goals:**
- Replace recipe library `List` with a 2-column card grid with cover images
- Improve recipe detail hero image treatment (edge-to-edge, gradient overlay, title on image)
- Warm up the color palette (off-white card backgrounds, earthy orange accent)
- Tighten typography hierarchy across all views
- Polish meal slot cards in the planning view

**Non-Goals:**
- Animations or transitions
- Dark mode–specific tuning (rely on SwiftUI adaptive colors)
- New screens or navigation flows
- Any model, service, or persistence layer changes

## Decisions

### 1. Card grid in recipe library (LazyVGrid) instead of List

`LazyVGrid` with two flexible columns gives a Pinterest-style card layout. Each card shows the cover image (or placeholder), title, type badge, and cost label.

Considered keeping `List` with larger row cells — rejected because the visual density and imagery are central to the ReciMe feel, and a grid communicates "library" better than a list.

### 2. Warm neutral palette via SwiftUI semantic colors + custom accent

Use `Color(.systemBackground)` for card surfaces and introduce a warm beige canvas (`Color(red: 0.98, green: 0.96, blue: 0.93)`) as the list/grid background. Accent color: earthy orange (`Color(red: 0.85, green: 0.45, blue: 0.2)`), used on type badges and section headers.

Avoided custom asset catalog colors to keep the change scoped to Swift files only.

### 3. Hero image: full-bleed with gradient overlay and title on image

In `RecipeDetailView`, remove the fixed-height `AsyncImage` box and use a `ZStack` with a `LinearGradient` (clear → black.opacity(0.6)) overlaying the image. Recipe title and type badge render on top of the gradient. The image extends to the navigation bar edge using `.ignoresSafeArea(edges: .top)` on the scroll view's first item.

Considered: keeping the image as a fixed-height block above the content — simpler but doesn't achieve the immersive look.

### 4. Inline navigation bar title on detail view

With the title overlaid on the hero image, the large navigation title is redundant. Switch `RecipeDetailView` to `.navigationBarTitleDisplayMode(.inline)` with a blank or short title. The actual title lives in the hero gradient overlay.

### 5. Recipe card in meal slot view uses a compact horizontal card

In `RecipeSlotView`, replace bare text rows with a compact `HStack` card: small thumbnail (40×40, rounded), title, cost label. This brings visual consistency between the library and planning views without adding complexity.

## Risks / Trade-offs

- **Placeholder quality**: Recipes without cover images show a placeholder; the warm palette will make a plain gray box look jarring. Mitigation: use a subtle gradient placeholder with the fork.knife icon tinted in the accent color.
- **Grid card height variability**: Long recipe titles wrap and create uneven card heights in the grid. Mitigation: fix card image height (120pt) and cap title to 2 lines with `.lineLimit(2)`.
- **Performance**: `LazyVGrid` + `AsyncImage` per card. For large libraries this could be slow. Mitigation: `LazyVGrid` already defers rendering; no additional caching needed at this scale.
