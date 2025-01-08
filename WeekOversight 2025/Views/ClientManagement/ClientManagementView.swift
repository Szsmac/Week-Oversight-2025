import SwiftUI

struct ClientManagementView: View {
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Client Management")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    withAnimation(AppAnimation.standard) {
                        navigationManager.showSheet(.addClient)
                    }
                } label: {
                    Label("Add Client", systemImage: "plus")
                }
                .buttonStyle(.hessing)
            }
            .padding()
            
            if isLoading {
                ProgressView()
                    .frame(maxHeight: .infinity)
                    .transition(AppAnimation.fadeTransition)
            } else if clientManager.clientGroups.isEmpty {
                EmptyStateView(
                    icon: "folder",
                    message: "No clients yet"
                )
                .transition(AppAnimation.fadeTransition)
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 250, maximum: 300))],
                        spacing: 20
                    ) {
                        ForEach(clientManager.clientGroups) { group in
                            ClientFolderView(group: group)
                                .transition(AppAnimation.transition)
                        }
                    }
                    .padding()
                }
            }
        }
        .animation(AppAnimation.standard, value: clientManager.clientGroups)
        .task {
            await loadClients()
        }
    }
    
    private func loadClients() async {
        withAnimation(AppAnimation.standard) {
            isLoading = true
        }
        
        do {
            try await clientManager.loadClientGroups()
        } catch {
            // Error handling
        }
        
        withAnimation(AppAnimation.standard) {
            isLoading = false
        }
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