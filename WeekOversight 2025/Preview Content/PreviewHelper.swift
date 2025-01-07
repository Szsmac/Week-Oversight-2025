import SwiftUI

@MainActor
final class PreviewState: ObservableObject {
    static let shared = PreviewState()
    
    let errorHandler: ErrorHandler
    let navigationManager: NavigationManager
    let stateRestorationManager: StateRestorationManager
    let clientManager: ClientManager
    let appState: AppState
    
    private init() {
        errorHandler = ErrorHandler()
        navigationManager = NavigationManager()
        stateRestorationManager = StateRestorationManager()
        let persistenceManager = PersistenceManager()
        appState = AppState()
        
        clientManager = ClientManager(
            persistenceManager: persistenceManager,
            stateRestorationManager: stateRestorationManager,
            navigationManager: navigationManager,
            errorHandler: errorHandler
        )
    }
    
    func setupPreviewData() async {
        let clientGroup = PreviewData.clientGroup
        try? await clientManager.addClientGroup(clientGroup)
    }
}

#if DEBUG
extension DayOversight {
    static var preview: DayOversight {
        let weekOversightId = UUID()
        let clientGroupId = UUID()
        
        return DayOversight(
            id: UUID(),
            date: Date(),
            trucks: [
                TruckData(
                    id: UUID(),
                    distributionCenter: "DC1",
                    arrival: Date(),
                    boxes: 100,
                    rollies: 10
                ),
                TruckData(
                    id: UUID(),
                    distributionCenter: "DC2",
                    arrival: Date().addingTimeInterval(3600),
                    boxes: 150,
                    rollies: 15
                )
            ],
            clientGroupId: clientGroupId,
            weekOversightId: weekOversightId
        )
    }
}

extension WeekOversight {
    static var preview: WeekOversight {
        WeekOversight(
            id: UUID(),
            weekNumber: 1,
            clientGroupId: UUID(),
            dayOversights: [
                DayOversight(
                    id: UUID(),
                    date: Date(),
                    trucks: [],
                    clientGroupId: UUID(),
                    weekOversightId: UUID()
                )
            ]
        )
    }
}

extension ClientGroup {
    static var preview: ClientGroup {
        ClientGroup(
            id: UUID(),
            name: "Preview Group",
            weekOversights: []
        )
    }
}

extension TruckData {
    static var preview: TruckData {
        TruckData(
            id: UUID(),
            distributionCenter: "DC1",
            arrival: Date(),
            boxes: 100,
            rollies: 10
        )
    }
    
    static var previewList: [TruckData] {
        [
            TruckData(
                id: UUID(),
                distributionCenter: "DC1",
                arrival: Date(),
                boxes: 100,
                rollies: 10
            ),
            TruckData(
                id: UUID(),
                distributionCenter: "DC2",
                arrival: Date().addingTimeInterval(3600),
                boxes: 150,
                rollies: 15
            )
        ]
    }
}

extension AlertItem {
    static var preview: AlertItem {
        AlertItem(
            title: "Preview Alert",
            message: "This is a preview alert message",
            dismissButton: AlertItem.AlertButton(title: "OK", action: {})
        )
    }
}
#endif

struct PreviewData {
    static let weekOversight = WeekOversight(
        id: UUID(),
        weekNumber: 1,
        clientGroupId: UUID(),
        dayOversights: []
    )
    
    static let clientGroup = ClientGroup(name: "Test Group")
    
    static func setupPreviewState() async {
        await PreviewState.shared.setupPreviewData()
    }
}

struct PreviewContainer: ViewModifier {
    @StateObject private var state = PreviewState.shared
    
    func body(content: Content) -> some View {
        NavigationContainer {
            content
                .environmentObject(state.appState)
                .environmentObject(state.errorHandler)
                .environmentObject(state.navigationManager)
                .environmentObject(state.stateRestorationManager)
                .environmentObject(state.clientManager)
        }
        .environmentObject(PreviewState.shared.navigationManager)
        .environmentObject(PreviewState.shared.clientManager)
        .environmentObject(PreviewState.shared.errorHandler)
    }
}

extension View {
    func withPreviewEnvironment() -> some View {
        modifier(PreviewContainer())
    }
} 