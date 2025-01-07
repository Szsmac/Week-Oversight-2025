import SwiftUI

struct TruckDetailRow: View {
    let truck: TruckData
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(truck.distributionCenter)
                    .font(.headline)
                Text(truck.arrival.formatted(date: .omitted, time: .shortened))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Label("\(truck.boxes)", systemImage: "shippingbox")
                Label("\(truck.rollies)", systemImage: "cart")
                if truck.missingBoxes > 0 {
                    Label("\(truck.missingBoxes)", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TruckDetailRow(truck: TruckData(
        id: UUID(),
        number: "T123",
        boxes: 100,
        rollies: 50,
        missingBoxes: 0,
        distributionCenter: "Center A",
        arrival: Date()
    ))
} 