import SwiftUI

enum NavigationDestination: Hashable {
    case clientManagement
    case clientGroup(ClientGroupEntity)
    case weekOversight(WeekOversightEntity)
    case dayOversight(DayOversightEntity)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .clientManagement:
            hasher.combine("clientManagement")
        case .clientGroup(let group):
            hasher.combine("clientGroup")
            hasher.combine(group.id)
        case .weekOversight(let oversight):
            hasher.combine("weekOversight")
            hasher.combine(oversight.id)
        case .dayOversight(let oversight):
            hasher.combine("dayOversight")
            hasher.combine(oversight.id)
        }
    }
    
    static func == (lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
        switch (lhs, rhs) {
        case (.clientManagement, .clientManagement):
            return true
        case let (.clientGroup(lhs), .clientGroup(rhs)):
            return lhs.id == rhs.id
        case let (.weekOversight(lhs), .weekOversight(rhs)):
            return lhs.id == rhs.id
        case let (.dayOversight(lhs), .dayOversight(rhs)):
            return lhs.id == rhs.id
        default:
            return false
        }
    }
} 