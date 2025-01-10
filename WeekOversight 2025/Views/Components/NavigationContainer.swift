import SwiftUI

struct NavigationContainer: View {
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var clientManager = ClientManager(context: PersistenceController.shared.container.viewContext)
    @StateObject private var errorHandler = ErrorHandler()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            WelcomeView()
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .clientManagement:
                        ClientManagementView()
                    case .clientGroup(let group):
                        ClientGroupDetailView(clientGroup: group, context: group.managedObjectContext!)
                    case .weekOversight(let oversight):
                        WeekOversightView(weekOversight: oversight)
                    case .dayOversight(let oversight):
                        DayOversightView(dayOversight: oversight, context: oversight.managedObjectContext!)
                    }
                }
                .sheet(isPresented: $navigationManager.isShowingSheet) {
                    if let sheet = navigationManager.activeSheet {
                        sheetContent(for: sheet)
                    }
                }
        }
        .environmentObject(navigationManager)
        .environmentObject(clientManager)
        .environmentObject(errorHandler)
    }
    
    @ViewBuilder
    private func sheetContent(for sheet: NavigationManager.Sheet) -> some View {
        switch sheet {
        case .createOversight(let group):
            CreateOversightSheet(group: group)
        case .importExcel(let group):
            ImportExcelView(viewModel: ClientGroupViewModel(context: group.managedObjectContext!, clientGroup: group))
        case .addDay(let weekOversight):
            AddDayView(viewModel: DayOversightEditorViewModel(context: weekOversight.managedObjectContext!, weekOversight: weekOversight))
        case .addTruck(let dayOversight):
            AddTruckView(viewModel: DayOversightViewModel(context: dayOversight.managedObjectContext!, dayOversight: dayOversight))
        }
    }
}

#Preview {
    NavigationContainer()
    .withPreviewEnvironment()
} 

