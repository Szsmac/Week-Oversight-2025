import SwiftUI

enum AppAnimation {
    static let standard = Animation.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.3)
    static let slow = Animation.spring(response: 0.5, dampingFraction: 0.86, blendDuration: 0.4)
    static let quick = Animation.spring(response: 0.25, dampingFraction: 0.75, blendDuration: 0.2)
    
    static let transition = AnyTransition.asymmetric(
        insertion: .opacity.combined(with: .move(edge: .trailing)).animation(.spring(response: 0.35, dampingFraction: 0.85)),
        removal: .opacity.combined(with: .move(edge: .leading)).animation(.spring(response: 0.3, dampingFraction: 0.8))
    )
    
    static let sheetTransition = AnyTransition.asymmetric(
        insertion: .move(edge: .bottom).combined(with: .opacity),
        removal: .move(edge: .bottom).combined(with: .opacity)
    )
    
    static let fadeTransition = AnyTransition.opacity.animation(.easeInOut(duration: 0.2))
    
    static func slideTransition(edge: Edge) -> AnyTransition {
        .asymmetric(
            insertion: .move(edge: edge).combined(with: .opacity).animation(.spring(response: 0.35, dampingFraction: 0.85)),
            removal: .move(edge: edge).combined(with: .opacity).animation(.spring(response: 0.3, dampingFraction: 0.8))
        )
    }
} 