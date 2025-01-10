import SwiftUI

struct AddWeekOversightView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var errorHandler: ErrorHandler
    @ObservedObject var viewModel: ClientGroupViewModel
    @State private var weekNumber = 1
    @State private var isLoading = false
    let group: ClientGroup
    
    var body: some View {
        Form {
            Section {
                Stepper("Week \(weekNumber)", value: $weekNumber, in: 1...52)
            }
        }
        .formStyle(.grouped)
        .frame(minWidth: 300, minHeight: 150)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    Task { await addWeek() }
                }
                .disabled(isLoading)
            }
        }
        .disabled(isLoading)
        .overlay {
            if isLoading {
                LoadingView()
            }
        }
    }
    
    private func addWeek() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await viewModel.createWeekOversight(weekNumber: weekNumber, for: group)
            dismiss()
        } catch {
            errorHandler.handle(error)
        }
    }
}

#Preview {
    AddWeekOversightView(
        viewModel: .preview,
        group: .preview
    )
    .withPreviewEnvironment()
} 