import SwiftUI

struct ClientGroupDetail: View {
    let group: ClientGroup
    @EnvironmentObject private var clientManager: ClientManager
    @State private var selectedOversight: WeekOversight?
    
    var body: some View {
        List {
            ForEach(group.weekOversights) { oversight in
                NavigationLink {
                    WeekOversightDetailView(weekOversight: oversight)
                } label: {
                    WeekOversightRow(oversight: oversight)
                }
            }
        }
        .navigationTitle(group.name)
        .toolbar {
            Button("Create New Week Oversight") {
                let newOversight = clientManager.createNewWeekOversight(for: group)
                selectedOversight = newOversight
            }
        }
        .navigationDestination(item: $selectedOversight) { oversight in
            WeekOversightDetailView(weekOversight: oversight)
        }
    }
}

struct WeekOversightRow: View {
    let oversight: WeekOversight
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Week \(oversight.weekNumber)")
                .font(.headline)
            Text("\(oversight.dayOversights.count) days")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct ClientGroupDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            let persistenceManager = PersistenceManager()
            let errorHandler = ErrorHandler()
            let navigationManager = NavigationManager()
            let stateRestorationManager = StateRestorationManager()
            let clientManager = ClientManager(
                persistenceManager: persistenceManager,
                stateRestorationManager: stateRestorationManager,
                navigationManager: navigationManager,
                errorHandler: errorHandler
            )
            
            return ClientGroupDetail(group: ClientGroup(name: "Jumbo"))
                .environmentObject(clientManager)
                .environmentObject(navigationManager)
                .environmentObject(errorHandler)
        }
    }
}

#Preview {
    NavigationStack {
        let persistenceManager = PersistenceManager()
        let errorHandler = ErrorHandler()
        let navigationManager = NavigationManager()
        let stateRestorationManager = StateRestorationManager()
        let clientManager = ClientManager(
            persistenceManager: persistenceManager,
            stateRestorationManager: stateRestorationManager,
            navigationManager: navigationManager,
            errorHandler: errorHandler
        )
        
        return ClientGroupDetail(group: ClientGroup(name: "Jumbo"))
            .environmentObject(clientManager)
            .environmentObject(navigationManager)
            .environmentObject(errorHandler)
    }
} 