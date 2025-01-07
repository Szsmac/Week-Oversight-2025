import SwiftUI

struct DayStatsEditor: View {
    let dayOversight: DayOversight
    
    var totalMissingBoxes: Int {
        dayOversight.trucks.reduce(into: 0) { $0 += $1.missingBoxes }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Day Statistics")
                .font(.headline)
            
            ForEach(dayOversight.trucks) { truck in
                StatRow(title: "Missing Boxes", value: truck.missingBoxes)
            }
        }
        .padding()
    }
}

struct DayStatsEditor_Previews: PreviewProvider {
    static var previews: some View {
        DayStatsEditor(
            dayOversight: .preview
        )
        .withPreviewEnvironment()
    }
} 