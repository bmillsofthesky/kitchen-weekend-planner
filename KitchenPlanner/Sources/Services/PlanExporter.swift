import Foundation
import MessageUI

struct ExportPlan: Encodable {
    struct PlanInfo: Encodable {
        var name: String
        var movement: MovementInfo
        var exportedAt: String
    }
    struct MovementInfo: Encodable {
        var name: String
        var abbr: String
        var headcount: Int
        var budget: Double
    }
    struct ExportMeal: Encodable {
        var day: Int
        var mealType: String
        var isPotluck: Bool
        var theme: ExportTheme
        var recipes: [ExportRecipe]
    }
    struct ExportTheme: Encodable {
        var title: String
        var neededItems: [ExportNeededItem]
    }
    struct ExportNeededItem: Encodable {
        var name: String
        var amount: String
        var link: String
    }
    struct ExportRecipe: Encodable {
        var title: String
        var slot: String
        var costForRecipe: Double
        var totalCost: Double
        var ingredients: [ExportIngredient]
    }
    struct ExportIngredient: Encodable {
        var name: String
        var section: String
        var measurement: String
        var scaledAmount: String
    }

    var plan: PlanInfo
    var meals: [ExportMeal]
}

final class PlanExporter {
    static func generateJSON(plan: WeekendPlan, movement: MovementConfiguration) throws -> Data {
        let formatter = ISO8601DateFormatter()
        let meals = plan.sortedMealPlans.map { mp -> ExportPlan.ExportMeal in
            let theme = mp.theme
            let neededItems = (theme?.neededItems ?? []).map {
                ExportPlan.ExportNeededItem(name: $0.name, amount: $0.quantity, link: $0.link ?? "")
            }
            let recipes = mp.assignments.sorted { $0.order < $1.order }.compactMap { a -> ExportPlan.ExportRecipe? in
                guard let r = a.recipe else { return nil }
                let cost = r.costForRecipe ?? 0
                let ratio = Double(movement.headcount) / Double(r.servingSize)
                let ings = r.ingredients.map { ing -> ExportPlan.ExportIngredient in
                    let scaled = ing.amount * ratio
                    return ExportPlan.ExportIngredient(
                        name: ing.name,
                        section: ing.section,
                        measurement: ing.measurement,
                        scaledAmount: formatAmount(scaled, measurement: ing.measurement)
                    )
                }
                return ExportPlan.ExportRecipe(
                    title: r.title,
                    slot: a.slot,
                    costForRecipe: cost,
                    totalCost: ratio * cost,
                    ingredients: ings
                )
            }
            return ExportPlan.ExportMeal(
                day: mp.dayNumber,
                mealType: mp.mealType,
                isPotluck: mp.isPotluck,
                theme: ExportPlan.ExportTheme(title: theme?.title ?? "", neededItems: neededItems),
                recipes: recipes
            )
        }

        let export = ExportPlan(
            plan: ExportPlan.PlanInfo(
                name: plan.name,
                movement: ExportPlan.MovementInfo(
                    name: movement.name, abbr: movement.abbr,
                    headcount: movement.headcount, budget: movement.budget
                ),
                exportedAt: formatter.string(from: Date())
            ),
            meals: meals
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(export)
    }

    private static func formatAmount(_ amount: Double, measurement: String) -> String {
        if amount == amount.rounded() {
            return "\(Int(amount)) \(measurement)".trimmingCharacters(in: .whitespaces)
        }
        return String(format: "%.2f \(measurement)", amount).trimmingCharacters(in: .whitespaces)
    }

    static func canSendMail() -> Bool {
        MFMailComposeViewController.canSendMail()
    }
}
