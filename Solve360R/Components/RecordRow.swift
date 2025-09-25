import SwiftUI

struct RecordRow: View {
    let df = DateFormatter()
    let recordRank: String
    let recordScore: String
    let recordDate: Date
    let scoreStartPointX: Double = 0
    var body: some View {
        HStack(spacing: 0) {

            ZStack {
                rankPath
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.15, green: 0.15, blue: 0.25),
                                Color(red: 0.1, green: 0.1, blue: 0.2)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                VStack(spacing: 5) {
                    Text("\(recordRank)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.95, green: 0.8, blue: 0.6))

                }
                .padding(.horizontal, 20)
            }
            .frame(width: 200, height: 100)

            ZStack {
                scorePath
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.95, green: 0.7, blue: 0.5),
                                Color(red: 0.9, green: 0.5, blue: 0.3)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                VStack(spacing: 5) {
                    Text("\(recordScore)")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(Color(red: 0.2, green: 0.1, blue: 0.05))

                }
                .padding(.horizontal, 30)
            }
            .frame(width: 500, height: 100)

            ZStack {
                datePath
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.8, green: 0.75, blue: 0.9),
                                Color(red: 0.6, green: 0.65, blue: 0.85)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                VStack(spacing: 5) {
                    Text("\(recordDate)")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(red: 0.95, green: 0.9, blue: 0.98))

                }
                .padding(.horizontal, 20)
            }
            .frame(width: 300, height: 100)

        }
        .frame(height: 100)
    }

}


extension RecordRow {

    var rankPath: Path { // 左上から時計回り
        var path = Path()
        path.move(to: CGPoint(x: 300, y: 0))
        path.addLine(to: CGPoint(x: 100, y: 0))
        path.addArc(center: CGPoint(x: 100, y: 50), radius: 50, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: 100, y: 100))
        path.addLine(to: CGPoint(x: 200, y: 100))
        path.closeSubpath()
        return path
    }

    var scorePath: Path { // 左下から時計回り
        var path = Path()
        path.move(to: CGPoint(x: scoreStartPointX, y: 100))
        path.addLine(to: CGPoint(x: scoreStartPointX + 100, y: 0))
        path.addLine(to: CGPoint(x: scoreStartPointX + 600, y: 0))
        path.addLine(to: CGPoint(x: scoreStartPointX + 500, y: 100))
        path.closeSubpath()
        return path
    }

    var datePath: Path { // 左下から時計回り
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 100))
        path.addLine(to: CGPoint(x: 100, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 100))
        path.closeSubpath()
        path.addArc(center: CGPoint(x: 200, y: 50), radius: 50, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: true)
        return path
    }
}

#Preview {
    RecordRow(recordRank: "1", recordScore: "1", recordDate: Date())
}
