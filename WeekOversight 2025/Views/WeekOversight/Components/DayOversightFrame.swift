import SwiftUI
import UniformTypeIdentifiers

struct DayOversightFrame: View {
    let dayOversight: DayOversight
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    @State private var isEditing = false
    @State private var selectedTrucks: [TruckData]?
    @State private var showingTruckDetails = false
    @State private var selectedCenter: String?
    @State private var showingDeleteAlert = false
    @State private var centerToDelete: String?
    @State private var showingImportError = false
    @State private var importErrorMessage = ""
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            headerSection
            
            // Content
            ScrollView {
                VStack(spacing: 16) {
                    // Main Centers
                    ForEach(sortedMainCenters(), id: \.name) { center in
                        DistributionCenterSection(
                            center: center,
                            onViewDetails: { showTruckDetails(for: center.name) },
                            onDelete: { confirmDelete(center: center.name) }
                        )
                    }
                    
                    // EFC Section
                    if let efcCenter = efcCenter() {
                        Divider()
                            .padding(.vertical, 8)
                        
                        DistributionCenterSection(
                            center: efcCenter,
                            onViewDetails: { showTruckDetails(for: "EFC") },
                            onDelete: { confirmDelete(center: "EFC") }
                        )
                        .background(Color(.unemphasizedSelectedContentBackgroundColor))
                    }
                    
                    // Statistics
                    statisticsSection
                }
                .padding()
            }
        }
        .background(Color(.windowBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separatorColor), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
        .transition(.asymmetric(
            insertion: .scale(scale: 0.95).combined(with: .opacity),
            removal: .scale(scale: 0.95).combined(with: .opacity)
        ))
        .sheet(isPresented: $showingTruckDetails) {
            TruckListView(trucks: selectedTrucks ?? [])
                .frame(minWidth: 600, minHeight: 400)
        }
        .alert("Delete Distribution Center", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                centerToDelete = nil
            }
            Button("Delete", role: .destructive) {
                Task {
                    await deleteDayOversight()
                }
            }
        } message: {
            Text("Are you sure you want to delete this distribution center and all its trucks? This action cannot be undone.")
        }
        .alert("Import Error", isPresented: $showingImportError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(importErrorMessage)
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text(dayOversight.date.formatted(date: .abbreviated, time: .omitted))
                .font(.title2.bold())
            
            Spacer()
            
            Text("\(dayOversight.trucks.count) Trucks")
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.controlBackgroundColor))
                .clipShape(Capsule())
            
            menuButton
        }
        .padding()
        .background(Color(.controlBackgroundColor))
    }
    
    private var statisticsSection: some View {
        Grid(alignment: .leading, horizontalSpacing: 24, verticalSpacing: 12) {
            GridRow {
                StatView(title: "Total Boxes", value: dayOversight.stats.boxes)
                StatView(title: "Missing Boxes", value: dayOversight.stats.missingBoxes)
                StatView(title: "Total Rollies", value: dayOversight.stats.rollies)
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func sortedMainCenters() -> [DistributionCenter] {
        let mainCenters = dayOversight.groupedTrucks
            .filter { $0.key != "EFC" }
            .map { center, trucks in
                DistributionCenter(
                    name: center,
                    trucks: trucks
                )
            }
            .sorted { $0.name < $1.name }
        return mainCenters
    }
    
    private func efcCenter() -> DistributionCenter? {
        guard let efcTrucks = dayOversight.groupedTrucks["EFC"] else { return nil }
        return DistributionCenter(
            name: "EFC",
            trucks: efcTrucks
        )
    }
    
    private func showTruckDetails(for center: String) {
        selectedCenter = center
        selectedTrucks = dayOversight.groupedTrucks[center]
        showingTruckDetails = true
    }
    
    private func confirmDelete(center: String) {
        centerToDelete = center
        showingDeleteAlert = true
    }
    
    private func deleteDayOversight() async {
        guard let centerToDelete = centerToDelete else { return }
        
        do {
            if var group = clientManager.clientGroups.first(where: { $0.id == dayOversight.clientGroupId }),
               let weekOversight = group.weekOversights.first(where: { $0.id == dayOversight.weekOversightId }) {
                var updatedOversight = weekOversight
                var updatedDay = dayOversight
                updatedDay.trucks.removeAll { $0.distributionCenter == centerToDelete }
                
                if let dayIndex = updatedOversight.dayOversights.firstIndex(where: { $0.id == dayOversight.id }) {
                    updatedOversight.dayOversights[dayIndex] = updatedDay
                    
                    var updatedGroup = group
                    if let oversightIndex = updatedGroup.weekOversights.firstIndex(where: { $0.id == weekOversight.id }) {
                        updatedGroup.weekOversights[oversightIndex] = updatedOversight
                        await updateGroup(updatedGroup)
                    }
                }
            }
        } catch {
            errorHandler.handle(error)
        }
        
        self.centerToDelete = nil
    }
    
    private var menuButton: some View {
        Menu {
            Button("Edit") {
                isEditing = true
            }
            Button("Delete", role: .destructive) {
                Task {
                    await deleteDayOversight()
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .foregroundStyle(.secondary)
        }
        .menuStyle(.borderlessButton)
        .frame(width: 24, height: 24)
    }
    
    private struct StatView: View {
        let title: String
        let value: Int
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(value)")
                    .font(.callout.monospacedDigit())
                    .fontWeight(.medium)
            }
            .frame(minWidth: 100, alignment: .leading)
        }
    }
    
    private func importExcel() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType(filenameExtension: "xlsm")!]
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK, let url = panel.url {
            Task {
                do {
                    let importer = ExcelImporter()
                    let trucks = try await importer.importExcelFile(from: url)
                    
                    if trucks.isEmpty {
                        throw ExcelImportError.missingData("No trucks found")
                    }
                    
                    // Update the day oversight on the main thread
                    await MainActor.run {
                        if let group = clientManager.clientGroups.first(where: { $0.id == dayOversight.clientGroupId }),
                           let weekOversight = group.weekOversights.first(where: { $0.id == dayOversight.weekOversightId }) {
                            var updatedOversight = weekOversight
                            var updatedDay = dayOversight
                            updatedDay.trucks = trucks
                            
                            if let dayIndex = updatedOversight.dayOversights.firstIndex(where: { $0.id == dayOversight.id }) {
                                updatedOversight.dayOversights[dayIndex] = updatedDay
                                var updatedGroup = group
                                if let oversightIndex = updatedGroup.weekOversights.firstIndex(where: { $0.id == weekOversight.id }) {
                                    updatedGroup.weekOversights[oversightIndex] = updatedOversight
                                    // Use the helper method for updating the group
                                    Task {
                                        await updateGroup(updatedGroup)
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    await MainActor.run {
                        importErrorMessage = error.localizedDescription
                        showingImportError = true
                    }
                }
            }
        }
    }
    
    @MainActor
    private func updateGroup(_ group: ClientGroup) async {
        do {
            try await clientManager.updateClientGroup(group)
        } catch {
            errorHandler.handle(error)
        }
    }
}

struct DistributionCenterSection: View {
    let center: DistributionCenter
    let onViewDetails: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(center.name)
                        .font(.headline)
                    Spacer()
                    Menu {
                        Button {
                            onViewDetails()
                        } label: {
                            Label("View Details", systemImage: "list.bullet")
                        }
                        
                        Button(role: .destructive) {
                            onDelete()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundStyle(.secondary)
                    }
                    .menuStyle(.borderlessButton)
                    .frame(width: 24, height: 24)
                }
                
                // Stats
                HStack(spacing: 16) {
                    Label("\(center.totalTrucks)", systemImage: "truck.box")
                    Label("\(center.totalBoxes)", systemImage: "shippingbox")
                    Label("\(center.totalRollies)", systemImage: "cart")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.3))
        .cornerRadius(8)
    }
}

struct TruckDetailsView: View {
    let centerName: String
    let trucks: [TruckData]
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(trucks.sorted(by: { $0.arrival < $1.arrival })) { truck in
                    TruckDetailRow(truck: truck)
                }
            }
            .navigationTitle("\(centerName) Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        isPresented = false
                    }
                }
            }
        }
        .frame(minWidth: 400, minHeight: 300)
    }
} 