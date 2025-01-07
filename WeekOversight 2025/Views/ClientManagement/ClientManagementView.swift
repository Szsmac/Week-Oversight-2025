import SwiftUI

struct ClientManagementView: View {
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Client Management")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    navigationManager.showSheet(.addClient)
                } label: {
                    Label("Add Client", systemImage: "plus")
                }
                .buttonStyle(.hessing)
            }
            .padding()
            
            if clientManager.clientGroups.isEmpty {
                EmptyStateView(
                    icon: "folder",
                    message: "No clients yet"
                )
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 250, maximum: 300))],
                        spacing: 20
                    ) {
                        ForEach(clientManager.clientGroups) { group in
                            Button {
                                navigationManager.navigate(to: .clientGroupDetail(group))
                            } label: {
                                ClientFolderView(group: group)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
        }
        .animation(.spring(), value: clientManager.clientGroups)
    }
}

struct ClientFolderView: View {
    let group: ClientGroup
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "folder.fill")
                    .font(.title)
                    .foregroundStyle(.blue)
                
                Text(group.name)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            
            Text("\(group.weekOversights.count) oversights")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
        )
    }
}

#Preview {
    ClientManagementView()
        .withPreviewEnvironment()
} 