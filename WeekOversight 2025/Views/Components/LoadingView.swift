import SwiftUI

struct LoadingView: View {
    let message: String
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text(message)
                .font(.callout)
                .foregroundStyle(.secondary)
                .opacity(isAnimating ? 0.6 : 1.0)
        }
        .onAppear {
            withAnimation(AppAnimation.standard.repeatForever()) {
                isAnimating = true
            }
        }
    }
} 