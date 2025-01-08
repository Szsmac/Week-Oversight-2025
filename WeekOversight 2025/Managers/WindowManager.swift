import SwiftUI

class WindowManager: ObservableObject {
    @Published var minWidth: CGFloat = 800
    @Published var minHeight: CGFloat = 600
    
    private let stateRestorationManager: StateRestorationManager
    
    init(stateRestorationManager: StateRestorationManager) {
        self.stateRestorationManager = stateRestorationManager
    }
} 