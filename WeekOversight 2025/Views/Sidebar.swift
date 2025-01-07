import SwiftUI

struct Sidebar: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var body: some View {
        List {
            NavigationLink(value: NavigationDestination.clientManagement) {
                Label("Client Management", systemImage: "person.2")
            }
            
            Section("Recent Oversights") {
                // Add your recent oversights here
            }
        }
    }
} 