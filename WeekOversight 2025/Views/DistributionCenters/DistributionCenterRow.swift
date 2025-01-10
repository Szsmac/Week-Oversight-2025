import SwiftUI
import AppKit

struct DistributionCenterRow: View {
    let center: String
    let trucks: [TruckData]
    
    private var stats: DayStats {
        DayStats(
            boxes: trucks.reduce(0) { $0 + $1.boxes },
            rollies: trucks.reduce(0) { $0 + $1.rollies }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(center)
                    .font(.headline)
                
                Spacer()
                
                Text("\(trucks.count) trucks")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                DistributionCenterStatView(title: "Boxes", value: stats.boxes)
                DistributionCenterStatView(title: "Rollies", value: stats.rollies)
            }
        }
        .padding()
        .background(Color(nsColor: NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct DistributionCenterStatView: View {
    let title: String
    let value: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(value)")
                .font(.callout.monospacedDigit())
                .fontWeight(.medium)
        }
        .frame(minWidth: 100, alignment: .leading)
    }
}

#Preview {
    DistributionCenterRow(
        center: "DC1",
        trucks: [.preview]
    )
    .padding()
    .background(Color(nsColor: NSColor.windowBackgroundColor))
} 