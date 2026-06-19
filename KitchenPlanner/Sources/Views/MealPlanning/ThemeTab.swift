import SwiftUI
import PhotosUI
import SafariServices

struct ThemeTab: View {
    @Bindable var mealPlan: MealPlan
    @Environment(\.modelContext) private var context

    var theme: Theme {
        if let t = mealPlan.theme { return t }
        let t = Theme()
        mealPlan.theme = t
        context.insert(t)
        return t
    }

    var body: some View {
        ThemeEditorView(theme: theme)
    }
}

struct ThemeEditorView: View {
    @Bindable var theme: Theme
    @Environment(\.modelContext) private var context

    @State private var coverPhotoItem: PhotosPickerItem?
    @State private var referencePhotoItems: [PhotosPickerItem] = []
    @State private var showSkitForm = false
    @State private var selectedSkit: Skit?
    @State private var showNeededItemForm = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Cover image
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cover Image").font(.subheadline.bold()).foregroundStyle(.secondary)
                    if let imageData = theme.coverImageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    PhotosPicker(selection: $coverPhotoItem, matching: .images) {
                        Label(theme.coverImageData == nil ? "Add Cover Image" : "Change Cover Image",
                              systemImage: "photo.badge.plus")
                    }
                    .onChange(of: coverPhotoItem) { _, item in
                        Task {
                            if let data = try? await item?.loadTransferable(type: Data.self) {
                                theme.coverImageData = data
                                try? context.save()
                            }
                        }
                    }
                }

                // Title
                VStack(alignment: .leading, spacing: 4) {
                    Text("Theme Title").font(.subheadline.bold()).foregroundStyle(.secondary)
                    TextField("e.g. Italian Night", text: Binding(
                        get: { theme.title },
                        set: { theme.title = $0 }
                    ))
                    .textFieldStyle(.roundedBorder)
                }

                // Description
                VStack(alignment: .leading, spacing: 4) {
                    Text("Description").font(.subheadline.bold()).foregroundStyle(.secondary)
                    TextEditor(text: Binding(
                        get: { theme.themeDescription },
                        set: { theme.themeDescription = $0 }
                    ))
                    .frame(minHeight: 80)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.separator))
                }

                // Design Details
                VStack(alignment: .leading, spacing: 4) {
                    Text("Design Details").font(.subheadline.bold()).foregroundStyle(.secondary)
                    TextEditor(text: Binding(
                        get: { theme.designDetails },
                        set: { theme.designDetails = $0 }
                    ))
                    .frame(minHeight: 60)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.separator))
                }

                // Needed Items
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Needed Items").font(.subheadline.bold()).foregroundStyle(.secondary)
                        Spacer()
                        Button { showNeededItemForm = true } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                    ForEach(theme.neededItems) { item in
                        NeededItemRowView(item: item, onDelete: {
                            var items = theme.neededItems
                            items.removeAll { $0.id == item.id }
                            theme.neededItems = items
                            try? context.save()
                        })
                    }
                    if theme.neededItems.isEmpty {
                        Text("No items yet").font(.caption).foregroundStyle(.tertiary)
                    }
                }

                // Reference Images
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Reference Images").font(.subheadline.bold()).foregroundStyle(.secondary)
                        Spacer()
                        PhotosPicker(selection: $referencePhotoItems, maxSelectionCount: 10, matching: .images) {
                            Image(systemName: "photo.badge.plus")
                        }
                        .onChange(of: referencePhotoItems) { _, items in
                            Task {
                                var newData: [Data] = []
                                for item in items {
                                    if let data = try? await item.loadTransferable(type: Data.self) {
                                        newData.append(data)
                                    }
                                }
                                theme.referenceImagesData = newData
                                try? context.save()
                            }
                        }
                    }
                    if !theme.referenceImagesData.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(theme.referenceImagesData.indices, id: \.self) { i in
                                    if let uiImage = UIImage(data: theme.referenceImagesData[i]) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                        }
                    }
                }

                // Skits
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Skits").font(.subheadline.bold()).foregroundStyle(.secondary)
                        Spacer()
                        Button { showSkitForm = true } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                    ForEach(theme.skits) { skit in
                        NavigationLink {
                            SkitDetailView(skit: skit, theme: theme)
                        } label: {
                            HStack {
                                Text(skit.name).font(.subheadline)
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(.tertiary).font(.caption)
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                        Divider()
                    }
                    if theme.skits.isEmpty {
                        Text("No skits yet").font(.caption).foregroundStyle(.tertiary)
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showNeededItemForm) {
            NeededItemFormView { item in
                var items = theme.neededItems
                items.append(item)
                theme.neededItems = items
                try? context.save()
            }
        }
        .sheet(isPresented: $showSkitForm) {
            SkitEditorView { skit in
                var skits = theme.skits
                skits.append(skit)
                theme.skits = skits
                try? context.save()
            }
        }
    }
}

struct NeededItemRowView: View {
    var item: NeededItem
    var onDelete: () -> Void
    @State private var showSafari = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name).font(.subheadline)
                Text("Qty: \(item.quantity)").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            if let link = item.link, let url = URL(string: link), !link.isEmpty {
                Button { showSafari = true } label: {
                    Image(systemName: "safari").foregroundStyle(.blue)
                }
                .sheet(isPresented: $showSafari) {
                    SafariView(url: url)
                }
            }
            Button(role: .destructive) { onDelete() } label: {
                Image(systemName: "trash").foregroundStyle(.red)
            }
        }
        .padding(.vertical, 2)
    }
}

struct NeededItemFormView: View {
    var onAdd: (NeededItem) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var quantity = ""
    @State private var link = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Item name", text: $name)
                TextField("Quantity (e.g. 2, 1 set)", text: $quantity)
                TextField("URL (optional)", text: $link)
                    .keyboardType(.URL)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            .navigationTitle("Needed Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(NeededItem(name: name, quantity: quantity,
                                         link: link.isEmpty ? nil : link))
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

struct SkitEditorView: View {
    var onSave: (Skit) -> Void
    var existingSkit: Skit? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var details = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Skit Name", text: $name)
                TextEditor(text: $details)
                    .frame(minHeight: 120)
            }
            .navigationTitle(existingSkit == nil ? "New Skit" : "Edit Skit")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                name = existingSkit?.name ?? ""
                details = existingSkit?.details ?? ""
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(Skit(id: existingSkit?.id ?? UUID(), name: name, details: details))
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

struct SkitDetailView: View {
    var skit: Skit
    @Bindable var theme: Theme
    @Environment(\.modelContext) private var context
    @State private var showEdit = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(skit.details.isEmpty ? "No script written yet." : skit.details)
                    .font(.body)
                    .foregroundStyle(skit.details.isEmpty ? .tertiary : .primary)
            }
            .padding()
        }
        .navigationTitle(skit.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showEdit = true }
            }
        }
        .sheet(isPresented: $showEdit) {
            SkitEditorView(onSave: { updated in
                var skits = theme.skits
                if let i = skits.firstIndex(where: { $0.id == skit.id }) {
                    skits[i] = updated
                    theme.skits = skits
                    try? context.save()
                }
            }, existingSkit: skit)
        }
    }
}

// MARK: - Safari wrapper

struct SafariView: UIViewControllerRepresentable {
    var url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}
