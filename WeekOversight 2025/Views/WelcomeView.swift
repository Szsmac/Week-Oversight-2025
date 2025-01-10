import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 12) {
                    Text("Week Oversight")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                    Text("2025")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)
                
                // Quick Actions Section
                VStack(alignment: .leading, spacing: 20) {
                    SectionHeader(
                        title: "Quick Actions",
                        systemImage: "bolt.fill"
                    )
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        Button {
                            withAnimation(AppAnimation.standard) {
                                navigationManager.navigate(to: .clientManagement)
                            }
                        } label: {
                            VStack(spacing: 12) {
                                Image(systemName: "person.2.fill")
                                    .font(.title)
                                    .symbolEffect(.bounce)
                                Text("Client Management")
                                    .font(.callout)
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .contentTransition(.opacity)
                        
                        QuickActionButton(
                            title: "New Week",
                            systemImage: "calendar.badge.plus",
                            action: showCreateOversight
                        )
                        
                        QuickActionButton(
                            title: "Import Excel",
                            systemImage: "doc.badge.plus",
                            action: showImportExcel
                        )
                    }
                }
                .padding()
                
                // Recent Items Section
                VStack(alignment: .leading, spacing: 20) {
                    SectionHeader(
                        title: "Recent Oversights",
                        systemImage: "clock.fill"
                    )
                    
                    recentOversightsView
                }
                .padding()
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Welcome")
    }
    
    private var recentOversightsView: some View {
        Group {
            if let recentGroup = clientManager.clientGroups.first,
               let recentOversight = recentGroup.weekOversights.first {
                Button {
                    navigateToWeekOversight(recentOversight)
                } label: {
                    WeekOversightCard(oversight: recentOversight)
                        .contentTransition(.opacity)
                }
                .buttonStyle(.plain)
            } else {
                ContentUnavailableView(
                    "No Recent Oversights",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text("Create a new week oversight to get started")
                )
            }
        }
    }
    
    // MARK: - Navigation Actions
    
    private func navigateToClientManagement() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
            navigationManager.navigate(to: .clientManagement)
        }
    }
    
    private func showCreateOversight() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
            if clientManager.clientGroups.isEmpty {
                errorHandler.handle(WelcomeError.noClientGroups)
            } else {
                navigationManager.showSheet(.createOversight())
            }
        }
    }
    
    private func showImportExcel() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
            if clientManager.clientGroups.isEmpty {
                errorHandler.handle(WelcomeError.noClientGroups)
            } else if let group = clientManager.clientGroups.first {
                navigationManager.showSheet(.importExcel(group))
            }
        }
    }
    
    private func navigateToWeekOversight(_ entity: WeekOversightEntity) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
            navigationManager.navigate(to: .weekOversight(entity))
        }
    }
}

// MARK: - Errors
private enum WelcomeError: LocalizedError {
    case noClientGroups
    
    var errorDescription: String? {
        switch self {
        case .noClientGroups:
            "Please create a client group first before creating a week oversight"
        }
    }
}

#Preview {
    let appState = AppState.preview
    let context = PersistenceController.preview.container.viewContext
    
    // Create preview data
    let clientGroup = ClientGroupEntity(context: context)
    clientGroup.id = UUID()
    clientGroup.name = "Preview Group"
    clientGroup.weekOversights = NSSet()
    
    let weekOversight = WeekOversightEntity(context: context)
    weekOversight.id = UUID()
    weekOversight.weekNumber = 1
    weekOversight.clientGroup = clientGroup
    weekOversight.dayOversights = NSSet()
    
    clientGroup.addToWeekOversights(weekOversight)
    
    let dayOversight = DayOversightEntity(context: context)
    dayOversight.id = UUID()
    dayOversight.date = Date()
    dayOversight.weekOversight = weekOversight
    dayOversight.trucks = NSSet()
    
    weekOversight.addToDayOversights(dayOversight)
    
    let truck = TruckEntity(context: context)
    truck.id = UUID()
    truck.arrivalTime = Date()
    truck.boxes = 100
    truck.rollies = 50
    truck.distributionCenter = "Center A"
    truck.dayOversight = dayOversight
    
    dayOversight.addToTrucks(truck)
    
    try? context.save()
    
    return WelcomeView()
        .environmentObject(appState.navigationManager)
        .environmentObject(appState.clientManager)
        .environmentObject(appState.errorHandler)
        .environmentObject(appState.stateRestorationManager)
        .environment(\.managedObjectContext, context)
} 