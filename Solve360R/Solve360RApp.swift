
import SwiftUI
import SwiftData

@main
struct Solve360RApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: RecordData.self)
    }
}
