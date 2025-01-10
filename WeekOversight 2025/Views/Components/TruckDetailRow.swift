import SwiftUI

struct TruckDetailRow: View {
    let truck: TruckData
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(truck.distributionCenter)
                    .font(.headline)
                
                Text(truck.arrivalTime.formatted(date: .omitted, time: .shortened))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
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
        TruckDetailRow(truck: truckData)
    }
    .withPreviewEnvironment()
} 