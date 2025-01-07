import SwiftUI

struct RecentOversightCard: View {
    let oversight: WeekOversight
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Week \(oversight.weekNumber)")
                    .font(.headline)
                Text(oversight.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
        .cornerRadius(8)
    }
} 