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
                    Button {
                        navigationManager.navigate(to: .clientManagement)
                    } label: {
                        QuickActionButton(
                            title: "Client Management",
                            systemImage: "person.2"
                        )
                    }
                    .buttonStyle(.hessing)
                    
                    Button {
                        navigationManager.showSheet(.createOversight)
                    } label: {
                        QuickActionButton(
                            title: "Create Oversight",
                            systemImage: "doc.badge.plus"
                        )
                    }
                    .buttonStyle(.hessing)
                    
                    Button {
                        navigationManager.showSheet(.importExcel)
                    } label: {
                        QuickActionButton(
                            title: "Import Excel",
                            systemImage: "doc.badge.plus"
                        )
                    }
                    .buttonStyle(.hessing)
                }
            }
            
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
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.largeTitle)
            Text(title)
                .font(.headline)
        }
        .frame(width: 150, height: 120)
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