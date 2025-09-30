
import SwiftUI

struct IsUtils {
    static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
