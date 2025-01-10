import Foundation
import SwiftUI

enum NavigationRoute: Hashable, Codable {
    case welcome
    case clientManagement
    case clientGroupDetail(ClientGroup)
    case weekOversight(WeekOversight)
    case dayOversight(DayOversight)
}

enum SheetType: Identifiable, Equatable {
    case addClient
    case createOversight
    case createClientOversight(ClientGroup)
    case deleteClientGroup(ClientGroup)
    case importExcel
    
    var id: String {
        switch self {
        case .addClient: return "addClient"
        case .createOversight: return "createOversight"
        case .createClientOversight: return "createClientOversight"
        case .deleteClientGroup: return "deleteClientGroup"
        case .importExcel: return "importExcel"
        }
    }
    
    static func == (lhs: SheetType, rhs: SheetType) -> Bool {
        switch (lhs, rhs) {
        case (.addClient, .addClient),
             (.createOversight, .createOversight),
             (.importExcel, .importExcel):
            return true
        case let (.createClientOversight(lhsGroup), .createClientOversight(rhsGroup)):
            return lhsGroup == rhsGroup
        case let (.deleteClientGroup(lhsGroup), .deleteClientGroup(rhsGroup)):
            return lhsGroup == rhsGroup
        default:
            return false
        }
    }
}

@MainActor
final class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    @Published var activeSheet: Sheet?
    @Published var isShowingSheet = false
    
    enum Sheet: Identifiable {
        case createOversight(ClientGroupEntity? = nil)
        case importExcel(ClientGroupEntity)
        case addDay(WeekOversightEntity)
        case addTruck(DayOversightEntity)
        
        var id: String {
            switch self {
            case .createOversight: return "createOversight"
            case .importExcel: return "importExcel"
            case .addDay: return "addDay"
            case .addTruck: return "addTruck"
            }
        }
    }
    
    var currentDestination: NavigationDestination? {
        path.count > 0 ? path.last as? NavigationDestination : nil
    }
    
    func showSheet(_ sheet: Sheet) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
            activeSheet = sheet
            isShowingSheet = true
        }
    }
    
    func dismissSheet() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
            isShowingSheet = false
            activeSheet = nil
        }
    }
    
    func navigate(to destination: NavigationDestination) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
            path.append(destination)
        }
    }
    
    func goBack() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
            path.removeLast()
        }
    }
    
    func goToRoot() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
            path.removeLast(path.count)
        }
    }
} 