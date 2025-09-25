import SwiftUI

struct RecordRow: View {
    let scoreStartPointX: Double = 0
    var body: some View {
        HStack(spacing:0) {

            rankPath
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.1, green: 0.2, blue: 0.4), .gray.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 200, height: 100)


            scorePath
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.yellow,.yellow.opacity(0.8),.red]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 500, height: 100)


            datePath
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.gray.opacity(0.7), .gray.opacity(0.4)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
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
    RecordRow()
}
