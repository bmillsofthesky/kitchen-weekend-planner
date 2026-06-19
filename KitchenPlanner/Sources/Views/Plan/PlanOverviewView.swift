import SwiftUI

struct PlanOverviewView: View {
    var plan: WeekendPlan
    var movement: MovementConfiguration

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(plan.sortedMealPlans) { mealPlan in
                    NavigationLink {
                        MealView(mealPlan: mealPlan, movement: movement)
                    } label: {
                        MealCardView(mealPlan: mealPlan, movement: movement)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle(plan.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct MealCardView: View {
    var mealPlan: MealPlan
    var movement: MovementConfiguration

    var summaryText: String {
        let mains = mealPlan.assignmentsForSlot(.main).compactMap { $0.recipe?.title }
        let sides = mealPlan.assignmentsForSlot(.side).compactMap { $0.recipe?.title }
        let desserts = mealPlan.assignmentsForSlot(.dessert).compactMap { $0.recipe?.title }

        if mains.isEmpty && sides.isEmpty && desserts.isEmpty {
            return mealPlan.isPotluck ? "Potluck" : "No recipes assigned yet"
        }
        var parts: [String] = []
        if !mains.isEmpty { parts.append(mains.joined(separator: ", ")) }
        if !sides.isEmpty { parts.append("w/ \(sides.joined(separator: ", "))") }
        if !desserts.isEmpty { parts.append("and \(desserts.joined(separator: ", ")) for dessert") }
        return parts.joined(separator: " ")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Day \(mealPlan.dayNumber) · \(mealPlan.mealType)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    if let theme = mealPlan.theme, !theme.title.isEmpty {
                        Text(theme.title)
                            .font(.headline)
                    }
                }
                Spacer()
                if mealPlan.isPotluck {
                    Label("Potluck", systemImage: "person.3.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
                    .font(.caption)
            }

            Text(summaryText)
                .font(.subheadline)
                .foregroundStyle(mealPlan.assignments.isEmpty && !mealPlan.isPotluck ? .tertiary : .primary)
                .lineLimit(2)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
    }
}
