import SwiftUI

struct DayOversightDetailView: View {
    let dayOversight: DayOversight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerSection
            statsSection
            trucksSection
        }
        .padding()
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading) {
            Text("Date: \(dayOversight.date.formatted(date: .long, time: .omitted))")
                .font(.headline)
            Text("Total Trucks: \(dayOversight.trucks.count)")
                .font(.subheadline)
        }
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading) {
            Text("Statistics")
                .font(.headline)
            Text("Total Boxes: \(dayOversight.stats.boxes)")
            Text("Total Rollies: \(dayOversight.stats.rollies)")
            Text("Total Missing Boxes: \(dayOversight.stats.missingBoxes)")
        }
    }
    
    private var trucksSection: some View {
        VStack(alignment: .leading) {
            Text("Trucks by Distribution Center")
                .font(.headline)
            
            ForEach(Array(dayOversight.groupedTrucks.keys.sorted()), id: \.self) { center in
                distributionCenterSection(center)
            }
        }
    }
    
    private func distributionCenterSection(_ center: String) -> some View {
        VStack(alignment: .leading) {
            Text(center)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            if let trucks = dayOversight.groupedTrucks[center] {
                ForEach(trucks) { truck in
                    Group {
                        TruckDataView(truckData: truck)
                    }
                    .padding(.leading)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DayOversightDetailView(dayOversight: DayOversight.preview)
    }
    .withPreviewEnvironment()
} 
