import SwiftUI

struct AppNavigationView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var windowManager: WindowManager
    
    var body: some View {
        NavigationContainer {
            switch navigationManager.currentRoute {
            case .clientGroupDetail(let group):
                ClientGroupDetailView(clientGroup: group.toEntity(in: context) ?? ClientGroupEntity(context: context), context: context)
            case .clientManagement:
                ClientManagementView()
            case .dayOversight(let dayOversight):
                DayOversightView(dayOversight: dayOversight.toEntity(in: context) ?? DayOversightEntity(context: context), context: context)
            case .weekOversight(let weekOversight):
                WeekOversightView(weekOversight: weekOversight.toEntity(in: context) ?? WeekOversightEntity(context: context))
            case .welcome, .none:
                WelcomeView()
            }
        }
        .frame(
            minWidth: windowManager.minWidth,
            maxWidth: .infinity,
            minHeight: windowManager.minHeight,
            maxHeight: .infinity
        )
    }
}

#Preview {
    AppNavigationView()
        .withPreviewEnvironment()
} 