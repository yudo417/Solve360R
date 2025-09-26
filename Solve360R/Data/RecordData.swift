
import SwiftUI
import SwiftData

@Model
class Record{

    init(score: String, date: Date) {
        self.score = score
        self.date = date
    }

    var score: String
    var date: Date

}
