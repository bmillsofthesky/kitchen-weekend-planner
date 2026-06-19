import SwiftUI

struct RecipeURLImportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var urlText = ""
    @State private var isScraping = false
    @State private var scrapedDTO: RecipeDTO?
    @State private var showForm = false
    @State private var errorMessage: String?

    private let scraper = RecipeScraperService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.blue)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter a recipe URL")
                        .font(.headline)
                    TextField("https://...", text: $urlText)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                .padding(.horizontal)

                if let error = errorMessage {
                    Text(error).foregroundStyle(.red).font(.caption)
                }

                Button {
                    Task { await scrape() }
                } label: {
                    if isScraping {
                        ProgressView()
                    } else {
                        Text("Import Recipe")
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isScraping || URL(string: urlText) == nil)

                Spacer()
            }
            .padding(.top, 32)
            .navigationTitle("Import from URL")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            }
            .sheet(isPresented: $showForm) {
                ManualRecipeFormView(prefill: scrapedDTO)
            }
        }
    }

    private func scrape() async {
        guard let url = URL(string: urlText) else { return }
        isScraping = true
        errorMessage = nil
        let result = await scraper.scrape(url: url)
        isScraping = false
        scrapedDTO = result ?? RecipeDTO(id: UUID().uuidString, title: "", sourceURL: urlText)
        showForm = true
    }
}
