import Foundation
import SwiftData

// MARK: - Embedded types (Codable for JSON seeding)

struct DayConfig: Codable, Hashable {
    var dayNumber: Int
    var meals: [MealConfig]
}

struct MealConfig: Hashable {
    var mealType: MealType
    var potluckEligible: Bool
    var potluckRequired: Bool = false
}

extension MealConfig: Codable {
    enum CodingKeys: String, CodingKey {
        case mealType, potluckEligible, potluckRequired
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        mealType = try c.decode(MealType.self, forKey: .mealType)
        potluckEligible = try c.decode(Bool.self, forKey: .potluckEligible)
        potluckRequired = (try? c.decode(Bool.self, forKey: .potluckRequired)) ?? false
    }
}

enum MealType: String, Codable, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
}

// MARK: - SwiftData Model

@Model
final class MovementConfiguration {
    @Attribute(.unique) var id: Int
    var name: String
    var abbr: String
    var headcount: Int
    var budget: Double
    var exportEmail: String
    var recipesUrl: String
    // Stored as JSON-encoded Data to avoid nested @Model complexity
    var daysData: Data

    var days: [DayConfig] {
        get { (try? JSONDecoder().decode([DayConfig].self, from: daysData)) ?? [] }
        set { daysData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }

    init(id: Int, name: String, abbr: String, headcount: Int, budget: Double,
         exportEmail: String, recipesUrl: String, days: [DayConfig]) {
        self.id = id
        self.name = name
        self.abbr = abbr
        self.headcount = headcount
        self.budget = budget
        self.exportEmail = exportEmail
        self.recipesUrl = recipesUrl
        self.daysData = (try? JSONEncoder().encode(days)) ?? Data()
    }

    func mealConfig(day: Int, mealType: MealType) -> MealConfig? {
        days.first { $0.dayNumber == day }?.meals.first { $0.mealType == mealType }
    }

    var allMealSlots: [(day: Int, meal: MealConfig)] {
        days.sorted { $0.dayNumber < $1.dayNumber }.flatMap { day in
            day.meals.map { (day: day.dayNumber, meal: $0) }
        }
    }
}

// MARK: - Codable DTO for JSON seeding

struct MovementConfigurationDTO: Codable {
    var id: Int
    var name: String
    var abbr: String
    var headcount: Int
    var budget: Double
    var exportEmail: String
    var recipesUrl: String
    var days: [DayConfig]
}
