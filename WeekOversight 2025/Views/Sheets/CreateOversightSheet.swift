import SwiftUI

struct CreateOversightSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    
    let group: ClientGroupEntity?
    
    init(group: ClientGroupEntity? = nil) {
        self.group = group
    }
    
    @State private var selectedGroup: ClientGroupEntity?
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
                    Text("Select Client").tag(nil as ClientGroupEntity?)
                    ForEach(clientManager.clientGroups) { group in
                        Text(group.name ?? "Unnamed Group").tag(Optional(group))
                    }
                }
            }
            
            Stepper("Week \(weekNumber)", value: $weekNumber, in: 1...53)
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.escape)
                
                Button("Create") {
                    createOversight()
                }
                .keyboardShortcut(.return)
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
        
        Task {
            do {
                let context = selectedGroup.managedObjectContext!
                let entity = WeekOversightEntity(context: context)
                entity.id = UUID()
                entity.weekNumber = Int32(weekNumber)
                entity.clientGroup = selectedGroup
                
                // Create day oversights for the week
                let calendar = Calendar.current
                let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
                
                for dayOffset in 0..<7 {
                    let dayEntity = DayOversightEntity(context: context)
                    dayEntity.id = UUID()
                    dayEntity.date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
                    dayEntity.weekOversight = entity
                }
                
                try context.save()
                dismiss()
            } catch {
                errorHandler.handle(error)
            }
            isCreating = false
        }
    }
} 