import SwiftUI

struct BudgetSheetView: View {
    var plan: WeekendPlan
    var movement: MovementConfiguration

    var utilization: Double {
        BudgetCalculator.utilization(plan: plan, movement: movement)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Budget")
                .font(.title3.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 8) {
                BudgetProgressBar(plan: plan, movement: movement)
                    .frame(height: 8)
                    .clipShape(Capsule())

                HStack {
                    Text(BudgetCalculator.statusLabel(utilization))
                        .font(.subheadline)
                        .foregroundStyle(BudgetCalculator.statusColor(utilization))
                    Spacer()
                    Text("\(Int(utilization * 100))% used")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(24)
        .presentationDetents([.height(160)])
        .presentationDragIndicator(.visible)
    }
}
