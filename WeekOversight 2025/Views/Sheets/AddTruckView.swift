import SwiftUI

struct AddTruckView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var errorHandler: ErrorHandler
    @ObservedObject var viewModel: DayOversightViewModel
    
    @State private var distributionCenter = ""
    @State private var arrivalTime = Date()
    @State private var boxes = 0
    @State private var rollies = 0
    @State private var isLoading = false
    
    var body: some View {
        Form {
            Section {
                ValidatedTextField(
                    text: $distributionCenter,
                    title: "Distribution Center",
                    placeholder: "Enter distribution center",
                    validation: { !$0.isEmpty }
                )
                
                DatePicker(
                    "Arrival Time",
                    selection: $arrivalTime,
                    displayedComponents: .hourAndMinute
                )
                
                Stepper("Boxes: \(boxes)", value: $boxes, in: 0...1000)
                Stepper("Rollies: \(rollies)", value: $rollies, in: 0...1000)
            }
        }
        .formStyle(.grouped)
        .frame(minWidth: 300, minHeight: 200)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    Task { await addTruck() }
                }
                .disabled(distributionCenter.isEmpty || isLoading)
            }
        }
        .disabled(isLoading)
        .overlay {
            if isLoading {
                LoadingView()
            }
        }
    }
    
    private func addTruck() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await viewModel.createTruck(
                distributionCenter: distributionCenter,
                arrivalTime: arrivalTime,
                boxes: boxes,
                rollies: rollies
            )
            dismiss()
        } catch {
            errorHandler.handle(error)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let group = PreviewData.createPreviewClientGroup(in: context)
    let weekOversight = (group.weekOversights?.allObjects as? [WeekOversightEntity])?.first ?? WeekOversightEntity(context: context)
    let dayOversight = (weekOversight.dayOversights?.allObjects as? [DayOversightEntity])?.first ?? DayOversightEntity(context: context)
    let viewModel = DayOversightViewModel(context: context, dayOversight: dayOversight)
    
    return AddTruckView(viewModel: viewModel)
        .withPreviewEnvironment()
} 