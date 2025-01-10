import SwiftUI

struct AddClientSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    
    @State private var name = ""
    @State private var isLoading = false
    
    var body: some View {
        Form {
            TextField("Client Name", text: $name)
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
                    Task { await addClient() }
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
    
    private func addClient() async {
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
    AddClientSheet()
        .environmentObject(ClientManager.preview)
        .environmentObject(ErrorHandler())
} 