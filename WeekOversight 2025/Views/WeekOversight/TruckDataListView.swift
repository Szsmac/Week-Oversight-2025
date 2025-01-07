import SwiftUI

struct TruckDataListView: View {
    let trucks: [TruckData]
    
    var body: some View {
        List {
            ForEach(trucks.sorted(by: { $0.arrival < $1.arrival })) { truck in
                TruckDetailRow(truck: truck)
            }
        }
    }
} 