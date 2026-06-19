import SwiftUI
import SwiftData

struct RecipeLibraryView: View {
    var movement: MovementConfiguration

    @Query(sort: \Recipe.title) private var allRecipes: [Recipe]
    @State private var searchText = ""
    @State private var filterType: RecipeType? = nil
    @State private var showAddMenu = false
    @State private var showManualForm = false
    @State private var showURLImport = false
    @State private var showFileImport = false
    @State private var isSyncing = false
    @Environment(\.modelContext) private var context

    var filtered: [Recipe] {
        allRecipes.filter { r in
            let matchesSearch = searchText.isEmpty ||
                r.title.localizedCaseInsensitiveContains(searchText)
            let matchesType = filterType == nil || r.type == filterType?.rawValue
            return matchesSearch && matchesType
        }
    }

    var body: some View {
        List {
            ForEach(filtered) { recipe in
                NavigationLink {
                    RecipeDetailView(recipe: recipe, headcount: movement.headcount)
                } label: {
                    RecipeRowView(recipe: recipe, headcount: movement.headcount)
                }
            }
        }
        .navigationTitle("Recipes")
        .searchable(text: $searchText, prompt: "Search recipes")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    Button("All Types") { filterType = nil }
                    ForEach(RecipeType.allCases, id: \.self) { t in
                        Button(t.rawValue) { filterType = t }
                    }
                } label: {
                    Label("Filter", systemImage: filterType == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        Task { await syncRecipes() }
                    } label: {
                        if isSyncing {
                            ProgressView().controlSize(.small)
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                    .disabled(isSyncing || movement.recipesUrl.isEmpty)

                    Menu {
                        Button { showManualForm = true } label: {
                            Label("Add Manually", systemImage: "square.and.pencil")
                        }
                        Button { showURLImport = true } label: {
                            Label("Import from URL", systemImage: "link")
                        }
                        Button { showFileImport = true } label: {
                            Label("Import from File", systemImage: "doc.badge.plus")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showManualForm) {
            ManualRecipeFormView()
        }
        .sheet(isPresented: $showURLImport) {
            RecipeURLImportView()
        }
        .sheet(isPresented: $showFileImport) {
            RecipeFileImportView()
        }
    }

    private func syncRecipes() async {
        isSyncing = true
        defer { isSyncing = false }
        try? await RecipeSyncService.sync(movement: movement, context: context)
    }
}

struct RecipeRowView: View {
    var recipe: Recipe
    var headcount: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(recipe.title).font(.headline)
                HStack(spacing: 6) {
                    Text(recipe.recipeType.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(.blue.opacity(0.1))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                    if recipe.isCustom {
                        Text("Custom")
                            .font(.caption)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(.purple.opacity(0.1))
                            .foregroundStyle(.purple)
                            .clipShape(Capsule())
                    }
                    Text(recipe.costLabel(headcount: headcount))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding(.vertical, 2)
    }
}
