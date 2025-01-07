import SwiftUI

struct DistributionCenterRow: View {
    let center: DistributionCenter
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(center.name)
                .font(.headline)
            
            HStack {
                StatRow(title: "Trucks", value: center.totalTrucks)
                StatRow(title: "Boxes", value: center.totalBoxes)
                StatRow(title: "Rollies", value: center.totalRollies)
            }
        }
        .padding(.vertical, 8)
    }
} 