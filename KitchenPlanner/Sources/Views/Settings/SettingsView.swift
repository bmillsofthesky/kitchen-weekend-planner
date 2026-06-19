import SwiftUI
import SwiftData
import MessageUI

struct SettingsView: View {
    var plan: WeekendPlan
    var movement: MovementConfiguration

    @Environment(\.modelContext) private var context
    @Query private var allPlans: [WeekendPlan]
    @Query private var allMovements: [MovementConfiguration]

    @State private var showNewPlan = false
    @State private var showLoadPlan = false
    @State private var showImportPlan = false
    @State private var showExportAlert = false
    @State private var exportAlertTitle = ""
    @State private var exportAlertMessage = ""
    @State private var isExporting = false
    @State private var showMailCompose = false
    @State private var exportData: Data?
    @State private var showShareSheet = false

    var body: some View {
        List {
            Section("Active Plan") {
                LabeledContent("Plan", value: plan.name)
                LabeledContent("Movement", value: movement.abbr)
                LabeledContent("Headcount", value: "\(movement.headcount)")
            }

            Section("Plan Management") {
                Button { showNewPlan = true } label: {
                    Label("New Plan", systemImage: "plus.circle")
                }
                Button { showLoadPlan = true } label: {
                    Label("Load Plan", systemImage: "folder")
                }
                Button { showImportPlan = true } label: {
                    Label("Import Plan", systemImage: "square.and.arrow.down")
                }
            }

            Section("Export") {
                Button {
                    Task { await exportPlan() }
                } label: {
                    if isExporting {
                        HStack { ProgressView(); Text("Exporting…") }
                    } else {
                        Label("Export Plan to \(movement.exportEmail)", systemImage: "envelope")
                    }
                }
                .disabled(isExporting)
            }
        }
        .navigationTitle("Settings")
        .sheet(isPresented: $showNewPlan) {
            NewPlanFormView(onCreated: { _ in showNewPlan = false })
        }
        .sheet(isPresented: $showLoadPlan) {
            LoadPlanView(onSelected: { _ in showLoadPlan = false })
        }
        .sheet(isPresented: $showImportPlan) {
            PlanFileImportView(onImported: { _ in showImportPlan = false })
        }
        .sheet(isPresented: $showMailCompose) {
            if let data = exportData {
                MailComposeView(
                    toEmail: movement.exportEmail,
                    planName: plan.name,
                    attachmentData: data,
                    onResult: { result in
                        showMailCompose = false
                        switch result {
                        case .sent:
                            exportAlertTitle = "Sent"
                            exportAlertMessage = "Your plan was emailed successfully."
                        case .failed:
                            exportAlertTitle = "Failed"
                            exportAlertMessage = "The email could not be sent."
                        default:
                            return
                        }
                        showExportAlert = true
                    }
                )
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let data = exportData {
                ShareSheet(items: [data])
            }
        }
        .alert(exportAlertTitle, isPresented: $showExportAlert) {
            Button("OK") {}
        } message: {
            Text(exportAlertMessage)
        }
    }

    private func exportPlan() async {
        isExporting = true
        defer { isExporting = false }

        do {
            let data = try PlanExporter.generateJSON(plan: plan, movement: movement)
            exportData = data

            if PlanExporter.canSendMail() {
                showMailCompose = true
            } else {
                showShareSheet = true
            }
        } catch {
            exportAlertTitle = "Export Failed"
            exportAlertMessage = error.localizedDescription
            showExportAlert = true
        }
    }
}

// MARK: - Mail Compose

struct MailComposeView: UIViewControllerRepresentable {
    var toEmail: String
    var planName: String
    var attachmentData: Data
    var onResult: (MFMailComposeResult) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(onResult: onResult) }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([toEmail])
        vc.setSubject("Weekend Plan: \(planName)")
        vc.setMessageBody("Please find the weekend plan attached.", isHTML: false)
        vc.addAttachmentData(attachmentData, mimeType: "application/json",
                             fileName: "\(planName).json")
        return vc
    }

    func updateUIViewController(_ vc: MFMailComposeViewController, context: Context) {}

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var onResult: (MFMailComposeResult) -> Void
        init(onResult: @escaping (MFMailComposeResult) -> Void) { self.onResult = onResult }
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
            onResult(result)
        }
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
