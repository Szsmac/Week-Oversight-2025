import SwiftUI
import AppKit

struct DistributionCenterColumn: View {
    let center: String
    let trucks: [TruckData]
    
    private var stats: DayStats {
        DayStats(
            boxes: trucks.reduce(0) { $0 + $1.boxes },
            rollies: trucks.reduce(0) { $0 + $1.rollies }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(center)
                    .font(.headline)
                
                Spacer()
                
                Text("\(trucks.count) trucks")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Total Boxes:")
                    Text("\(stats.boxes)")
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("Total Rollies:")
                    Text("\(stats.rollies)")
                        .fontWeight(.medium)
                }
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color(nsColor: NSColor.windowBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    DistributionCenterColumn(
        center: "DC1",
        trucks: [.preview]
    )
    .padding()
    .background(Color(nsColor: NSColor.controlBackgroundColor))
} 