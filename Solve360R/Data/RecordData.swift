
import SwiftUI
import SwiftData

@Model
class RecordData{

    init(score: Int, date: Date) {
        self.score = score
        self.date = date
    }

    var score: Int
    var date: Date

}
