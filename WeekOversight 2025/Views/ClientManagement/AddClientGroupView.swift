import SwiftUI

struct AddClientGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    
    @State private var name = ""
    @State private var isLoading = false
    
    var body: some View {
        Form {
            Section {
                ValidatedTextField(
                    text: $name,
                    title: "Name",
                    placeholder: "Enter client group name",
                    validation: { !$0.isEmpty }
                )
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
                    Task { await addGroup() }
                }
                .disabled(name.isEmpty || isLoading)
            }
        }
        .disabled(isLoading)
        .overlay {
            if isLoading {
                LoadingView()
            }
        }
    }
    
    private func addGroup() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await clientManager.createClientGroup(name: name)
            dismiss()
        } catch {
            errorHandler.handle(error)
        }
    }
}

#Preview {
    AddClientGroupView()
        .withPreviewEnvironment()
} 