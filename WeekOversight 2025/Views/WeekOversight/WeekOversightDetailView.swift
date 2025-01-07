import SwiftUI
import UniformTypeIdentifiers

// Add this coordinator class to manage the window lifecycle
@MainActor
final class ImportCoordinator: ObservableObject {
    private var windowController: NSWindowController?
    @Published private(set) var isPresented = false
    
    func present(
        urls: [URL],
        clientManager: ClientManager,
        navigationManager: NavigationManager,
        onComplete: @escaping (WeekOversight) -> Void,
        currentOversight: WeekOversight
    ) {
        guard windowController == nil else { return }
        
        let importView = ImportExcelView(
            urls: urls,
            onComplete: { [weak self] newOversight in
                onComplete(newOversight)
                self?.dismiss()
            },
            currentOversight: currentOversight
        )
        .environmentObject(clientManager)
        .environmentObject(navigationManager)
        
        let hostingView = NSHostingView(rootView: importView)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        window.contentView = hostingView
        window.title = "Import Excel"
        window.center()
        
        let windowController = NSWindowController(window: window)
        self.windowController = windowController
        self.isPresented = true
        
        windowController.showWindow(nil)
    }
    
    func dismiss() {
        windowController?.close()
        windowController = nil
        isPresented = false
    }
}

struct WeekOversightDetailView: View {
    let weekOversight: WeekOversight
    
    var body: some View {
        WeekOversightView(oversight: weekOversight)
    }
}

#Preview {
    NavigationStack {
        WeekOversightDetailView(weekOversight: WeekOversight.preview)
    }
    .withPreviewEnvironment()
} 