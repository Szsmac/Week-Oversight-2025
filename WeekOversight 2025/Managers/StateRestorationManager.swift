import Foundation
import SwiftUI

@MainActor
final class StateRestorationManager: ObservableObject {
    private let defaults = UserDefaults.standard
    private let windowFramePrefix = "window_frame_"
    private let userDefaults = UserDefaults.standard
    
    func windowFrame(for id: UUID) -> NSRect? {
        guard let frameData = defaults.data(forKey: windowFramePrefix + id.uuidString),
              let frame = try? JSONDecoder().decode(NSRect.self, from: frameData) else {
            return nil
        }
        return frame
    }
    
    func saveWindowFrame(_ frame: NSRect, for id: UUID) {
        guard let frameData = try? JSONEncoder().encode(frame) else { return }
        defaults.set(frameData, forKey: windowFramePrefix + id.uuidString)
    }
    
    func saveState(clientManager: ClientManager, navigationManager: NavigationManager) async throws {
        // Save selected group ID
        if let selectedGroupId = clientManager.selectedClientGroup?.id {
            userDefaults.set(selectedGroupId.uuidString, forKey: "selectedGroupId")
        } else {
            userDefaults.removeObject(forKey: "selectedGroupId")
        }
        
        // Save navigation path
        if let navigationData = try? JSONEncoder().encode(navigationManager.path) {
            userDefaults.set(navigationData, forKey: "navigationPath")
        } else {
            userDefaults.removeObject(forKey: "navigationPath")
        }
        
        userDefaults.synchronize()
    }
    
    func restoreState(clientManager: ClientManager, navigationManager: NavigationManager) async throws {
        // Restore selected group
        if let selectedGroupIdString = userDefaults.string(forKey: "selectedGroupId"),
           let selectedGroupId = UUID(uuidString: selectedGroupIdString) {
            clientManager.selectedClientGroup = clientManager.clientGroups.first { $0.id == selectedGroupId }
        }
        
        // Restore navigation path
        if let navigationData = userDefaults.data(forKey: "navigationPath"),
           let restoredPath = try? JSONDecoder().decode([NavigationRoute].self, from: navigationData) {
            navigationManager.path = restoredPath
        }
    }
} 