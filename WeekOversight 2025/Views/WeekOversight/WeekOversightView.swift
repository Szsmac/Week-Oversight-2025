import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var excel: UTType {
        UTType(tag: "xlsx",
               tagClass: .filenameExtension,
               conformingTo: .spreadsheet)!
    }
    
    static var xlsm: UTType {
        UTType(tag: "xlsm",
               tagClass: .filenameExtension,
               conformingTo: .spreadsheet)!
    }
}

struct WeekOversightView: View {
    let oversight: WeekOversight
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    @State private var selectedDay: Date?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            WeekOversightHeader(oversight: oversight)
                .padding()
            
            // Calendar
            WeekCalendarView(
                selectedDate: $selectedDay,
                weekOversight: oversight
            )
            .padding(.horizontal)
            
            // Day Oversights
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 300, maximum: 400))],
                    spacing: 20
                ) {
                    ForEach(oversight.dayOversights.sorted(by: { $0.date < $1.date })) { day in
                        DayOversightFrame(dayOversight: day)
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: { navigationManager.goBack() }) {
                    Image(systemName: "chevron.left")
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    navigationManager.showSheet(.importExcel)
                } label: {
                    Label("Import Excel", systemImage: "square.and.arrow.down")
                }
                .buttonStyle(.hessing)
            }
        }
        .sheet(item: $navigationManager.sheet) { sheet in
            switch sheet {
            case .importExcel:
                ImportExcelView(
                    urls: [],
                    onComplete: { newOversight in
                        Task {
                            try? await clientManager.updateWeekOversight(newOversight)
                            navigationManager.dismissSheet()
                        }
                    },
                    currentOversight: oversight
                )
            default:
                EmptyView()
            }
        }
        .animation(.spring(), value: oversight.dayOversights)
    }
}

// MARK: - Supporting Views
private struct StatView: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.medium)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct DayOversightRow: View {
    let dayOversight: DayOversight
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dayOversight.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.headline)
                Text("\(dayOversight.trucks.count) trucks")
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    WeekOversightView(oversight: .preview)
        .withPreviewEnvironment()
} 