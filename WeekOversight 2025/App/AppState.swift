import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    let errorHandler: ErrorHandler
    @Published var navigationManager: NavigationManager
    let stateRestorationManager: StateRestorationManager
    let windowManager: WindowManager
    @Published var clientManager: ClientManager
    
    init() {
        // First, initialize all properties
        let errorHandler = ErrorHandler()
        let navigationManager = NavigationManager()
        let stateRestorationManager = StateRestorationManager()
        let windowManager = WindowManager(stateRestorationManager: stateRestorationManager)
        let persistenceManager = PersistenceManager()
        
        // Then assign them to self
        self.errorHandler = errorHandler
        self.navigationManager = navigationManager
        self.stateRestorationManager = stateRestorationManager
        self.windowManager = windowManager
        
        // Finally create the client manager after all other properties are initialized
        let clientManager = ClientManager(
            persistenceManager: persistenceManager,
            stateRestorationManager: stateRestorationManager,
            navigationManager: navigationManager,
            errorHandler: errorHandler
        )
        self.clientManager = clientManager
        
        // Add observers for state changes
        clientManager.objectWillChange.sink { [weak self] _ in
            Task { @MainActor in
                self?.objectWillChange.send()
            }
        }
        .store(in: &cancellables)
        
        navigationManager.objectWillChange.sink { [weak self] _ in
            Task { @MainActor in
                self?.objectWillChange.send()
            }
        }
        .store(in: &cancellables)
    }
} 