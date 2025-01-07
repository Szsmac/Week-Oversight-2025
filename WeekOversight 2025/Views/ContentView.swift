import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        WelcomeView()
    }
}

#Preview {
    ContentView()
        .withPreviewEnvironment()
} 
