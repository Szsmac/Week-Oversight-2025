import SwiftUI

struct CreateOversightSheet: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    
    let group: ClientGroup?
    let onComplete: (WeekOversight) -> Void
    
    init(group: ClientGroup? = nil, onComplete: @escaping (WeekOversight) -> Void) {
        self.group = group
        self.onComplete = onComplete
    }
    
    @State private var selectedGroup: ClientGroup?
    @State private var weekNumber = 1
    @State private var isCreating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Week Oversight")
                .font(.title2)
                .fontWeight(.bold)
            
            if group == nil {
                // Show picker only when no group is pre-selected
                Picker("Client", selection: $selectedGroup) {
                    Text("Select Client").tag(nil as ClientGroup?)
                    ForEach(clientManager.clientGroups) { group in
                        Text(group.name).tag(Optional(group))
                    }
                }
            }
            
            Stepper("Week \(weekNumber)", value: $weekNumber, in: 1...53)
            
            HStack {
                Button("Cancel") {
                    navigationManager.dismissSheet()
                }
                .keyboardShortcut(.escape)
                
                Button("Create") {
                    createOversight()
                }
                .keyboardShortcut(.return)
                .buttonStyle(.hessing)
                .disabled((selectedGroup == nil && group == nil) || isCreating)
            }
        }
        .padding()
        .frame(width: 300)
        .onAppear {
            // Use pre-selected group if provided
            selectedGroup = group
        }
    }
    
    private func createOversight() {
        guard let selectedGroup = group ?? selectedGroup else { return }
        
        isCreating = true
        let oversight = WeekOversight(
            id: UUID(),
            weekNumber: weekNumber,
            clientGroupId: selectedGroup.id,
            dayOversights: []
        )
        
        Task {
            do {
                try await clientManager.updateWeekOversight(oversight)
                onComplete(oversight)
                navigationManager.dismissSheet()
            } catch {
                errorHandler.handle(error)
            }
            isCreating = false
        }
    }
} 