import SwiftUI
import CoreData

struct ClientGroupDetailView: View {
    @StateObject private var viewModel: ClientGroupViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    
    init(clientGroup: ClientGroupEntity, context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: ClientGroupViewModel(context: context, clientGroup: clientGroup))
    }
    
    var body: some View {
        ClientGroupContent(viewModel: viewModel)
    }
}

private struct ClientGroupContent: View {
    @ObservedObject var viewModel: ClientGroupViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    @State private var showError = false
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else {
                WeekOversightList(weekOversights: viewModel.weekOversights)
            }
        }
        .navigationTitle("Week Oversights")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                ImportExcelButton()
                AddWeekButton()
            }
        }
        .task {
            for await error in viewModel.$error.values where error != nil {
                errorHandler.handle(error!)
            }
        }
    }
}

private struct WeekOversightList: View {
    let weekOversights: [WeekOversightEntity]
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var body: some View {
        List {
            ForEach(weekOversights) { oversight in
                WeekOversightRow(weekOversight: oversight)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
                            navigationManager.navigate(to: .weekOversight(oversight))
                        }
                    }
            }
        }
        .overlay {
            if weekOversights.isEmpty {
                ContentUnavailableView(
                    "No Week Oversights",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text("Add a week oversight to get started")
                )
            }
        }
    }
}

private struct ImportExcelButton: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    let group: ClientGroupEntity
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
                navigationManager.showSheet(.importExcel(group))
            }
        } label: {
            Label("Import Excel", systemImage: "square.and.arrow.down")
        }
    }
}

private struct AddWeekButton: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    let group: ClientGroupEntity
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
                navigationManager.showSheet(.createOversight(group))
            }
        } label: {
            Label("Add Week", systemImage: "plus")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let group = PreviewData.createPreviewClientGroup(in: context)
    
    return NavigationStack {
        ClientGroupDetailView(clientGroup: group, context: context)
            .withPreviewEnvironment()
    }
} 