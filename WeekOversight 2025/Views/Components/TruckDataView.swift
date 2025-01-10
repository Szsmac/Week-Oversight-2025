import SwiftUI

struct TruckDataView: View {
    let truck: TruckData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(truck.distributionCenter)
                .font(.headline)
            
            Text(truck.arrivalTime.formatted(date: .omitted, time: .shortened))
                .foregroundStyle(.secondary)
            
            HStack(spacing: 16) {
                Label("\(truck.boxes)", systemImage: "shippingbox")
                Label("\(truck.rollies)", systemImage: "cart")
            }
            .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TruckDataView(truck: .preview)
} 