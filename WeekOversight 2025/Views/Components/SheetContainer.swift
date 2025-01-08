import SwiftUI

struct SheetContainer<Content: View>: View {
    let title: String
    let content: Content
    @EnvironmentObject private var navigationManager: NavigationManager
    
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            withAnimation(AppAnimation.standard) {
                                navigationManager.dismissSheet()
                            }
                        }
                    }
                }
        }
        .transition(AppAnimation.sheetTransition)
    }
} 