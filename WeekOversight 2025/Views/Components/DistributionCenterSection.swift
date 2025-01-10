import SwiftUI

struct DistributionCenterSection: View {
    let center: String
    let trucks: [TruckData]
    let onDelete: ((TruckData) -> Void)?
    
    init(center: String, trucks: [TruckData], onDelete: ((TruckData) -> Void)? = nil) {
        self.center = center
        self.trucks = trucks
        self.onDelete = onDelete
    }
    
    var body: some View {
        Section(center) {
            ForEach(trucks) { truck in
                TruckDetailRow(truck: truck)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        if let onDelete = onDelete {
                            Button(role: .destructive) {
                                onDelete(truck)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    let truck = TruckData(
        distributionCenter: "Test Center",
        boxes: 100,
        rollies: 50,
        arrivalTime: Date()
    )
    
    return List {
        DistributionCenterSection(
            center: "Test Center",
            trucks: [truck],
            onDelete: { _ in }
        )
    }
} 