import SwiftUI

struct AddClientSheet: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    @State private var name = ""
    @State private var isAdding = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add Client")
                .font(.title2)
                .fontWeight(.bold)
            
            TextField("Client Name", text: $name)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Button("Cancel") {
                    navigationManager.dismissSheet()
                }
                .keyboardShortcut(.escape)
                
                Button("Add") {
                    addClient()
                }
                .keyboardShortcut(.return)
                .buttonStyle(.hessing)
                .disabled(name.isEmpty || isAdding)
            }
        }
        .padding()
        .frame(width: 300)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private func addClient() {
        isAdding = true
        Task {
            do {
                try await clientManager.addClientGroup(ClientGroup(name: name))
                navigationManager.dismissSheet()
            } catch {
                errorHandler.handle(error)
            }
            isAdding = false
        }
    }
}

#Preview {
    AddClientSheet()
        .withPreviewEnvironment()
} 