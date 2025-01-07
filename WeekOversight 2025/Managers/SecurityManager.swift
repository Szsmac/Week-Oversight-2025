import Foundation

@MainActor
final class SecurityManager {
    static let shared = SecurityManager()
    
    func validateFileAccess(_ urls: [URL]) -> Bool {
        urls.allSatisfy { url in
            url.startAccessingSecurityScopedResource()
        }
    }
    
    func releaseFileAccess(_ urls: [URL]) {
        urls.forEach { url in
            url.stopAccessingSecurityScopedResource()
        }
    }
} 