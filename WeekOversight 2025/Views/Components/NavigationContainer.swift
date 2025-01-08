import SwiftUI

struct NavigationContainer<Content: View>: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    @EnvironmentObject private var stateRestorationManager: StateRestorationManager
    @EnvironmentObject private var windowManager: WindowManager
    
    let content: Content
    
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            NavigationStack(path: $navigationManager.path) {
                content
                    .navigationDestination(for: NavigationRoute.self) { route in
                        destinationView(for: route)
                    }
            }
            
            if navigationManager.sheet != nil {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .sheet(item: $navigationManager.sheet) { type in
            NavigationStack {
                SheetContent(type: type)
            }
            .presentationDetents([.medium])
            .presentationBackground(.ultraThinMaterial)
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: NavigationRoute) -> some View {
        Group {
            switch route {
            case .welcome:
                WelcomeView()
            case .clientManagement:
                ClientManagementView()
                    .navigationTitle("Client Management")
            case .clientGroupDetail(let group):
                ClientGroupDetailView(group: group)
                    .navigationTitle(group.name)
            case .weekOversight(let oversight):
                WeekOversightView(oversight: oversight)
                    .navigationTitle("Week \(oversight.weekNumber)")
            case .dayOversight(let oversight):
                DayOversightView(dayOversight: oversight)
                    .navigationTitle(oversight.date.formatted(date: .abbreviated, time: .omitted))
            }
        }
        .environmentObject(navigationManager)
        .environmentObject(clientManager)
        .environmentObject(errorHandler)
        .environmentObject(stateRestorationManager)
        .environmentObject(windowManager)
    }
}

private struct SheetContent: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    
    let type: SheetType
    
    var body: some View {
        Group {
            switch type {
            case .addClient:
                AddClientSheet()
            case .createOversight:
                CreateOversightSheet { newOversight in
                    Task {
                        try? await clientManager.updateWeekOversight(newOversight)
                        navigationManager.dismissSheet()
                    }
                }
            case .createClientOversight(let group):
                CreateOversightSheet(group: group) { newOversight in
                    Task {
                        try? await clientManager.updateWeekOversight(newOversight)
                        navigationManager.navigate(to: .weekOversight(newOversight))
                        navigationManager.dismissSheet()
                    }
                }
            case .deleteClientGroup(let group):
                DeleteConfirmationSheet(
                    title: "Delete Client Group",
                    message: "Are you sure you want to delete this client group? This action cannot be undone.",
                    onConfirm: {
                        Task {
                            try? await clientManager.deleteClientGroup(group)
                            navigationManager.goBack()
                            navigationManager.dismissSheet()
                        }
                    }
                )
            case .importExcel:
                ExcelImporterView()
            }
        }
    }
}

struct ExcelImporterView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    @State private var showingFilePicker = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Import Excel File")
                .font(.headline)
            
            Button("Select File") {
                showingFilePicker = true
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [.spreadsheet],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    Task {
                        do {
                            let importer = ExcelImporter()
                            let trucks = try await importer.importExcelFile(from: url)
                            if !trucks.isEmpty {
                                // TODO: Update the current day oversight with the imported trucks
                                navigationManager.dismissSheet()
                            }
                        } catch {
                            errorHandler.handle(error)
                        }
                    }
                }
            case .failure(let error):
                errorHandler.handle(error)
            }
        }
    }
} 
