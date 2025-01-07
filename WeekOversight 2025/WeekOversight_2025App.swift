//
//  WeekOversight_2025App.swift
//  WeekOversight 2025
//
//  Created by Sebastian  Verde  on 19/12/2024.
//

import SwiftUI
import Combine

@main
struct WeekOversight_2025App: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView()
                    .withAppEnvironment(appState)
            } detail: {
                NavigationContainer {
                    WelcomeView()
                }
                .withAppEnvironment(appState)
            }
            .preferredColorScheme(.light)
        }
    }
}

extension View {
    func withAppEnvironment(_ appState: AppState) -> some View {
        self
            .environmentObject(appState.errorHandler)
            .environmentObject(appState.navigationManager)
            .environmentObject(appState.stateRestorationManager)
            .environmentObject(appState.clientManager)
            .environmentObject(appState.windowManager)
    }
}

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
