import SwiftUI
import SwiftData

struct NewPlanFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var movements: [MovementConfiguration]
    @Query private var existingPlans: [WeekendPlan]

    var onCreated: (WeekendPlan) -> Void

    @State private var planName = ""
    @State private var selectedMovement: MovementConfiguration?
    @State private var errorMessage: String?

    var nameIsAvailable: Bool {
        !planName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !existingPlans.contains { $0.name == planName.trimmingCharacters(in: .whitespaces) }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Plan Details") {
                    TextField("Plan Name", text: $planName)
                        .autocorrectionDisabled()
                }

                Section("Movement") {
                    if movements.isEmpty {
                        Text("No movements configured").foregroundStyle(.secondary)
                    } else {
                        ForEach(movements, id: \.id) { movement in
                            Button {
                                selectedMovement = movement
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(movement.name).foregroundStyle(.primary)
                                        Text("\(movement.abbr) · \(movement.headcount) people")
                                            .font(.caption).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    if selectedMovement?.id == movement.id {
                                        Image(systemName: "checkmark").foregroundStyle(.blue)
                                    }
                                }
                            }
                        }
                    }
                }

                if let error = errorMessage {
                    Section {
                        Text(error).foregroundStyle(.red).font(.caption)
                    }
                }
            }
            .navigationTitle("New Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { createPlan() }
                        .disabled(!nameIsAvailable || selectedMovement == nil)
                }
            }
        }
    }

    private func createPlan() {
        guard let movement = selectedMovement else { return }
        let name = planName.trimmingCharacters(in: .whitespaces)
        guard !existingPlans.contains(where: { $0.name == name }) else {
            errorMessage = "A plan with this name already exists."
            return
        }

        // Deactivate all existing plans
        existingPlans.forEach { $0.isActive = false }

        let plan = WeekendPlan(name: name, movementId: movement.id)
        plan.isActive = true

        // Pre-create MealPlan entries for each slot in the movement
        for slot in movement.allMealSlots {
            let mp = MealPlan(dayNumber: slot.day, mealType: slot.meal.mealType, weekendPlan: plan)
            mp.isPotluck = slot.meal.potluckRequired
            context.insert(mp)
            plan.mealPlans.append(mp)
        }

        context.insert(plan)
        try? context.save()
        onCreated(plan)
    }
}
