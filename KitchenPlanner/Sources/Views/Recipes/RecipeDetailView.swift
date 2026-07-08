import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    var headcount: Int

    var hasCoverImage: Bool {
        guard let s = recipe.coverImage else { return false }
        return !s.isEmpty
    }

    var ingredientSections: [String] {
        var seen = Set<String>()
        return recipe.ingredients.compactMap { i -> String? in
            if seen.contains(i.section) { return nil }
            seen.insert(i.section)
            return i.section
        }
    }

    var directionSections: [String] {
        var seen = Set<String>()
        return recipe.directions.compactMap { d -> String? in
            if seen.contains(d.section) { return nil }
            seen.insert(d.section)
            return d.section
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero image (full-bleed, extends behind nav bar)
                if let urlString = recipe.coverImage, !urlString.isEmpty, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)
                                .clipped()
                                .overlay(heroOverlay)
                        default:
                            heroCoverPlaceholder
                        }
                    }
                    .ignoresSafeArea(edges: .top)
                } else {
                    heroCoverPlaceholder
                        .ignoresSafeArea(edges: .top)
                }

                // Body content
                VStack(alignment: .leading, spacing: 20) {
                    // Show title + badges below hero only when there is no cover image
                    if !hasCoverImage {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(recipe.title)
                                .font(.title2.bold())
                            badgesRow
                        }
                    } else {
                        badgesRow
                    }

                    if !recipe.recipeDescription.isEmpty {
                        Text(recipe.recipeDescription)
                            .foregroundStyle(.secondary)
                    }

                    if !recipe.labels.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(recipe.labels, id: \.self) { label in
                                    Text(label)
                                        .font(.caption2)
                                        .padding(.horizontal, 6).padding(.vertical, 2)
                                        .background(.secondary.opacity(0.15))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }

                    // Ingredients
                    if !recipe.ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ingredients")
                                .font(.title3.bold())
                                .foregroundStyle(Color.earthyOrange)
                            ForEach(ingredientSections, id: \.self) { section in
                                VStack(alignment: .leading, spacing: 6) {
                                    if !section.isEmpty {
                                        Text(section).font(.subheadline.bold()).foregroundStyle(.secondary)
                                    }
                                    ForEach(recipe.ingredients.filter { $0.section == section }) { ing in
                                        HStack {
                                            Text(formatAmount(ing.amount * Double(headcount) / Double(recipe.servingSize)))
                                                .font(.body.monospacedDigit())
                                                .foregroundStyle(.secondary)
                                                .frame(width: 60, alignment: .trailing)
                                            Text(ing.measurement).foregroundStyle(.secondary).frame(width: 50, alignment: .leading)
                                            Text(ing.name)
                                        }
                                        .font(.subheadline)
                                    }
                                }
                            }
                        }
                    }

                    // Directions
                    if !recipe.directions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Directions")
                                .font(.title3.bold())
                                .foregroundStyle(Color.earthyOrange)
                            ForEach(directionSections, id: \.self) { section in
                                VStack(alignment: .leading, spacing: 8) {
                                    if !section.isEmpty {
                                        Text(section).font(.subheadline.bold()).foregroundStyle(.secondary)
                                    }
                                    ForEach(recipe.directions.filter { $0.section == section }.sorted { $0.order < $1.order }) { dir in
                                        HStack(alignment: .top, spacing: 10) {
                                            Text("\(dir.order).")
                                                .foregroundStyle(.secondary)
                                                .frame(width: 24, alignment: .trailing)
                                            Text(scaleDirectionText(dir.text, ratio: Double(headcount) / Double(recipe.servingSize)))
                                        }
                                        .font(.subheadline)
                                    }
                                }
                            }
                        }
                    }

                    // Notes
                    if !recipe.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Notes")
                                .font(.title3.bold())
                                .foregroundStyle(Color.earthyOrange)
                            Text(recipe.notes).foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(hasCoverImage ? "" : recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Hero overlay: gradient + title + badge

    private var heroOverlay: some View {
        VStack {
            Spacer()
            LinearGradient(
                colors: [.clear, Color.black.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 120)
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(recipe.title)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .shadow(radius: 2)
                    typeBadge(dark: true)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }

    private var heroCoverPlaceholder: some View {
        ZStack {
            LinearGradient(
                colors: [Color.warmCanvas, Color(red: 0.92, green: 0.88, blue: 0.82)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: "fork.knife")
                .font(.system(size: 48))
                .foregroundStyle(Color.earthyOrange.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
    }

    private var badgesRow: some View {
        HStack(spacing: 6) {
            typeBadge(dark: false)
            Text(recipe.costLabel(headcount: headcount))
                .font(.caption)
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(Color.earthyOrange.opacity(0.08))
                .foregroundStyle(Color.earthyOrange.opacity(0.8))
                .clipShape(Capsule())
            Spacer()
        }
    }

    private func typeBadge(dark: Bool) -> some View {
        Text(recipe.recipeType.rawValue)
            .font(.caption)
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(dark ? Color.white.opacity(0.2) : Color.earthyOrange.opacity(0.12))
            .foregroundStyle(dark ? Color.white : Color.earthyOrange)
            .clipShape(Capsule())
    }

    private func formatAmount(_ amount: Double) -> String {
        amount == amount.rounded() ? "\(Int(amount))" : String(format: "%.2f", amount)
    }
}
