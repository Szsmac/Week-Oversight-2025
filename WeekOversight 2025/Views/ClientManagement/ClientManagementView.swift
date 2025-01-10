import SwiftUI

struct ClientManagementView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: ClientGroupViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    init() {
        _viewModel = StateObject(wrappedValue: ClientGroupViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        List {
            ForEach(viewModel.groups) { group in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
                        navigationManager.navigate(to: .clientGroup(group))
                    }
                } label: {
                    HStack {
                        Text(group.name ?? "Unnamed Group")
                        Spacer()
                        Text("\(group.weekOversights?.count ?? 0) weeks")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Clients")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
                        if let group = viewModel.groups.first {
                            navigationManager.showSheet(.createOversight(group))
                        } else {
                            navigationManager.showSheet(.createOversight(nil))
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ClientManagementView()
    }
    .withPreviewEnvironment()
} 