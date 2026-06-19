import SwiftUI
import SwiftData

struct LoadPlanView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \WeekendPlan.createdAt, order: .reverse) private var plans: [WeekendPlan]
    @Query private var movements: [MovementConfiguration]

    var onSelected: (WeekendPlan) -> Void

    var body: some View {
        NavigationStack {
            Group {
                if plans.isEmpty {
                    ContentUnavailableView("No Plans", systemImage: "doc.text",
                                          description: Text("Create a new plan to get started."))
                } else {
                    List(plans) { plan in
                        Button {
                            activate(plan: plan)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(plan.name).foregroundStyle(.primary).font(.headline)
                                    if let m = movements.first(where: { $0.id == plan.movementId }) {
                                        Text(m.name).font(.caption).foregroundStyle(.secondary)
                                    }
                                    Text(plan.createdAt.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption2).foregroundStyle(.tertiary)
                                }
                                Spacer()
                                if plan.isActive {
                                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Load Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func activate(plan: WeekendPlan) {
        plans.forEach { $0.isActive = false }
        plan.isActive = true
        try? context.save()
        onSelected(plan)
    }
}
