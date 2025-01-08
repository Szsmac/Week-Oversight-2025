import SwiftUI

struct ValidatedTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let validation: (String) throws -> Void
    
    @State private var isValid = true
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.callout)
                .foregroundStyle(.secondary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .onChange(of: text) { _, newValue in
                    validateInput(newValue)
                }
            
            if !isValid {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .animation(.easeInOut, value: isValid)
    }
    
    private func validateInput(_ value: String) {
        do {
            try validation(value)
            isValid = true
            errorMessage = ""
        } catch {
            isValid = false
            errorMessage = error.localizedDescription
        }
    }
} 