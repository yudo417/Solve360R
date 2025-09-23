
import Foundation
import SwiftUI

class Colors {
    static let background:  some View = LinearGradient( // 背景テーマ
        gradient: Gradient(colors: [
            Color(red: 0.1, green: 0.3, blue: 0.6),
            Color(red: 0.3, green: 0.5, blue: 0.9),
            Color(red: 0.5, green: 0.7, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    .ignoresSafeArea()


}
