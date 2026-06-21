import Foundation
import SwiftData

@MainActor
final class RecipeSyncService {
    static func sync(movement: MovementConfiguration, context: ModelContext) async throws {
        let urlString = movement.recipesUrl
        guard !urlString.isEmpty, let url = URL(string: urlString) else { return }

        let (data, _) = try await URLSession.shared.data(from: url)
        let dtos = try JSONDecoder().decode([RecipeDTO].self, from: data)
        upsert(dtos: dtos, context: context)
    }

    static func importFromData(_ data: Data, context: ModelContext) throws {
        let dtos = try JSONDecoder().decode([RecipeDTO].self, from: data)
        let recipes = dtos.map { makeRecipe(from: $0, isCustom: true) }
        recipes.forEach { context.insert($0) }
        try context.save()
    }

    private static func upsert(dtos: [RecipeDTO], context: ModelContext) {
        let existing = (try? context.fetch(FetchDescriptor<Recipe>())) ?? []
        let existingById = Dictionary(uniqueKeysWithValues: existing.map { ($0.id, $0) })

        for dto in dtos {
            if let existing = existingById[dto.id] {
                guard !existing.isCustom else { continue }
                apply(dto: dto, to: existing)
            } else {
                context.insert(makeRecipe(from: dto, isCustom: false))
            }
        }
        try? context.save()
    }

    private static func makeRecipe(from dto: RecipeDTO, isCustom: Bool) -> Recipe {
        let ingredients = (dto.ingredients ?? []).map { ing in
            Ingredient(name: ing.name, measurement: ing.measurement ?? "",
                       amount: ing.amount ?? 0, section: ing.section ?? "")
        }
        let directions = (dto.directions ?? []).enumerated().map { i, dir in
            Direction(order: dir.order ?? i, text: dir.text, section: dir.section ?? "")
        }
        return Recipe(
            id: dto.id,
            title: dto.title,
            description: dto.description ?? "",
            costForRecipe: dto.costForRecipe,
            servingSize: dto.servingSize ?? 1,
            type: RecipeType(rawValue: dto.type ?? "") ?? .other,
            labels: dto.labels ?? [],
            ingredients: ingredients,
            directions: directions,
            notes: dto.notes ?? "",
            isCustom: isCustom,
            sourceURL: dto.sourceURL
        )
    }

    private static func apply(dto: RecipeDTO, to recipe: Recipe) {
        recipe.title = dto.title
        recipe.recipeDescription = dto.description ?? recipe.recipeDescription
        recipe.costForRecipe = dto.costForRecipe ?? recipe.costForRecipe
        recipe.servingSize = dto.servingSize ?? recipe.servingSize
        recipe.type = dto.type ?? recipe.type
        recipe.labels = dto.labels ?? recipe.labels
        recipe.notes = dto.notes ?? recipe.notes
        if let ings = dto.ingredients {
            recipe.ingredients = ings.map { ing in
                Ingredient(name: ing.name, measurement: ing.measurement ?? "",
                           amount: ing.amount ?? 0, section: ing.section ?? "")
            }
        }
        if let dirs = dto.directions {
            recipe.directions = dirs.enumerated().map { i, dir in
                Direction(order: dir.order ?? i, text: dir.text, section: dir.section ?? "")
            }
        }
    }
}
