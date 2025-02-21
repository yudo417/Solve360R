import Foundation

class ARViewModel: NSObject, ObservableObject {
    var coordinator: ARViewContainer.Coordinator?

    @Published var selectedNumber: Int = 0 // SwiftUI側で更新
    @Published var generatedAnswer: Int = 0 // Coordinator側で更新
    @Published var isCorrect: Bool? = nil // 結果

    @MainActor
    func compareNumber() {
        guard selectedNumber != 0 else {
            isCorrect = nil
            return
        }
        isCorrect = (selectedNumber == generatedAnswer)
        print("Compared: selected=\(selectedNumber), answer=\(generatedAnswer), result=\(isCorrect ?? false)")
    }
}
