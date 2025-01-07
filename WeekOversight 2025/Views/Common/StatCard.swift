import SwiftUI

struct StatCard: View {
    let title: String
    let value: Int
    let icon: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 4) {
                Text("\(value)")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.medium)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
        )
    }
}

#Preview {
    StatCard(title: "Test", value: 42, icon: "star.fill")
        .withPreviewEnvironment()
} 