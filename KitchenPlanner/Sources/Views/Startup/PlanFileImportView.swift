import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct PlanFileImportView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var existingPlans: [WeekendPlan]
    @Query private var movements: [MovementConfiguration]

    var onImported: (WeekendPlan) -> Void

    @State private var showFilePicker = false
    @State private var conflictPlan: PlanImportDTO?
    @State private var existingMatch: WeekendPlan?
    @State private var showConflictSheet = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "square.and.arrow.down.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.orange)

                Text("Import a weekend plan JSON file exported from another device.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                Button("Choose File") { showFilePicker = true }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                if let error = errorMessage {
                    Text(error).foregroundStyle(.red).font(.caption)
                }
            }
            .padding()
            .navigationTitle("Import Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.json]) { result in
                handleFile(result: result)
            }
            .sheet(isPresented: $showConflictSheet) {
                if let dto = conflictPlan, let existing = existingMatch {
                    PlanConflictView(
                        imported: dto,
                        existing: existing,
                        onOverwrite: { overwrite(dto: dto, existing: existing) },
                        onMerge: { merge(dto: dto, into: existing) }
                    )
                }
            }
        }
    }

    private func handleFile(result: Result<URL, Error>) {
        do {
            let url = try result.get()
            guard url.startAccessingSecurityScopedResource() else { return }
            defer { url.stopAccessingSecurityScopedResource() }
            let data = try Data(contentsOf: url)
            let dto = try JSONDecoder().decode(PlanImportDTO.self, from: data)

            if let existing = existingPlans.first(where: { $0.name == dto.name }) {
                conflictPlan = dto
                existingMatch = existing
                showConflictSheet = true
            } else {
                let plan = importNewPlan(dto: dto)
                activate(plan: plan)
                onImported(plan)
            }
        } catch {
            errorMessage = "Could not import file: \(error.localizedDescription)"
        }
    }

    private func importNewPlan(dto: PlanImportDTO) -> WeekendPlan {
        let plan = WeekendPlan(name: dto.name, movementId: dto.movementId)
        context.insert(plan)
        // TODO: populate meal plans from dto
        return plan
    }

    private func overwrite(dto: PlanImportDTO, existing: WeekendPlan) {
        context.delete(existing)
        let plan = importNewPlan(dto: dto)
        activate(plan: plan)
        showConflictSheet = false
        onImported(plan)
    }

    private func merge(dto: PlanImportDTO, into plan: WeekendPlan) {
        // Non-conflicting merge: update name if same, keep local assignments
        try? context.save()
        activate(plan: plan)
        showConflictSheet = false
        onImported(plan)
    }

    private func activate(plan: WeekendPlan) {
        existingPlans.forEach { $0.isActive = false }
        plan.isActive = true
        try? context.save()
    }
}

struct PlanImportDTO: Codable {
    var name: String
    var movementId: Int
}

struct PlanConflictView: View {
    var imported: PlanImportDTO
    var existing: WeekendPlan
    var onOverwrite: () -> Void
    var onMerge: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.yellow)

                Text("A plan named \"\(imported.name)\" already exists.")
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text("Choose how to handle the import:")
                    .foregroundStyle(.secondary)

                VStack(spacing: 12) {
                    Button("Overwrite Existing", role: .destructive) { onOverwrite() }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .frame(maxWidth: .infinity)

                    Button("Merge") { onMerge() }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Conflict")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
