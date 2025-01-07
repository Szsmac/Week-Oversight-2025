import SwiftUI

struct ClientGroupView: View {
    let group: ClientGroup
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    
    var body: some View {
        VStack(spacing: 0) {
            // ... header code ...
            
            if group.weekOversights.isEmpty {
                EmptyStateView(
                    icon: "calendar",
                    message: "No oversights yet"
                )
            } else {
                List(group.weekOversights.sorted(by: { $0.date > $1.date })) { oversight in
                    Button {
                        navigationManager.navigate(to: .weekOversight(oversight))
                    } label: {
                        WeekOversightRow(oversight: oversight)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: { navigationManager.goBack() }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }
} 