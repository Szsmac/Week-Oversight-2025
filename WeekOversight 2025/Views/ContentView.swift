import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    @Environment(\.managedObjectContext) private var context
    
    var body: some View {
        AppNavigationView()
            .environmentObject(appState.navigationManager)
            .environmentObject(appState.windowManager)
            .environmentObject(appState.clientManager)
            .environmentObject(appState.errorHandler)
            .environmentObject(appState.stateRestorationManager)
            .environment(\.managedObjectContext, context)
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 
