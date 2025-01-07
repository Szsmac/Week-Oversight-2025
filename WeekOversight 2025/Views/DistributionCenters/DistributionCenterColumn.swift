import SwiftUI

struct DistributionCenterColumn: View {
    let center: DistributionCenter
    let trucks: [TruckData]
    
    var body: some View {
        VStack(alignment: .leading) {
            headerView
            trucksListView
            footerView
        }
        .padding()
    }
    
    private var headerView: some View {
        VStack(alignment: .leading) {
            Text(center.name)
                .font(.headline)
            Text("\(trucks.count) Trucks")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var trucksListView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(trucks) { truck in
                    TruckDataView(truckData: truck)
                }
            }
        }
    }
    
    private var footerView: some View {
        VStack(alignment: .leading) {
            Text("Total Boxes: \(trucks.reduce(0) { $0 + $1.boxes })")
            Text("Total Rollies: \(trucks.reduce(0) { $0 + $1.rollies })")
            Text("Missing Boxes: \(trucks.reduce(0) { $0 + $1.missingBoxes })")
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }
} 