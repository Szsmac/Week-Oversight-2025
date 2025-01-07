import Foundation

enum MainTab: String, CaseIterable, Identifiable {
    case home
    case clients
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .clients: return "Clients"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .clients: return "folder.fill"
        }
    }
} 