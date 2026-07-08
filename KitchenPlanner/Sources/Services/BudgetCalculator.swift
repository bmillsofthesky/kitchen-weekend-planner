import Foundation
import SwiftUI

struct BudgetCalculator {
    static func totalCost(plan: WeekendPlan, headcount: Int) -> Double {
        plan.mealPlans.flatMap { $0.assignments }.reduce(0.0) { sum, a in
            guard let recipe = a.recipe else { return sum }
            return sum + (Double(headcount) / Double(recipe.servingSize)) * (recipe.costForRecipe ?? 0)
        }
    }

    static func utilization(plan: WeekendPlan, movement: MovementConfiguration) -> Double {
        guard movement.budget > 0 else { return 0 }
        let cost = totalCost(plan: plan, headcount: movement.headcount)
        return cost / movement.budget
    }

    static func statusLabel(_ utilization: Double) -> String {
        switch utilization {
        case ..<0.7: return "On track"
        case 0.7..<1.0: return "Approaching limit"
        default: return "Over budget"
        }
    }

    static func statusColor(_ utilization: Double) -> Color {
        switch utilization {
        case ..<0.7: return .green
        case 0.7..<1.0: return .yellow
        default: return .red
        }
    }
}
