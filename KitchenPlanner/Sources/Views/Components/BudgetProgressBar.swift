import SwiftUI

struct BudgetProgressBar: View {
    var plan: WeekendPlan
    var movement: MovementConfiguration

    var utilization: Double {
        BudgetCalculator.utilization(plan: plan, movement: movement)
    }

    var barColor: Color {
        switch utilization {
        case ..<0.7: return .green
        case 0.7..<1.0: return .yellow
        default: return .red
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.secondary.opacity(0.2))
                Rectangle()
                    .fill(barColor)
                    .frame(width: geo.size.width * min(utilization, 1.0))
                    .animation(.easeInOut(duration: 0.3), value: utilization)
            }
        }
        .frame(height: 4)
        .accessibilityLabel("Budget utilization \(Int(utilization * 100)) percent")
    }
}
