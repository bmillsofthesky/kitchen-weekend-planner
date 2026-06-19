import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var plans: [WeekendPlan]
    @Query private var movements: [MovementConfiguration]
    @State private var activePlan: WeekendPlan?
    @State private var showStartup = false

    var body: some View {
        Group {
            if let plan = activePlan, let movement = movements.first(where: { $0.id == plan.movementId }) {
                MainTabView(plan: plan, movement: movement)
            } else {
                StartupView(onPlanActivated: { plan in
                    activePlan = plan
                })
            }
        }
        .onAppear { loadActivePlan() }
        .onChange(of: plans) { _, _ in loadActivePlan() }
    }

    private func loadActivePlan() {
        activePlan = plans.first { $0.isActive }
    }
}
