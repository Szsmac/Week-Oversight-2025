import SwiftUI

struct DeleteConfirmationSheet: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    let title: String
    let message: String
    let onConfirm: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
            
            Text(message)
                .foregroundStyle(.secondary)
            
            HStack {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .keyboardShortcut(.escape)
                
                Button("Delete", role: .destructive) {
                    onConfirm()
                    dismiss()
                }
                .keyboardShortcut(.return)
            }
        }
        .padding()
        .frame(width: 300)
    }
} 