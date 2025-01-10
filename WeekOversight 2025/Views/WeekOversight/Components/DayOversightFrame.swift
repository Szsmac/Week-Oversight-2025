import SwiftUI

struct DayOversightFrame: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    @ObservedObject var viewModel: DayOversightViewModel
    
    @State private var showingAddTruck = false
    @State private var selectedCenter: String?
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            if viewModel.trucks.isEmpty {
                EmptyStateView(
                    icon: "truck",
                    message: "No trucks yet"
                )
            } else {
                List {
                    ForEach(viewModel.groupedTrucks.sorted(by: { $0.key < $1.key }), id: \.key) { center, trucks in
                        DistributionCenterSection(
                            center: center,
                            trucks: trucks,
                            onDelete: { truck in
                                Task {
                                    await deleteTruck(truck)
                                }
                            }
                        )
                    }
                }
            }
        }
        .navigationTitle(viewModel.date.formatted(date: .abbreviated, time: .omitted))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddTruck = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddTruck) {
            AddDistributionCenterSheet { truck in
                Task {
                    await addTruck(truck)
                }
            }
        }
        .disabled(isLoading)
        .overlay {
            if isLoading {
                LoadingView()
            }
        }
    }
    
    private var header: some View {
        HStack {
            StatView(title: "Total Boxes", value: viewModel.stats.boxes)
            StatView(title: "Total Rollies", value: viewModel.stats.rollies)
        }
        .padding()
        .background(.background)
    }
    
    private func addTruck(_ truck: TruckData) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await viewModel.createTruck(
                distributionCenter: truck.distributionCenter,
                arrivalTime: truck.arrivalTime,
                boxes: truck.boxes,
                rollies: truck.rollies
            )
        } catch {
            errorHandler.handle(error)
        }
    }
    
    private func deleteTruck(_ truck: TruckData) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await viewModel.deleteTruck(truck)
        } catch {
            errorHandler.handle(error)
        }
    }
}

#Preview {
    NavigationStack {
        DayOversightFrame(viewModel: .preview)
    }
    .withPreviewEnvironment()
} 