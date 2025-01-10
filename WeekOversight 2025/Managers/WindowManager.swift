import SwiftUI

@MainActor
class WindowManager: ObservableObject {
    @Published var minWidth: CGFloat = 800
    @Published var minHeight: CGFloat = 600
    @Published var defaultWidth: CGFloat = 1024
    @Published var defaultHeight: CGFloat = 768
    
    func setMinimumSize(width: CGFloat, height: CGFloat) {
        minWidth = width
        minHeight = height
    }
    
    func setDefaultSize(width: CGFloat, height: CGFloat) {
        defaultWidth = width
        defaultHeight = height
    }
}

enum WindowIdentifier: String {
    case main
    case settings
    case about
} 