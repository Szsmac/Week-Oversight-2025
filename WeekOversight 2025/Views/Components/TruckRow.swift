import SwiftUI

struct TruckRow: View {
    let truck: TruckData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(truck.arrivalTime.formatted(date: .omitted, time: .shortened))
                .font(.headline)
            
            HStack(spacing: 16) {
                Label("\(truck.boxes)", systemImage: "shippingbox")
                Label("\(truck.rollies)", systemImage: "cart")
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
    let truck = (dayOversight.trucks?.allObjects as? [TruckEntity])?.first ?? TruckEntity(context: context)
    let truckData = TruckData(from: truck)
    
    return List {
        TruckRow(truck: truckData)
    }
    .withPreviewEnvironment()
} 