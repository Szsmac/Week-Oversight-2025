import SwiftUI

struct SafeSymbol: View {
    let name: String
    var size: CGFloat = 32
    var color: Color = .accentColor
    
    var body: some View {
        Group {
            if let image = NSImage(systemSymbolName: name, accessibilityDescription: nil) {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .foregroundColor(color)
            } else {
                Color.clear
                    .frame(width: size, height: size)
            }
        }
    }
} 