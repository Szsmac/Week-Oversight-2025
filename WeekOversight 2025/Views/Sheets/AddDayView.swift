import SwiftUI

struct AddDayView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var errorHandler: ErrorHandler
    @ObservedObject var viewModel: DayOversightEditorViewModel
    
    @State private var date = Date()
    @State private var isLoading = false
    
    var body: some View {
        Form {
            Section {
                DatePicker("Date", selection: $date, displayedComponents: [.date])
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
                    Task { await addDay() }
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
    
    private func addDay() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await viewModel.createDayOversight(date: date)
            dismiss()
        } catch {
            errorHandler.handle(error)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let weekOversight = PreviewData.createPreviewWeekOversight(in: context)
    let viewModel = DayOversightEditorViewModel(context: context, weekOversight: weekOversight)
    return AddDayView(viewModel: viewModel)
        .withPreviewEnvironment()
} 