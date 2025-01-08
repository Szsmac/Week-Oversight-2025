import SwiftUI

@MainActor
class PreviewState: ObservableObject {
    @Published var appState: AppState
    
    init() {
        self.appState = AppState()
    }
}

extension View {
    func withPreviewEnvironment() -> some View {
        let state = PreviewState()
        return self
            .environmentObject(state.appState.navigationManager)
            .environmentObject(state.appState.windowManager)
            .environmentObject(state.appState.clientManager)
            .environmentObject(state.appState.errorHandler)
            .environmentObject(state.appState.stateRestorationManager)
    }
} 