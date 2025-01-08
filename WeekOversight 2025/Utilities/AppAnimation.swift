import SwiftUI

enum AppAnimation {
    static let standard = Animation.spring(response: 0.3, dampingFraction: 0.8)
    static let slow = Animation.spring(response: 0.5, dampingFraction: 0.8)
    static let quick = Animation.spring(response: 0.2, dampingFraction: 0.7)
    
    static let transition = AnyTransition.opacity.combined(with: .move(edge: .trailing))
    static let sheetTransition = AnyTransition.move(edge: .bottom).combined(with: .opacity)
    static let fadeTransition = AnyTransition.opacity
    
    static func slideTransition(edge: Edge) -> AnyTransition {
        .asymmetric(
            insertion: .move(edge: edge).combined(with: .opacity),
            removal: .move(edge: edge).combined(with: .opacity)
        )
    }
} 