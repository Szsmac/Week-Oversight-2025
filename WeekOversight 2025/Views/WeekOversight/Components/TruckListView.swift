import SwiftUI

struct TruckListView: View {
    let trucks: [TruckData]
    
    var body: some View {
        List {
            ForEach(trucks) { truck in
                TruckDetailRow(truck: truck)
            }
        }
    }
} 