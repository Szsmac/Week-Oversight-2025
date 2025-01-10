import Foundation
import SwiftUI

@MainActor
class ErrorHandler: ObservableObject {
    @Published var error: Error?
    @Published var hasError = false
    
    func handle(_ error: Error) {
        self.error = error
        self.hasError = true
    }
    
    func dismiss() {
        self.error = nil
        self.hasError = false
    }
}

struct ErrorAlert: ViewModifier {
    @EnvironmentObject private var errorHandler: ErrorHandler
    
    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $errorHandler.hasError) {
                Button("OK") {
                    errorHandler.dismiss()
                }
            } message: {
                if let error = errorHandler.error {
                    Text(error.localizedDescription)
                }
            }
    }
}

extension View {
    func handleErrors() -> some View {
        modifier(ErrorAlert())
    }
} 