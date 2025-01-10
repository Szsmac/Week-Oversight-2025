import SwiftUI

struct TruckDataListView: View {
    let trucks: [TruckData]
    
    var sortedTrucks: [TruckData] {
        trucks.sorted { $0.arrivalTime < $1.arrivalTime }
    }
    
    var body: some View {
        List(sortedTrucks) { truck in
            TruckDataView(truck: truck)
        }
    }
}

#Preview {
    TruckDataListView(trucks: [.preview])
} 