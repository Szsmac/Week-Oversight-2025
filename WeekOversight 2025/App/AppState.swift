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
    private let migrationManager: DataMigrationManager
    
    init(inMemory: Bool = false) {
        // First, initialize all properties
        let errorHandler = ErrorHandler()
        let navigationManager = NavigationManager()
        let stateRestorationManager = StateRestorationManager()
        let windowManager = WindowManager()
        
        // Create persistence controller based on inMemory flag
        let persistenceController = inMemory ? PersistenceController.preview : PersistenceController.shared
        
        // Then assign them
        self.errorHandler = errorHandler
        self.navigationManager = navigationManager
        self.stateRestorationManager = stateRestorationManager
        self.windowManager = windowManager
        self.clientManager = ClientManager(context: persistenceController.container.viewContext)
        self.migrationManager = DataMigrationManager(context: persistenceController.container.viewContext)
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        clientManager.objectWillChange.sink { [weak self] _ in
            Task { @MainActor in
                self?.objectWillChange.send()
            }
        }
        .store(in: &cancellables)
    }
}

// MARK: - Preview Support
extension AppState {
    static var preview: AppState {
        AppState(inMemory: true)
    }
} 