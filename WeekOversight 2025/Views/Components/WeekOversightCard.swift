import SwiftUI

struct WeekOversightCard: View {
    let oversight: WeekOversight
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Label("Week \(oversight.weekNumber)", systemImage: "calendar")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            
            Divider()
            
            // Stats
            HStack(spacing: 24) {
                StatItemView(value: oversight.dayOversights.count, label: "Days")
                StatItemView(value: oversight.totalTrucks, label: "Trucks")
                StatItemView(value: oversight.totalBoxes, label: "Boxes")
            }
            
            Text(oversight.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
        )
    }
}

private struct StatItemView: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.medium)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    WeekOversightCard(oversight: .preview)
        .frame(width: 300)
        .padding()
} 