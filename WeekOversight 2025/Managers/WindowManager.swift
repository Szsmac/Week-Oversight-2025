import SwiftUI

@MainActor
final class WindowManager: ObservableObject {
    @Published private(set) var windows: [UUID: NSWindow] = [:]
    private let stateRestorationManager: StateRestorationManager
    
    init(stateRestorationManager: StateRestorationManager) {
        self.stateRestorationManager = stateRestorationManager
    }
    
    func register(_ window: NSWindow, id: UUID) {
        windows[id] = window
        
        // Restore window state if available
        if let frame = stateRestorationManager.windowFrame(for: id) {
            window.setFrame(frame, display: true)
        }
        
        // Save window state on changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidMove),
            name: NSWindow.didMoveNotification,
            object: window
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidResize),
            name: NSWindow.didResizeNotification,
            object: window
        )
    }
    
    func unregister(_ id: UUID) {
        if let window = windows[id] {
            NotificationCenter.default.removeObserver(
                self,
                name: NSWindow.didMoveNotification,
                object: window
            )
            NotificationCenter.default.removeObserver(
                self,
                name: NSWindow.didResizeNotification,
                object: window
            )
        }
        windows.removeValue(forKey: id)
    }
    
    @objc private func windowDidMove(_ notification: Notification) {
        guard let window = notification.object as? NSWindow,
              let id = windows.first(where: { $0.value == window })?.key else {
            return
        }
        stateRestorationManager.saveWindowFrame(window.frame, for: id)
    }
    
    @objc private func windowDidResize(_ notification: Notification) {
        guard let window = notification.object as? NSWindow,
              let id = windows.first(where: { $0.value == window })?.key else {
            return
        }
        stateRestorationManager.saveWindowFrame(window.frame, for: id)
    }
} 