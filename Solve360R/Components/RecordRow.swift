import SwiftUI

struct RecordRow: View {
    let recordRank: String
    let recordScore: String
    let recordDate:Date?
    let isMedalRecord: Bool = false
    let scoreStartPointX: Double = 0
    var body: some View {
        HStack(spacing: 0) {

            ZStack {
                // 洗練されたグラデーション背景
                rankPath
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.25, green: 0.2, blue: 0.35),
                                Color(red: 0.15, green: 0.1, blue: 0.25)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    // 微妙なハイライト効果
                    .overlay(
                        rankPath
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.2),
                                        Color.clear
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
                    // 洗練された影
                    .shadow(color: Color.black.opacity(0.9), radius: 10, x: 0, y: 2)

                HStack(spacing: 12) {
                    Spacer()
                    if (recordRank == "1" || recordRank == "2" || recordRank == "3"){
                        Image(systemName: "crown")
                            .foregroundStyle(rankColor)
                            .font(.system(size: 35))
                    }
                    Text("\(recordRank)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(rankColor)
                        .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 2)
                }
                .padding(.horizontal, 25)
            }
            .frame(width: 200, height: 100)
//            .border(.red)

            ZStack {
            scorePath
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.75, green: 0.85, blue: 0.95),
                            Color(red: 0.55, green: 0.75, blue: 0.85)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                // ハイライト効果
                .overlay(
                    scorePath
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.4),
                                    Color.clear
                                ]),
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                )
                // 洗練された影
                .shadow(color: Color.blue.opacity(0.9), radius: 20, x: 0, y: 2)

                VStack(spacing: 3) {
                    Text("\(recordScore)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.black)
                        .shadow(color: Color.white.opacity(0.3), radius: 1, x: 0, y: 1)
                }
                .padding(.horizontal, 25)
                .offset(x: 40)
            }
            .frame(width: 400, height: 100)
//            .border(.red)

            ZStack {
            datePath
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.88, green: 0.9, blue: 0.95),
                            Color(red: 0.7, green: 0.75, blue: 0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                // ハイライト効果
                .overlay(
                    datePath
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.4),
                                    Color.clear
                                ]),
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                )
                // 洗練された影
                .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 2)

                VStack(spacing: 3) {
                    Text("\(outputDate ?? "---")")
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(red: 0.05, green: 0.05, blue: 0.1))
                        .shadow(color: Color.white.opacity(0.2), radius: 1, x: 0, y: 1)
                }
                .padding(.horizontal, 18)
            }
            .frame(width: 400, height: 100)

        }
        .frame(height: 100)
    }

}


extension RecordRow {

    var outputDate: String?{
        if let recordDate = recordDate{
            let df = DateFormatter()
            df.dateFormat = "yyyy / MM / dd"
            return df.string(from:recordDate)
        }else {
            return nil
        }
    }

    var rankColor: Color {
        switch recordRank {
        case "1": return Color.first
        case "2": return Color.second
        case "3": return Color.third
        default: return Color.white
        }
    }

    //MARK: - UIここから

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
        path.addLine(to: CGPoint(x: 300, y: 0))
        path.addLine(to: CGPoint(x: 300, y: 100))
        path.closeSubpath()
        path.addArc(center: CGPoint(x: 300, y: 50), radius: 50, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: true)
        return path
    }
}

#Preview {
    RecordRow(recordRank: "1", recordScore: "1", recordDate: Date())
}
