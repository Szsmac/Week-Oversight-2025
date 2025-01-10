import SwiftUI

extension View {
    func withPreviewEnvironment() -> some View {
        self
            .environmentObject(NavigationManager())
            .environmentObject(ErrorHandler())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
} 