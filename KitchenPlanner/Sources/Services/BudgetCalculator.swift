import Foundation

struct BudgetCalculator {
    static func totalCost(plan: WeekendPlan, headcount: Int) -> Double {
        plan.mealPlans.flatMap { $0.assignments }.reduce(0.0) { sum, a in
            sum + (a.recipe?.costPerServing ?? 0) * Double(headcount)
        }
    }

    static func utilization(plan: WeekendPlan, movement: MovementConfiguration) -> Double {
        guard movement.budget > 0 else { return 0 }
        let cost = totalCost(plan: plan, headcount: movement.headcount)
        return cost / movement.budget
    }
}
