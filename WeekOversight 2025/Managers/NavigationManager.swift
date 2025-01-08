import SwiftUI
import Combine

enum NavigationRoute: Hashable, Equatable {
    case welcome
    case clientManagement
    case clientGroupDetail(ClientGroup)
    case weekOversight(WeekOversight)
    case dayOversight(DayOversight)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .welcome:
            hasher.combine(0)
        case .clientManagement:
            hasher.combine(1)
        case .clientGroupDetail(let group):
            hasher.combine(2)
            hasher.combine(group.id)
        case .weekOversight(let oversight):
            hasher.combine(3)
            hasher.combine(oversight.id)
        case .dayOversight(let oversight):
            hasher.combine(4)
            hasher.combine(oversight.id)
        }
    }
    
    static func == (lhs: NavigationRoute, rhs: NavigationRoute) -> Bool {
        switch (lhs, rhs) {
        case (.welcome, .welcome):
            return true
        case (.clientManagement, .clientManagement):
            return true
        case let (.clientGroupDetail(lhsGroup), .clientGroupDetail(rhsGroup)):
            return lhsGroup.id == rhsGroup.id
        case let (.weekOversight(lhsOversight), .weekOversight(rhsOversight)):
            return lhsOversight.id == rhsOversight.id
        case let (.dayOversight(lhsOversight), .dayOversight(rhsOversight)):
            return lhsOversight.id == rhsOversight.id
        default:
            return false
        }
    }
}

@MainActor
final class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: SheetType?
    @Published var currentRoute: NavigationRoute?
    
    func navigate(to route: NavigationRoute) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            currentRoute = route
            switch route {
            case .welcome:
                path.removeLast(path.count)
            case .clientManagement, .clientGroupDetail, .weekOversight, .dayOversight:
                path.append(route)
            }
        }
    }
    
    func showSheet(_ type: SheetType) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            sheet = type
        }
    }
    
    func dismissSheet() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            sheet = nil
        }
    }
    
    func goBack() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            if !path.isEmpty {
                path.removeLast()
            }
        }
    }
}

enum SheetType: Identifiable {
    case addClient
    case createOversight
    case createClientOversight(ClientGroup)
    case deleteClientGroup(ClientGroup)
    case importExcel
    
    var id: String {
        switch self {
        case .addClient: return "addClient"
        case .createOversight: return "createOversight"
        case .createClientOversight(let group): return "createClientOversight-\(group.id)"
        case .deleteClientGroup(let group): return "deleteClientGroup-\(group.id)"
        case .importExcel: return "importExcel"
        }
    }
} 