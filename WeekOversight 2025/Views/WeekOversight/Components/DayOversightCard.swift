import SwiftUI

struct DayOversightCard: View {
    let dayOversight: DayOversight
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(Array(dayOversight.groupedTrucks.keys.sorted()), id: \.self) { center in
                if let trucks = dayOversight.groupedTrucks[center] {
                    Section(header: Text(center)) {
                        ForEach(trucks) { truck in
                            TruckDataView(truckData: truck)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DayOversightCard(dayOversight: DayOversight.preview)
        .withPreviewEnvironment()
} 