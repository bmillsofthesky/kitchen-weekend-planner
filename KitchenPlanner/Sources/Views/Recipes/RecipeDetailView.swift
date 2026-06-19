import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    var headcount: Int

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
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(recipe.recipeType.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background(.blue.opacity(0.1))
                            .foregroundStyle(.blue)
                            .clipShape(Capsule())

                        Text(recipe.costLabel(headcount: headcount))
                            .font(.caption)
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background(.orange.opacity(0.1))
                            .foregroundStyle(.orange)
                            .clipShape(Capsule())

                        Spacer()
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
                }

                // Ingredients
                if !recipe.ingredients.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ingredients").font(.title3.bold())
                        ForEach(ingredientSections, id: \.self) { section in
                            VStack(alignment: .leading, spacing: 6) {
                                if !section.isEmpty {
                                    Text(section).font(.subheadline.bold()).foregroundStyle(.secondary)
                                }
                                ForEach(recipe.ingredients.filter { $0.section == section }) { ing in
                                    HStack {
                                        Text(formatAmount(ing.amount))
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
                        Text("Directions").font(.title3.bold())
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
                                        Text(dir.text)
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
                        Text("Notes").font(.title3.bold())
                        Text(recipe.notes).foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.large)
    }

    private func formatAmount(_ amount: Double) -> String {
        amount == amount.rounded() ? "\(Int(amount))" : String(format: "%.2f", amount)
    }
}
