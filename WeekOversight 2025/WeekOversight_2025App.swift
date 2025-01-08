//
//  WeekOversight_2025App.swift
//  WeekOversight 2025
//
//  Created by Sebastian  Verde  on 19/12/2024.
//

import SwiftUI

@main
struct WeekOversight_2025App: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            AppNavigationView()
                .environmentObject(appState.navigationManager)
                .environmentObject(appState.windowManager)
                .environmentObject(appState.clientManager)
                .environmentObject(appState.errorHandler)
                .environmentObject(appState.stateRestorationManager)
                .preferredColorScheme(.light)
        }
    }
}
