import SwiftUI

struct AppNavigationView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var windowManager: WindowManager
    
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            NavigationContainer {
                mainContent
            }
        }
        .frame(
            minWidth: windowManager.minWidth,
            maxWidth: .infinity,
            minHeight: windowManager.minHeight,
            maxHeight: .infinity
        )
    }
    
    @ViewBuilder
    private var mainContent: some View {
        Group {
            switch navigationManager.currentRoute {
            case .welcome, .none:
                WelcomeView()
                    .transition(AppAnimation.fadeTransition)
            case .clientManagement:
                ClientManagementView()
                    .transition(AppAnimation.transition)
            case .clientGroupDetail(let group):
                ClientGroupDetailView(group: group)
                    .transition(AppAnimation.transition)
            case .weekOversight(let oversight):
                WeekOversightView(oversight: oversight)
                    .transition(AppAnimation.transition)
            case .dayOversight(let oversight):
                DayOversightView(dayOversight: oversight)
                    .transition(AppAnimation.transition)
            }
        }
        .animation(AppAnimation.standard, value: navigationManager.currentRoute)
    }
} 