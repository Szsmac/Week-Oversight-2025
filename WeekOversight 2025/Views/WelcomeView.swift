import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 10) {
                Text("Week Oversight")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("2025")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            
            // Quick Actions
            VStack(alignment: .leading, spacing: 20) {
                Text("Quick Actions")
                    .font(.headline)
                
                HStack(spacing: 20) {
                    QuickActionButton(
                        title: "Client Management",
                        systemImage: "person.2",
                        action: { navigationManager.navigate(to: .clientManagement) }
                    )
                    
                    QuickActionButton(
                        title: "Import Excel",
                        systemImage: "doc.badge.plus",
                        action: { navigationManager.showSheet(.importExcel) }
                    )
                    
                    QuickActionButton(
                        title: "New Week",
                        systemImage: "calendar.badge.plus",
                        action: { navigationManager.showSheet(.createOversight) }
                    )
                }
            }
            .padding()
            
            // Recent Items
            VStack(alignment: .leading, spacing: 20) {
                Text("Recent Oversights")
                    .font(.headline)
                
                if let recentGroup = clientManager.clientGroups.first,
                   let recentOversight = recentGroup.weekOversights.first {
                    Button {
                        navigationManager.navigate(to: .weekOversight(recentOversight))
                    } label: {
                        WeekOversightCard(oversight: recentOversight)
                    }
                    .buttonStyle(.plain)
                } else {
                    Text("No recent oversights")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.background.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Spacer()
        }
        .padding(30)
    }
}

struct QuickActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.title)
                Text(title)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .transition(.scale.combined(with: .opacity))
    }
}

struct RecentOversightRow: View {
    @EnvironmentObject private var clientManager: ClientManager
    let oversight: WeekOversight
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Week \(oversight.weekNumber)")
                    .font(.headline)
                if let group = clientManager.clientGroups.first(where: { $0.id == oversight.clientGroupId }) {
                    Text(group.name)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Text("\(oversight.totalTrucks) trucks")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    WelcomeView()
        .withPreviewEnvironment()
} 