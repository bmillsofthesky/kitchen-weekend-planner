import Foundation
import SwiftData

enum RecipeType: String, Codable, CaseIterable {
    case entree = "Entree"
    case side = "Side"
    case dessert = "Dessert"
    case other = "Other"
}

enum RecipeLabel: String, Codable, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case soup = "Soup"
    case salad = "Salad"
    case sauce = "Sauce"
}

struct Ingredient: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var measurement: String  // e.g. "cups", "tbsp"
    var amount: Double       // at native serving size
    var section: String      // e.g. "Sauce", "Dough", "" for main
}

struct Direction: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var order: Int
    var text: String
    var section: String
}

@Model
final class Recipe {
    @Attribute(.unique) var id: String
    var title: String
    var recipeDescription: String
    @Attribute(originalName: "costPerServing") var costForRecipe: Double?
    var servingSize: Int = 1
    var type: String              // RecipeType.rawValue
    var labelsData: Data          // JSON-encoded [String]
    var ingredientsData: Data     // JSON-encoded [Ingredient]
    var directionsData: Data      // JSON-encoded [Direction]
    var notes: String
    var isCustom: Bool
    var sourceURL: String?

    var labels: [String] {
        get { (try? JSONDecoder().decode([String].self, from: labelsData)) ?? [] }
        set { labelsData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }

    var ingredients: [Ingredient] {
        get { (try? JSONDecoder().decode([Ingredient].self, from: ingredientsData)) ?? [] }
        set { ingredientsData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }

    var directions: [Direction] {
        get { (try? JSONDecoder().decode([Direction].self, from: directionsData)) ?? [] }
        set { directionsData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }

    var recipeType: RecipeType {
        RecipeType(rawValue: type) ?? .other
    }

    init(id: String = UUID().uuidString, title: String, description: String = "",
         costForRecipe: Double? = nil, servingSize: Int = 1, type: RecipeType = .other,
         labels: [String] = [], ingredients: [Ingredient] = [], directions: [Direction] = [],
         notes: String = "", isCustom: Bool = true, sourceURL: String? = nil) {
        self.id = id
        self.title = title
        self.recipeDescription = description
        self.costForRecipe = costForRecipe
        self.servingSize = servingSize
        self.type = type.rawValue
        self.labelsData = (try? JSONEncoder().encode(labels)) ?? Data()
        self.ingredientsData = (try? JSONEncoder().encode(ingredients)) ?? Data()
        self.directionsData = (try? JSONEncoder().encode(directions)) ?? Data()
        self.notes = notes
        self.isCustom = isCustom
        self.sourceURL = sourceURL
    }

    func costLabel(headcount: Int) -> String {
        guard let cost = costForRecipe else { return "Unknown" }
        let total = (Double(headcount) / Double(servingSize)) * cost
        switch total {
        case ..<50: return "$"
        case 50..<150: return "$$"
        case 150..<300: return "$$$"
        default: return "$$$$"
        }
    }
}

// MARK: - Codable DTO for JSON sync / file import

struct RecipeDTO: Codable {
    var id: String
    var title: String
    var description: String?
    var costForRecipe: Double?
    var servingSize: Int?
    var type: String?
    var labels: [String]?
    var ingredients: [IngredientDTO]?
    var directions: [DirectionDTO]?
    var notes: String?
    var sourceURL: String?
}

struct IngredientDTO: Codable {
    var id: String?
    var name: String
    var measurement: String?
    var amount: Double?
    var section: String?
}

struct DirectionDTO: Codable {
    var id: String?
    var order: Int?
    var text: String
    var section: String?
}
