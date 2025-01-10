import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .controlSize(.large)
            Text("Loading...")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    LoadingView()
} 