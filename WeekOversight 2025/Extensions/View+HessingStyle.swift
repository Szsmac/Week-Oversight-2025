import SwiftUI

struct HessingStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.hessingBackground)
            .tint(Color.hessingGreen)
    }
}

extension View {
    func hessingStyle() -> some View {
        modifier(HessingStyleModifier())
    }
} 