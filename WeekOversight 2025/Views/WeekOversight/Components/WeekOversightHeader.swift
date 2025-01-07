import SwiftUI

private struct StatView: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(value)")
                .font(.headline)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

struct WeekOversightHeader: View {
    let oversight: WeekOversight
    @EnvironmentObject private var clientManager: ClientManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Week \(oversight.weekNumber)")
                .font(.title2)
                .fontWeight(.bold)
            
            if let group = clientManager.clientGroups.first(where: { $0.id == oversight.clientGroupId }) {
                Text(group.name)
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 24) {
                StatView(value: oversight.dayOversights.count, label: "Days")
                StatView(value: oversight.totalTrucks, label: "Trucks")
                StatView(value: oversight.totalBoxes, label: "Boxes")
                StatView(value: oversight.totalRollies, label: "Rollies")
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    WeekOversightHeader(oversight: .preview)
        .withPreviewEnvironment()
} 