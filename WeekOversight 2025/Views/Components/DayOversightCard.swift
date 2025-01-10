import SwiftUI

struct DayOversightSummaryCard: View {
    let dayOversight: DayOversight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(dayOversight.date.formatted(date: .abbreviated, time: .omitted))
                .font(.headline)
            
            HStack(spacing: 16) {
                Label("\(dayOversight.trucks.count)", systemImage: "truck")
                Label("\(dayOversight.stats.boxes)", systemImage: "shippingbox")
                Label("\(dayOversight.stats.rollies)", systemImage: "cart")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let group = PreviewData.createPreviewClientGroup(in: context)
    let weekOversight = (group.weekOversights?.allObjects as? [WeekOversightEntity])?.first ?? WeekOversightEntity(context: context)
    let dayOversight = (weekOversight.dayOversights?.allObjects as? [DayOversightEntity])?.first ?? DayOversightEntity(context: context)
    let day = DayOversight(from: dayOversight)
    
    return List {
        DayOversightSummaryCard(dayOversight: day)
    }
    .withPreviewEnvironment()
} 