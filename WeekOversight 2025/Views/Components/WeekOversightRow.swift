import SwiftUI

struct WeekOversightRow: View {
    let weekOversight: WeekOversight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Week \(weekOversight.weekNumber)")
                .font(.headline)
            
            HStack(spacing: 16) {
                Label("\(weekOversight.totalTrucks)", systemImage: "truck")
                Label("\(weekOversight.totalBoxes)", systemImage: "shippingbox")
                Label("\(weekOversight.totalRollies)", systemImage: "cart")
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
    let weekOversight = WeekOversight(from: group.weekOversights?.allObjects.first as! WeekOversightEntity)
    
    return List {
        WeekOversightRow(weekOversight: weekOversight)
    }
    .withPreviewEnvironment()
} 