import SwiftUI
import SwiftData

struct ManualRecipeFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var prefill: RecipeDTO? = nil

    @State private var title = ""
    @State private var description = ""
    @State private var type: RecipeType = .other
    @State private var costPerServing = ""
    @State private var labels: [String] = []
    @State private var labelInput = ""
    @State private var ingredients: [Ingredient] = []
    @State private var directions: [Direction] = []
    @State private var notes = ""

    @State private var showIngredientForm = false
    @State private var showDirectionForm = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                    Picker("Type", selection: $type) {
                        ForEach(RecipeType.allCases, id: \.self) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    TextField("Cost per serving ($)", text: $costPerServing)
                        .keyboardType(.decimalPad)
                }

                Section("Labels") {
                    HStack {
                        TextField("Add label", text: $labelInput)
                        Button("Add") {
                            let t = labelInput.trimmingCharacters(in: .whitespaces)
                            if !t.isEmpty { labels.append(t); labelInput = "" }
                        }
                        .disabled(labelInput.isEmpty)
                    }
                    ForEach(labels, id: \.self) { label in
                        Text(label)
                    }
                    .onDelete { labels.remove(atOffsets: $0) }
                }

                Section("Ingredients") {
                    ForEach(ingredients) { ing in
                        HStack {
                            Text(formatAmount(ing.amount))
                                .foregroundStyle(.secondary)
                                .frame(width: 50, alignment: .trailing)
                            Text(ing.measurement)
                                .foregroundStyle(.secondary)
                                .frame(width: 50)
                            Text(ing.name)
                        }
                        .font(.subheadline)
                    }
                    .onDelete { ingredients.remove(atOffsets: $0) }
                    Button("Add Ingredient") { showIngredientForm = true }
                }

                Section("Directions") {
                    ForEach(directions.sorted { $0.order < $1.order }) { dir in
                        HStack(alignment: .top) {
                            Text("\(dir.order).").foregroundStyle(.secondary)
                            Text(dir.text)
                        }
                        .font(.subheadline)
                    }
                    .onDelete { idxs in
                        idxs.forEach { directions.remove(at: $0) }
                    }
                    Button("Add Direction") { showDirectionForm = true }
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(4, reservesSpace: true)
                }
            }
            .navigationTitle(prefill == nil ? "New Recipe" : "Edit Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear { applyPrefill() }
            .sheet(isPresented: $showIngredientForm) {
                IngredientFormView { ing in ingredients.append(ing) }
            }
            .sheet(isPresented: $showDirectionForm) {
                DirectionFormView(nextOrder: (directions.map(\.order).max() ?? 0) + 1) { dir in
                    directions.append(dir)
                }
            }
        }
    }

    private func applyPrefill() {
        guard let dto = prefill else { return }
        title = dto.title
        description = dto.description ?? ""
        type = RecipeType(rawValue: dto.type ?? "") ?? .other
        costPerServing = dto.costPerServing.map { String($0) } ?? ""
        labels = dto.labels ?? []
        let servings = dto.servings ?? 1
        ingredients = (dto.ingredients ?? []).map { ing in
            Ingredient(
                name: ing.name,
                measurement: ing.measurement ?? "",
                amount: (ing.amount ?? 0) / Double(max(servings, 1)),
                section: ing.section ?? ""
            )
        }
        directions = (dto.directions ?? []).enumerated().map { i, dir in
            Direction(order: dir.order ?? i + 1, text: dir.text, section: dir.section ?? "")
        }
        notes = dto.notes ?? ""
    }

    private func save() {
        let recipe = Recipe(
            title: title.trimmingCharacters(in: .whitespaces),
            description: description,
            costPerServing: Double(costPerServing),
            type: type,
            labels: labels,
            ingredients: ingredients,
            directions: directions,
            notes: notes,
            isCustom: true
        )
        context.insert(recipe)
        try? context.save()
        dismiss()
    }

    private func formatAmount(_ v: Double) -> String {
        v == v.rounded() ? "\(Int(v))" : String(format: "%.2f", v)
    }
}

struct IngredientFormView: View {
    var onAdd: (Ingredient) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var measurement = ""
    @State private var amount = ""
    @State private var section = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                TextField("Amount (single serving)", text: $amount).keyboardType(.decimalPad)
                TextField("Measurement (cups, tbsp…)", text: $measurement)
                TextField("Section (optional)", text: $section)
            }
            .navigationTitle("Ingredient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(Ingredient(name: name, measurement: measurement,
                                         amount: Double(amount) ?? 0, section: section))
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

struct DirectionFormView: View {
    var nextOrder: Int
    var onAdd: (Direction) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""
    @State private var section = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Instruction", text: $text, axis: .vertical)
                    .lineLimit(4, reservesSpace: true)
                TextField("Section (optional)", text: $section)
            }
            .navigationTitle("Direction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(Direction(order: nextOrder, text: text, section: section))
                        dismiss()
                    }
                    .disabled(text.isEmpty)
                }
            }
        }
    }
}
