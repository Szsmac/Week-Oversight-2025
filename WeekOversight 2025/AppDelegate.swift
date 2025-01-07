import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let aquaAppearance = NSAppearance(named: .aqua) {
            NSApp.appearance = aquaAppearance
        }
    }
} 