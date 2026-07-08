## 1. Color & Style Tokens

- [x] 1.1 Define warm canvas color (`Color(red: 0.98, green: 0.96, blue: 0.93)`) and earthy orange accent (`Color(red: 0.85, green: 0.45, blue: 0.2)`) as static extensions on `Color` in a new `AppColors.swift` file
- [x] 1.2 Replace hard-coded `.blue` accent on type badges in `RecipeRowView` and `RecipeDetailView` with the earthy orange accent color

## 2. Recipe Library — Card Grid

- [x] 2.1 Replace the `List` in `RecipeLibraryView` with a `LazyVGrid` using two flexible columns and a warm canvas background
- [x] 2.2 Create a `RecipeCardView` (replaces `RecipeRowView`) with: fixed-height (120pt) cover image or warm placeholder, title (`.lineLimit(2)`), type badge, and cost label
- [x] 2.3 Update the warm placeholder in `RecipeCardView` to use a gradient from the warm canvas to a slightly deeper tone, with the `fork.knife` icon tinted in the earthy orange accent
- [x] 2.4 Update `RecipeLibraryView` `NavigationLink` to wrap `RecipeCardView` instead of `RecipeRowView`

## 3. Recipe Detail — Hero Image

- [x] 3.1 Restructure `RecipeDetailView` scroll content so the cover image (when present) is the first element, using `.ignoresSafeArea(edges: .top)` to extend behind the nav bar
- [x] 3.2 Overlay a `LinearGradient` (`.clear` → `Color.black.opacity(0.6)`) on the bottom 40% of the hero image
- [x] 3.3 Place the recipe title in white `.title2.bold()` text and the type badge in the gradient overlay area
- [x] 3.4 Switch `RecipeDetailView` to `.navigationBarTitleDisplayMode(.inline)` and set a blank navigation title when a cover image is present (title lives on the hero)
- [x] 3.5 Update the `coverImagePlaceholder` to use the warm gradient style matching the library card placeholder

## 4. Meal Planning — Slot Cards

- [x] 4.1 In `RecipeSlotView` (non-editing state), replace plain text `NavigationLink` rows with a compact `HStack` card: 40×40 thumbnail (cover image or placeholder), title, cost label
- [x] 4.2 Update the slot card background from `.background` to the warm canvas color and use a slightly larger corner radius (16pt)
- [x] 4.3 Style section headers (Mains, Sides, Desserts) with the earthy orange accent color and `.subheadline.bold()`
