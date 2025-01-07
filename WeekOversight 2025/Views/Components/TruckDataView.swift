import SwiftUI

struct TruckDataView: View {
    let truckData: TruckData
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text(truckData.distributionCenter)
                    .font(.headline)
                Text(truckData.arrival.formatted(date: .omitted, time: .shortened))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                StatView(value: truckData.boxes, label: "Boxes", icon: "shippingbox")
                StatView(value: truckData.rollies, label: "Rollies", icon: "cart")
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .transition(.move(edge: .leading).combined(with: .opacity))
    }
}

private struct StatView: View {
    let value: Int
    let label: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(value)")
                    .fontWeight(.medium)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
} 