import Foundation
import SwiftData

enum RecipeSlot: String, Codable, CaseIterable {
    case main = "Main"
    case side = "Side"
    case dessert = "Dessert"
}

@Model
final class RecipeAssignment {
    var slot: String           // RecipeSlot.rawValue
    var order: Int
    var recipe: Recipe?
    var mealPlan: MealPlan?

    var recipeSlot: RecipeSlot { RecipeSlot(rawValue: slot) ?? .main }

    init(recipe: Recipe, slot: RecipeSlot, order: Int) {
        self.recipe = recipe
        self.slot = slot.rawValue
        self.order = order
    }
}

@Model
final class MealPlan {
    var dayNumber: Int
    var mealType: String       // MealType.rawValue
    var isPotluck: Bool
    @Relationship(deleteRule: .cascade) var assignments: [RecipeAssignment]
    @Relationship(deleteRule: .cascade) var theme: Theme?
    var weekendPlan: WeekendPlan?

    var mealTypeEnum: MealType { MealType(rawValue: mealType) ?? .lunch }

    var assignmentsForSlot: (RecipeSlot) -> [RecipeAssignment] {
        { [self] slot in
            assignments
                .filter { $0.slot == slot.rawValue }
                .sorted { $0.order < $1.order }
        }
    }

    init(dayNumber: Int, mealType: MealType, weekendPlan: WeekendPlan? = nil) {
        self.dayNumber = dayNumber
        self.mealType = mealType.rawValue
        self.isPotluck = false
        self.assignments = []
        self.weekendPlan = weekendPlan
    }
}

@Model
final class WeekendPlan {
    @Attribute(.unique) var name: String
    var movementId: Int
    var createdAt: Date
    var isActive: Bool
    @Relationship(deleteRule: .cascade) var mealPlans: [MealPlan]

    init(name: String, movementId: Int) {
        self.name = name
        self.movementId = movementId
        self.createdAt = Date()
        self.isActive = false
        self.mealPlans = []
    }

    func mealPlan(day: Int, mealType: MealType) -> MealPlan? {
        mealPlans.first { $0.dayNumber == day && $0.mealType == mealType.rawValue }
    }

    var sortedMealPlans: [MealPlan] {
        mealPlans.sorted {
            if $0.dayNumber != $1.dayNumber { return $0.dayNumber < $1.dayNumber }
            let order: [MealType] = [.breakfast, .lunch, .dinner]
            let a = order.firstIndex(of: $0.mealTypeEnum) ?? 0
            let b = order.firstIndex(of: $1.mealTypeEnum) ?? 0
            return a < b
        }
    }
}
