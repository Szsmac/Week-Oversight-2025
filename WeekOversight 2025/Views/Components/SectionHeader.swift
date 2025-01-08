import SwiftUI

struct SectionHeader: View {
    let title: String
    let systemImage: String
    var action: (() -> Void)?
    
    var body: some View {
        HStack {
            Label(title, systemImage: systemImage)
                .font(.headline)
            
            Spacer()
            
            if let action = action {
                Button(action: action) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.plain)
                .contentTransition(.symbolEffect(.automatic))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
} 