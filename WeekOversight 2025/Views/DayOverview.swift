import SwiftUI
import Foundation

// Rename to avoid conflict with existing view
struct DayOverviewNew: View {
    let date: Date
    let trucks: [TruckData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Text(date.formatted(.dateTime.day().month().year()))
                    .font(.title)
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(trucks.count) trucks")
                        .foregroundStyle(.secondary)
                    Text("\(totalBoxes) boxes")
                        .foregroundStyle(.secondary)
                    Text("\(totalRollies) rollies")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom)
            
            // Distribution Centers
            ForEach(groupedTrucks.keys.sorted(), id: \.self) { center in
                if let centerTrucks = groupedTrucks[center] {
                    TruckCenterSection(
                        center: center,
                        trucks: centerTrucks
                    )
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var totalBoxes: Int {
        trucks.reduce(0) { $0 + $1.boxes }
    }
    
    private var totalRollies: Int {
        trucks.reduce(0) { $0 + $1.rollies }
    }
    
    private var groupedTrucks: [String: [TruckData]] {
        Dictionary(grouping: trucks) { $0.distributionCenter }
    }
}

// Rename to avoid conflict
struct TruckCenterSection: View {
    let center: String
    let trucks: [TruckData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(center)
                .font(.headline)
            
            ForEach(trucks) { truck in
                TruckDetailRow(truck: truck)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
} 