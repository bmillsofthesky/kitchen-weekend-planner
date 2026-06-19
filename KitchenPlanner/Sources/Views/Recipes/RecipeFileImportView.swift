import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct RecipeFileImportView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var showPicker = false
    @State private var errorMessage: String?
    @State private var successMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "doc.badge.plus")
                    .font(.system(size: 56))
                    .foregroundStyle(.green)

                Text("Import recipes from a JSON file matching the recipe schema.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                Button("Choose File") { showPicker = true }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                if let error = errorMessage {
                    Text(error).foregroundStyle(.red).font(.caption)
                }
                if let success = successMessage {
                    Text(success).foregroundStyle(.green).font(.caption)
                }
            }
            .padding()
            .navigationTitle("Import Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Done") { dismiss() } }
            }
            .fileImporter(isPresented: $showPicker, allowedContentTypes: [.json]) { result in
                importFile(result: result)
            }
        }
    }

    private func importFile(result: Result<URL, Error>) {
        do {
            let url = try result.get()
            guard url.startAccessingSecurityScopedResource() else {
                errorMessage = "Could not access file."
                return
            }
            defer { url.stopAccessingSecurityScopedResource() }
            let data = try Data(contentsOf: url)
            try RecipeSyncService.importFromData(data, context: context)
            successMessage = "Recipes imported successfully."
            errorMessage = nil
        } catch {
            errorMessage = "Import failed: \(error.localizedDescription)"
            successMessage = nil
        }
    }
}
