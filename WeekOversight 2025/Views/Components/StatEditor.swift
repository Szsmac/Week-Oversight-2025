import SwiftUI

struct StatEditor: View {
    @Binding var value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            TextField("", value: $value, format: .number)
                .textFieldStyle(.roundedBorder)
                .frame(width: 80)
        }
    }
} 