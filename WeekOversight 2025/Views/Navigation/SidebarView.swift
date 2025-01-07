import SwiftUI

struct SidebarView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    
    var body: some View {
        List {
            Section("Quick Actions") {
                Button {
                    navigationManager.navigate(to: .welcome)
                } label: {
                    Label("Home", systemImage: "house")
                }
                
                Button {
                    navigationManager.navigate(to: .clientManagement)
                } label: {
                    Label("Client Management", systemImage: "person.2")
                }
                
                Button {
                    navigationManager.showSheet(.createOversight)
                } label: {
                    Label("New Week", systemImage: "calendar.badge.plus")
                }
            }
            
            if !clientManager.clientGroups.isEmpty {
                Section("Client Groups") {
                    ForEach(clientManager.clientGroups) { group in
                        Button {
                            navigationManager.navigate(to: .clientGroupDetail(group))
                        } label: {
                            Label(group.name, systemImage: "folder")
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
    }
}

#Preview {
    SidebarView()
        .withPreviewEnvironment()
} 