import SwiftUI

struct WeekOversightView: View {
    @StateObject private var viewModel: WeekOversightViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    init(weekOversight: WeekOversightEntity) {
        _viewModel = StateObject(wrappedValue: WeekOversightViewModel(
            context: PersistenceController.shared.container.viewContext,
            weekOversight: weekOversight
        ))
    }
    
    var body: some View {
        WeekOversightContent(viewModel: viewModel)
    }
}

private struct WeekOversightContent: View {
    @ObservedObject var viewModel: WeekOversightViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    @State private var selectedDate: Date?
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else {
                mainContent
            }
        }
        .navigationTitle("Week \(viewModel.weekNumber)")
        .toolbar { toolbarContent }
        .task {
            for await error in viewModel.$error.values where error != nil {
                errorHandler.handle(error!)
            }
        }
    }
    
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                WeekCalendarView(selectedDate: $selectedDate, weekOversight: viewModel.weekOversight)
                    .padding(.horizontal)
                
                if let selectedDate = selectedDate,
                   let dayOversight = viewModel.dayOversight(for: selectedDate) {
                    DayOversightCard(dayOversight: dayOversight)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
                                navigationManager.navigate(to: .dayOversight(dayOversight))
                            }
                        }
                }
            }
            .padding(.vertical)
        }
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)) {
                    navigationManager.showSheet(.addDay(viewModel.weekOversight))
                }
            } label: {
                Label("Add Day", systemImage: "plus")
            }
        }
    }
}

private struct DayOversightCard: View {
    let dayOversight: DayOversight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(dayOversight.date.formatted(date: .abbreviated, time: .omitted))
                .font(.headline)
            
            if dayOversight.trucks.isEmpty {
                Text("No trucks")
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(dayOversight.trucks) { truck in
                        TruckRow(truck: truck)
                    }
                }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let group = PreviewData.createPreviewClientGroup(in: context)
    let weekOversight = (group.weekOversights?.allObjects as? [WeekOversightEntity])?.first ?? WeekOversightEntity(context: context)
    
    return NavigationStack {
        WeekOversightView(weekOversight: weekOversight)
            .withPreviewEnvironment()
    }
} 