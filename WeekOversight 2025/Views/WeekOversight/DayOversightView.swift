import SwiftUI

struct DayOversightView: View {
    let dayOversight: DayOversight
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    @State private var centerToDelete: String?
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            contentSection
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: { navigationManager.goBack() }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .animation(.spring(), value: dayOversight.trucks)
    }
    
    private var headerSection: some View {
        HStack {
            Text(dayOversight.date.formatted(date: .abbreviated, time: .omitted))
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                navigationManager.showSheet(.importExcel)
            } label: {
                Label("Import Excel", systemImage: "square.and.arrow.down")
            }
            .buttonStyle(.hessing)
        }
        .padding()
    }
    
    private var contentSection: some View {
        TrucksList(dayOversight: dayOversight, onDeleteCenter: deleteTrucksForCenter)
    }
    
    private struct TrucksList: View {
        let dayOversight: DayOversight
        let onDeleteCenter: (String) async -> Void
        
        var body: some View {
            List {
                ForEach(Array(dayOversight.groupedTrucks.keys.sorted()), id: \.self) { center in
                    TruckSection(
                        center: center,
                        trucks: dayOversight.groupedTrucks[center] ?? [],
                        onDelete: { 
                            Task {
                                await onDeleteCenter(center)
                            }
                        }
                    )
                }
            }
        }
    }
    
    private struct TruckSection: View {
        let center: String
        let trucks: [TruckData]
        let onDelete: () -> Void
        
        var body: some View {
            Section(center) {
                ForEach(trucks) { truck in
                    TruckDataView(truckData: truck)
                }
                .onDelete { _ in onDelete() }
            }
        }
    }
    
    private func deleteTrucksForCenter(_ center: String) async {
        do {
            if let group = clientManager.clientGroups.first(where: { $0.id == dayOversight.clientGroupId }),
               let weekOversight = group.weekOversights.first(where: { $0.id == dayOversight.weekOversightId }) {
                var updatedOversight = weekOversight
                var updatedDay = dayOversight
                updatedDay.trucks.removeAll { $0.distributionCenter == center }
                
                if let dayIndex = updatedOversight.dayOversights.firstIndex(where: { $0.id == dayOversight.id }) {
                    updatedOversight.dayOversights[dayIndex] = updatedDay
                    try await clientManager.updateWeekOversight(updatedOversight)
                }
            }
        } catch {
            errorHandler.handle(error)
        }
    }
} 