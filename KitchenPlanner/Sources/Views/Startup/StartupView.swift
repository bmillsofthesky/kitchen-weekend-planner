import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct StartupView: View {
    @Environment(\.modelContext) private var context
    var onPlanActivated: (WeekendPlan) -> Void

    @State private var showNewPlan = false
    @State private var showLoadPlan = false
    @State private var showImportPlan = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.orange)
                    Text("Kitchen Weekend Planner")
                        .font(.title.bold())
                    Text("Plan meals, themes, and budgets for your retreat weekend.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)

                VStack(spacing: 16) {
                    Button {
                        showNewPlan = true
                    } label: {
                        Label("New Weekend Plan", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button {
                        showLoadPlan = true
                    } label: {
                        Label("Load Weekend Plan", systemImage: "folder.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)

                    Button {
                        showImportPlan = true
                    } label: {
                        Label("Import Weekend Plan", systemImage: "square.and.arrow.down.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                .padding(.horizontal, 32)

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: $showNewPlan) {
                NewPlanFormView(onCreated: { plan in
                    showNewPlan = false
                    onPlanActivated(plan)
                })
            }
            .sheet(isPresented: $showLoadPlan) {
                LoadPlanView(onSelected: { plan in
                    showLoadPlan = false
                    onPlanActivated(plan)
                })
            }
            .sheet(isPresented: $showImportPlan) {
                PlanFileImportView(onImported: { plan in
                    showImportPlan = false
                    onPlanActivated(plan)
                })
            }
        }
    }
}
