import SwiftUI

struct PreviewContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            content
                .environmentObject(NavigationManager())
                .environmentObject(ErrorHandler())
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
} 