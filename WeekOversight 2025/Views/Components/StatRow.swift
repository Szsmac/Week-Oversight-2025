import SwiftUI

struct StatRow: View {
    let title: String
    let value: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(value)")
                .font(.headline)
        }
    }
}

struct StatRow_Previews: PreviewProvider {
    static var previews: some View {
        StatRow(title: "Test", value: 100)
            .withPreviewEnvironment()
    }
}

#Preview {
    StatRow(title: "Test", value: 42)
        .padding()
} 