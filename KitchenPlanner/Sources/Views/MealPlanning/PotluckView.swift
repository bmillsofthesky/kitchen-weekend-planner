import SwiftUI
import SwiftData

struct PotluckView: View {
    @Bindable var mealPlan: MealPlan
    @Environment(\.modelContext) private var context
    @Environment(\.openURL) private var openURL

    private var urlBinding: Binding<String> {
        Binding(
            get: { mealPlan.potluckUrl ?? "" },
            set: {
                mealPlan.potluckUrl = $0.isEmpty ? nil : $0
                try? context.save()
            }
        )
    }

    private var parsedURL: URL? {
        guard let raw = mealPlan.potluckUrl, !raw.isEmpty else { return nil }
        return URL(string: raw)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(Color.earthyOrange)
                    Text("This meal is a potluck")
                        .font(.title2.bold())
                    Text("Guests will bring their own dishes. Use a coordination service to organize who brings what.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 16)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Coordination Link")
                        .font(.headline)
                    TextField("https://signup.com/...", text: urlBinding)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    if let url = parsedURL {
                        Button {
                            openURL(url)
                        } label: {
                            Label("Open link", systemImage: "arrow.up.right.square")
                                .font(.subheadline)
                                .foregroundStyle(Color.earthyOrange)
                        }
                    }
                }
                .padding()
                .background(Color.warmCanvas)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
            }
            .padding()
        }
        .navigationTitle("Day \(mealPlan.dayNumber) · \(mealPlan.mealType)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
