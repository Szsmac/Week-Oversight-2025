import SwiftUI

struct ClientGroupDetailView: View {
    let group: ClientGroup
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(group.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(group.weekOversights.count) oversights")
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    navigationManager.showSheet(.createClientOversight(group))
                } label: {
                    Label("New Week", systemImage: "plus")
                }
                .buttonStyle(.hessing)
            }
            .padding()
            
            // Content
            if group.weekOversights.isEmpty {
                EmptyStateView(
                    icon: "calendar",
                    message: "No oversights yet"
                )
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 300, maximum: 400))],
                        spacing: 20
                    ) {
                        ForEach(group.weekOversights.sorted(by: { $0.date > $1.date })) { oversight in
                            Button {
                                navigationManager.navigate(to: .weekOversight(oversight))
                            } label: {
                                WeekOversightCard(oversight: oversight)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .destructive) {
                                    Task {
                                        await deleteOversight(oversight)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: { navigationManager.goBack() }) {
                    Image(systemName: "chevron.left")
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(role: .destructive) {
                    navigationManager.showSheet(.deleteClientGroup(group))
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .animation(.spring(), value: group.weekOversights)
    }
    
    private func deleteOversight(_ oversight: WeekOversight) async {
        do {
            var updatedGroup = group
            updatedGroup.weekOversights.removeAll { $0.id == oversight.id }
            try await clientManager.updateClientGroup(updatedGroup)
        } catch {
            errorHandler.handle(error)
        }
    }
}

#Preview {
    ClientGroupDetailView(group: ClientGroup(name: "Test Group"))
        .withPreviewEnvironment()
} 