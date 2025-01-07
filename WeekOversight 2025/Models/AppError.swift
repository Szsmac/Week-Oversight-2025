import Foundation

enum AppError: LocalizedError {
    case importFailed(String)
    case saveFailed(String)
    case loadFailed(String)
    case invalidData(String)
    
    var errorDescription: String? {
        switch self {
        case .importFailed(let message): return "Import Failed: \(message)"
        case .saveFailed(let message): return "Save Failed: \(message)"
        case .loadFailed(let message): return "Load Failed: \(message)"
        case .invalidData(let message): return "Invalid Data: \(message)"
        }
    }
}

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: AlertButton
    
    struct AlertButton {
        let title: String
        let action: () -> Void
    }
    
    static func error(_ error: Error) -> AlertItem {
        AlertItem(
            title: "Error",
            message: error.localizedDescription,
            dismissButton: AlertButton(title: "OK", action: {})
        )
    }
} 