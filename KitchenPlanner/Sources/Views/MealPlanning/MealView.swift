import SwiftUI
import SwiftData

struct MealView: View {
    @Bindable var mealPlan: MealPlan
    var movement: MovementConfiguration
    @Environment(\.modelContext) private var context

    @State private var selectedTab = 0
    @State private var isEditing = false

    var mealConfig: MealConfig? {
        movement.mealConfig(day: mealPlan.dayNumber, mealType: mealPlan.mealTypeEnum)
    }

    var isPotluckEligible: Bool { mealConfig?.potluckEligible ?? false }
    var isPotluckRequired: Bool { mealConfig?.potluckRequired ?? false }

    var body: some View {
        Group {
            if selectedTab == 0 {
                RecipesTab(mealPlan: mealPlan, movement: movement, isEditing: $isEditing,
                           isPotluckEligible: isPotluckEligible,
                           isPotluckRequired: isPotluckRequired)
            } else {
                ThemeTab(mealPlan: mealPlan)
            }
        }
        .navigationTitle("Day \(mealPlan.dayNumber) · \(mealPlan.mealType)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("View", selection: $selectedTab) {
                    Label("Recipes", systemImage: "fork.knife").tag(0)
                    Label("Theme", systemImage: "paintbrush.fill").tag(1)
                }
                .pickerStyle(.segmented)
                .fixedSize()
            }
            if selectedTab == 0 {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isEditing ? "Done" : "Edit") {
                        isEditing.toggle()
                    }
                }
            }
        }
    }
}

// MARK: - Recipes Tab

struct RecipesTab: View {
    @Bindable var mealPlan: MealPlan
    var movement: MovementConfiguration
    @Binding var isEditing: Bool
    var isPotluckEligible: Bool
    var isPotluckRequired: Bool = false
    @Environment(\.modelContext) private var context
    @Query(sort: \Recipe.title) private var allRecipes: [Recipe]

    var body: some View {
        HStack(spacing: 0) {
            // Meal slot columns
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if isPotluckEligible && !isPotluckRequired {
                        Toggle("Potluck Meal", isOn: Binding(
                            get: { mealPlan.isPotluck },
                            set: { mealPlan.isPotluck = $0; try? context.save() }
                        ))
                        .padding(.horizontal)
                    }

                    ForEach(RecipeSlot.allCases, id: \.self) { slot in
                        RecipeSlotView(
                            slot: slot,
                            assignments: mealPlan.assignmentsForSlot(slot),
                            isEditing: isEditing,
                            headcount: movement.headcount,
                            onDrop: { recipe in assign(recipe: recipe, slot: slot) },
                            onMove: { from, to in move(slot: slot, from: from, to: to) },
                            onDelete: { assignment in delete(assignment: assignment) }
                        )
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                if isPotluckRequired && !mealPlan.isPotluck {
                    mealPlan.isPotluck = true
                    try? context.save()
                }
            }

            if isEditing {
                Divider()
                // Library panel
                VStack(alignment: .leading, spacing: 4) {
                    Text("Library")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    List(allRecipes) { recipe in
                        Text(recipe.title)
                            .font(.caption)
                            .draggable(recipe.id)
                    }
                }
                .frame(width: 160)
                .background(.background.secondary)
            }
        }
    }

    private func assign(recipe: Recipe, slot: RecipeSlot) {
        let existing = mealPlan.assignmentsForSlot(slot)
        let order = (existing.map(\.order).max() ?? -1) + 1
        let assignment = RecipeAssignment(recipe: recipe, slot: slot, order: order)
        assignment.mealPlan = mealPlan
        context.insert(assignment)
        mealPlan.assignments.append(assignment)
        try? context.save()
    }

    private func move(slot: RecipeSlot, from: IndexSet, to: Int) {
        var slotAssignments = mealPlan.assignmentsForSlot(slot)
        slotAssignments.move(fromOffsets: from, toOffset: to)
        slotAssignments.enumerated().forEach { $0.element.order = $0.offset }
        try? context.save()
    }

    private func delete(assignment: RecipeAssignment) {
        mealPlan.assignments.removeAll { $0.id == assignment.id }
        context.delete(assignment)
        try? context.save()
    }
}

struct RecipeSlotView: View {
    var slot: RecipeSlot
    var assignments: [RecipeAssignment]
    var isEditing: Bool
    var headcount: Int
    var onDrop: (Recipe) -> Void
    var onMove: (IndexSet, Int) -> Void
    var onDelete: (RecipeAssignment) -> Void

    @Query private var recipes: [Recipe]
    @State private var isDropTargeted = false

    @ViewBuilder
    private func slotThumbnail(for recipe: Recipe) -> some View {
        if let urlString = recipe.coverImage, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                if case .success(let image) = phase {
                    image.resizable().scaledToFill()
                } else {
                    slotPlaceholder
                }
            }
        } else {
            slotPlaceholder
        }
    }

    private var slotPlaceholder: some View {
        ZStack {
            LinearGradient(
                colors: [Color.warmCanvas, Color(red: 0.92, green: 0.88, blue: 0.82)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: "fork.knife")
                .font(.system(size: 14))
                .foregroundStyle(Color.earthyOrange.opacity(0.6))
        }
    }

    var slotIcon: String {
        switch slot {
        case .main: return "fork.knife"
        case .side: return "leaf.fill"
        case .dessert: return "birthday.cake.fill"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(slot.rawValue + "s", systemImage: slotIcon)
                .font(.subheadline.bold())
                .foregroundStyle(Color.earthyOrange)

            if assignments.isEmpty {
                Text("None assigned")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(isDropTargeted && isEditing ? Color.earthyOrange.opacity(0.08) : .clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isDropTargeted && isEditing ? Color.earthyOrange : Color.clear, lineWidth: 2)
                    )
            } else {
                if isEditing {
                    List {
                        ForEach(assignments) { a in
                            if let recipe = a.recipe {
                                HStack {
                                    Image(systemName: "line.3.horizontal")
                                        .foregroundStyle(.tertiary)
                                    Text(recipe.title).font(.subheadline)
                                    Spacer()
                                    Text(recipe.costLabel(headcount: headcount))
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onMove { onMove($0, $1) }
                        .onDelete { idxs in
                            idxs.forEach { onDelete(assignments[$0]) }
                        }
                    }
                    .listStyle(.plain)
                    .frame(height: CGFloat(assignments.count) * 44 + 8)
                } else {
                    ForEach(assignments) { a in
                        if let recipe = a.recipe {
                            NavigationLink {
                                RecipeDetailView(recipe: recipe, headcount: headcount)
                            } label: {
                                HStack(spacing: 10) {
                                    slotThumbnail(for: recipe)
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    Text(recipe.title)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                    Spacer()
                                    Text(recipe.costLabel(headcount: headcount))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.warmCanvas)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
        .dropDestination(for: String.self) { ids, _ in
            guard isEditing, let id = ids.first,
                  let recipe = recipes.first(where: { $0.id == id }) else { return false }
            onDrop(recipe)
            return true
        } isTargeted: { isDropTargeted = $0 }
    }
}
