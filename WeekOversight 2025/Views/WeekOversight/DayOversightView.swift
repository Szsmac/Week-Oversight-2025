import SwiftUI
import CoreData

struct DayOversightView: View {
    @StateObject private var viewModel: DayOversightViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    
    init(dayOversight: DayOversightEntity, context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: DayOversightViewModel(context: context, dayOversight: dayOversight))
    }
    
    var body: some View {
        DayOversightContent(viewModel: viewModel)
    }
}

private struct DayOversightContent: View {
    @ObservedObject var viewModel: DayOversightViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    @State private var showingTruckDetails = false
    @State private var selectedTrucks: [TruckData]?
    @State private var selectedCenter: String?
    @State private var showingDeleteAlert = false
    @State private var centerToDelete: String?
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else {
                mainContent
            }
        }
        .navigationTitle(viewModel.date.formatted(date: .abbreviated, time: .omitted))
        .toolbar { toolbarContent }
        .overlay { emptyStateOverlay }
        .sheet(isPresented: $showingTruckDetails) { truckDetailsSheet }
        .alert("Delete Distribution Center", isPresented: $showingDeleteAlert) { deleteAlert }
        .task {
            for await error in viewModel.$error.values where error != nil {
                errorHandler.handle(error!)
            }
        }
    }
    
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                distributionCentersList
                statisticsSection
            }
            .padding()
        }
    }
    
    private var groupedTrucks: [(String, [TruckData])] {
        Dictionary(grouping: viewModel.trucks, by: \.distributionCenter)
            .sorted { $0.key < $1.key }
    }
    
    private var distributionCentersList: some View {
        ForEach(groupedTrucks, id: \.0) { center, trucks in
            DistributionCenterSection(
                center: center,
                trucks: trucks,
                onDelete: { truck in
                    Task {
                        try? await viewModel.deleteTruck(truck)
                    }
                }
            )
            .onTapGesture {
                showTruckDetails(for: center)
            }
        }
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
                    navigationManager.showSheet(.addTruck(viewModel.dayOversight))
                }
            } label: {
                Label("Add Truck", systemImage: "plus")
            }
            
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
                    navigationManager.showSheet(.importExcel(viewModel.dayOversight.weekOversight?.clientGroup ?? viewModel.dayOversight.managedObjectContext!.registeredObjects.first(where: { $0 is ClientGroupEntity }) as! ClientGroupEntity))
                }
            } label: {
                Label("Import Excel", systemImage: "square.and.arrow.down")
            }
        }
    }
    
    private var emptyStateOverlay: some View {
        Group {
            if viewModel.trucks.isEmpty {
                ContentUnavailableView(
                    "No Trucks Added",
                    systemImage: "truck.box",
                    description: Text("Import an Excel file to add trucks")
                )
            }
        }
    }
    
    private var truckDetailsSheet: some View {
        Group {
            if let trucks = selectedTrucks {
                TruckDetailRow(truck: trucks.first!)
            }
        }
    }
    
    private var deleteAlert: some View {
        Group {
            Button("Cancel", role: .cancel) {
                centerToDelete = nil
            }
            Button("Delete", role: .destructive) {
                Task {
                    await deleteTrucks()
                }
            }
        }
    }
    
    private var statisticsSection: some View {
        Grid(alignment: .leading, horizontalSpacing: 24, verticalSpacing: 12) {
            GridRow {
                StatView(title: "Total Boxes", value: viewModel.stats.boxes)
                StatView(title: "Total Rollies", value: viewModel.stats.rollies)
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func showTruckDetails(for center: String) {
        selectedCenter = center
        selectedTrucks = viewModel.trucks.filter { $0.distributionCenter == center }
        showingTruckDetails = true
    }
    
    private func confirmDelete(center: String) {
        centerToDelete = center
        showingDeleteAlert = true
    }
    
    private func deleteTrucks() async {
        guard let centerToDelete = centerToDelete else { return }
        
        do {
            for truck in viewModel.trucks.filter({ $0.distributionCenter == centerToDelete }) {
                try await viewModel.deleteTruck(truck)
            }
        } catch {
            errorHandler.handle(error)
        }
        
        self.centerToDelete = nil
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let group = PreviewData.createPreviewClientGroup(in: context)
    let weekOversight = (group.weekOversights?.allObjects as? [WeekOversightEntity])?.first ?? WeekOversightEntity(context: context)
    let dayOversight = (weekOversight.dayOversights?.allObjects as? [DayOversightEntity])?.first ?? DayOversightEntity(context: context)
    
    return NavigationStack {
        DayOversightView(dayOversight: dayOversight, context: context)
            .withPreviewEnvironment()
    }
} 