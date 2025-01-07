import SwiftUI

@MainActor
final class ErrorHandler: ObservableObject {
    @Published var currentError: Error?
    @Published var showError = false
    
    func handle(_ error: Error) {
        currentError = error
        showError = true
    }
    
    func dismiss() {
        currentError = nil
        showError = false
    }
}

struct ErrorAlert: ViewModifier {
    @EnvironmentObject private var errorHandler: ErrorHandler
    
    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $errorHandler.showError) {
                Button("OK") {
                    errorHandler.dismiss()
                }
            } message: {
                if let error = errorHandler.currentError {
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