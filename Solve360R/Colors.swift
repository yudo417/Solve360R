
import Foundation
import SwiftUI

class Colors {
    static let background:  some View = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.1, green: 0.2, blue: 0.4),
            Color(red: 0.2, green: 0.4, blue: 0.8),
            Color(red: 0.4, green: 0.6, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    .ignoresSafeArea()


}
