import SwiftUI

struct ValidatedTextField: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    let validation: (String) -> Bool
    
    @State private var isValid = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(title, text: $text, prompt: Text(placeholder))
                .textFieldStyle(.roundedBorder)
                .onChange(of: text) { newValue in
                    withAnimation {
                        isValid = validation(newValue)
                    }
                }
            
            if !isValid {
                Text("Please enter a valid \(title.lowercased())")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    Form {
        ValidatedTextField(
            text: .constant(""),
            title: "Name",
            placeholder: "Enter name",
            validation: { !$0.isEmpty }
        )
    }
} 