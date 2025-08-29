import Foundation
import SwiftUI
import Combine

class ARViewModel: NSObject, ObservableObject {
    var coordinator: ARViewContainer.Coordinator?

     var selectedNumber: Int = 0 // SwiftUI側で更新
     var generatedAnswer: Int = 0 // Coordinator側で更新
     var isCorrect: Bool? = nil // 結果
    var recordcount = 0

    @MainActor
    func compareNumber() {
        guard selectedNumber != 0 else {
            isCorrect = nil
            return
        }
        isCorrect = (selectedNumber == generatedAnswer)
        print("result=　\(isCorrect  ?? false)")
    }
}
