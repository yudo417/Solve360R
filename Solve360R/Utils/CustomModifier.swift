
import SwiftUI

struct ScaleModifier: ViewModifier {
    let geometry: GeometryProxy
    let frameWidth: CGFloat
    let frameheight: CGFloat
    let scalex: CGFloat?
    let scaley: CGFloat?

    func body(content: Content) -> some View{
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let scalex = scalex, let scaley = scaley {
                content
                    .scaleEffect(x: scalex, y: scaley)
                    .frame(width: geometry.size.width * frameWidth, height: geometry.size.height * frameheight)
            }else if let scalex = scalex {
                content
                    .scaleEffect(x: scalex)
                    .frame(width: geometry.size.width * frameWidth, height: geometry.size.height * frameheight)


            }else if let scaley = scaley {
                content
                    .scaleEffect( y: scaley)
                    .frame(width: geometry.size.width * frameWidth, height: geometry.size.height * frameheight)
            }
        }else {
            content
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension View {
    func scaleModifier(geometry: GeometryProxy, frameWidth: CGFloat , frameheight: CGFloat, scalex: CGFloat? = nil, scaley: CGFloat? = nil) -> some View {
        self.modifier(ScaleModifier(geometry: geometry, frameWidth: frameWidth, frameheight: frameheight, scalex: scalex, scaley: scaley))
    }
}
