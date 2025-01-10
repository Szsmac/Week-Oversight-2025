import SwiftUI

private struct WeekOversightStatView: View {
    let title: String
    let value: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("\(value)")
                .font(.title2)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct WeekOversightHeader: View {
    let oversight: WeekOversight
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Week \(oversight.weekNumber)")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(oversight.date.formatted(date: .abbreviated, time: .omitted))
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                WeekOversightStatView(title: "Days", value: oversight.dayOversights.count)
                WeekOversightStatView(title: "Total Trucks", value: oversight.totalTrucks)
                WeekOversightStatView(title: "Total Boxes", value: oversight.totalBoxes)
                WeekOversightStatView(title: "Total Rollies", value: oversight.totalRollies)
            }
        }
        .padding()
        .background(.background)
    }
}

#Preview {
    WeekOversightHeader(oversight: .preview)
        .withPreviewEnvironment()
} 