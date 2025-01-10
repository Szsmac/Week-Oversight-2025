import SwiftUI

struct StatView: View {
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

#Preview {
    StatView(title: "Total Boxes", value: 100)
        .padding()
} 