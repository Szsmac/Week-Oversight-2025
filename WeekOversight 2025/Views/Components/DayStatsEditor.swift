import SwiftUI

struct DayStatsEditor: View {
    let dayOversight: DayOversight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Day Statistics")
                .font(.headline)
            
            StatRow(title: "Total Boxes", value: dayOversight.stats.boxes)
            StatRow(title: "Total Rollies", value: dayOversight.stats.rollies)
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