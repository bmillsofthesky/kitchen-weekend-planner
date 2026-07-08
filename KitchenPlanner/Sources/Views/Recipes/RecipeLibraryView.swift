import SwiftUI
import SwiftData

struct RecipeLibraryView: View {
    var movement: MovementConfiguration

    @Query(sort: \Recipe.title) private var allRecipes: [Recipe]
    @State private var searchText = ""
    @State private var filterType: RecipeType? = nil
    @State private var showManualForm = false
    @State private var showURLImport = false
    @State private var showFileImport = false
    @State private var isSyncing = false
    @Environment(\.modelContext) private var context

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var filtered: [Recipe] {
        allRecipes.filter { r in
            let matchesSearch = searchText.isEmpty ||
                r.title.localizedCaseInsensitiveContains(searchText)
            let matchesType = filterType == nil || r.type == filterType?.rawValue
            return matchesSearch && matchesType
        }
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(filtered) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipe: recipe, headcount: movement.headcount)
                    } label: {
                        RecipeCardView(recipe: recipe, headcount: movement.headcount)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(Color.warmCanvas)
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

struct RecipeCardView: View {
    var recipe: Recipe
    var headcount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            coverImageView
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                HStack(spacing: 4) {
                    Text(recipe.recipeType.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Color.earthyOrange.opacity(0.12))
                        .foregroundStyle(Color.earthyOrange)
                        .clipShape(Capsule())

                    Text(recipe.costLabel(headcount: headcount))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 4, y: 2)
    }

    @ViewBuilder
    private var coverImageView: some View {
        if let urlString = recipe.coverImage, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                if case .success(let image) = phase {
                    image.resizable().scaledToFill()
                } else {
                    cardPlaceholder
                }
            }
            .clipped()
        } else {
            cardPlaceholder
        }
    }

    private var cardPlaceholder: some View {
        ZStack {
            LinearGradient(
                colors: [Color.warmCanvas, Color(red: 0.92, green: 0.88, blue: 0.82)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: "fork.knife")
                .font(.system(size: 28))
                .foregroundStyle(Color.earthyOrange.opacity(0.6))
        }
    }
}
