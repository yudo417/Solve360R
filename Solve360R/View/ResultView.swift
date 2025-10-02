import SwiftUI
import SwiftData

struct ResultView:View{
    @ObservedObject var vm : ARViewModel
    @Environment(\.modelContext) var modelContext
    @Query(sort: \RecordData.score,order: .reverse) var records: [RecordData]
    @Binding var path:[Screen]
    @State private var isAnimating = false
    @State private var showConfetti = false
    @State private var animatedScore = 0

    var body: some View{
        ZStack {
            Colors.background


            VStack(spacing: 40) {
                Spacer()

                // 結果カード
                VStack(spacing: 30) {
                    // メインカード
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.95, green: 0.97, blue: 1.0).opacity(0.95),
                                        Color(red: 0.88, green: 0.92, blue: 0.98).opacity(0.85)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.8),
                                                Color(red: 0.7, green: 0.8, blue: 0.95).opacity(0.5)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .frame(width: 350, height: 400)
                            .shadow(color: Color(red: 0.3, green: 0.4, blue: 0.6).opacity(0.3), radius: 30, x: 0, y: 15)

                        VStack(spacing: 25) {
                            // 結果アイコン
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 1.0, green: 0.85, blue: 0.3),
                                                Color(red: 0.95, green: 0.65, blue: 0.2)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        Color.white.opacity(0.8),
                                                        Color(red: 1.0, green: 0.9, blue: 0.5).opacity(0.6)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 3
                                            )
                                    )
                                    .shadow(color: Color(red: 1.0, green: 0.7, blue: 0.2).opacity(0.5), radius: 25, x: 0, y: 10)

                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                                    .shadow(color: Color(red: 0.8, green: 0.5, blue: 0.1).opacity(0.4), radius: 4, x: 0, y: 3)
                            }
                            .scaleEffect(isAnimating ? 1.15 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )

                            // 結果テキスト
                            VStack(spacing: 15) {
                                Text("GAME Finished!")
                                    .font(.system(size: 32, weight: .black, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.2, green: 0.5, blue: 0.95),
                                                Color(red: 0.35, green: 0.25, blue: 0.75)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .tracking(2.2)
                                    .shadow(color: Color(red: 0.3, green: 0.5, blue: 0.9).opacity(0.5), radius: 5, x: 0, y: 3)
                                    .overlay(
                                        Text("GAME Complete!")
                                            .font(.system(size: 32, weight: .black, design: .rounded))
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [
                                                        Color.white.opacity(0.4),
                                                        Color.clear
                                                    ],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .tracking(2.2)
                                            .blendMode(.overlay)
                                    )

                                HStack(spacing: 24){


                                    // スコア表示
                                    Text("\(animatedScore)")
                                        .font(.system(size: 60, weight: .bold, design: .rounded))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.95, green: 0.5, blue: 0.15),
                                                    Color(red: 0.85, green: 0.35, blue: 0.1)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .contentTransition(.numericText(countsDown: false))
                                        .animation(.spring(response: 0.4, dampingFraction: 0.9), value: animatedScore)
                                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                                        .animation(.bouncy(duration: 2.0, extraBounce: 0.7).repeatForever(autoreverses: false), value: isAnimating)
                                        .shadow(color: Color(red: 0.9, green: 0.4, blue: 0.1).opacity(0.3), radius: 4, x: 0, y: 3)

                                    Text("pts")
                                        .font(.title2)
                                        .foregroundStyle(.black)
                                        .fontWeight(.medium)
                                }

                                // 評価メッセージ
                                Text(evaluationMessage)
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                    .foregroundColor(Color(red: 0.35, green: 0.45, blue: 0.6))
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .padding(30)
                    }

                    // アクションボタン
                    Button {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            path = []
                            vm.recordcount = 0
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.35, green: 0.55, blue: 0.85),
                                            Color(red: 0.45, green: 0.35, blue: 0.75)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.35),
                                                    Color.clear
                                                ],
                                                startPoint: .top,
                                                endPoint: .center
                                            )
                                        )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.6),
                                                    Color(red: 0.6, green: 0.7, blue: 0.9).opacity(0.4)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 2
                                        )
                                )
                                .frame(width: 280, height: 70)
                                .shadow(color: Color(red: 0.35, green: 0.45, blue: 0.75).opacity(0.5), radius: 20, x: 0, y: 10)

                            HStack(spacing: 12) {
                                Image(systemName: "house.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)

                                Text("Back to Title")
                                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .buttonStyle(ScaleButtonStyle())
                }

                Spacer()

                // フッター情報
//                HStack(spacing: 15) {
//                    Image(systemName: "sparkles")
//                        .font(.caption)
//                        .foregroundColor(.purple.opacity(0.7))
//
//                    Text("Great job solving AR math puzzles!")
//                        .font(.caption)
//                        .foregroundColor(.purple.opacity(0.7))
//                }
            }
            .padding(.horizontal, 40)
        }
        .onAppear {

            isAnimating = true

            // スコアを0にリセット
            animatedScore = 0

            // 少し遅れてカウントアップアニメーションを開始
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showConfetti = true
                // withAnimation を使って animatedScore を目標値まで変化させる
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    animatedScore = vm.recordcount
                    self.updateRecords()
                }
            }
        }
    }

    private func updateRecords(){
        print("a")
        print("animatedscore:\(animatedScore)")
        if animatedScore > 0 {
            if records.count < 10{
                modelContext.insert(RecordData(score: animatedScore, date: Date()))
                print("データが追加された")
            }else if records[9].score < animatedScore {
                modelContext.insert(RecordData(score: animatedScore, date: Date()))
            }
        }
        print("b")

    }
    // スコアに基づく評価メッセージ
    private var evaluationMessage: String {
        switch vm.recordcount {
        case 0...2:
            return "Keep practicing…!"
        case 3...5:
            return "Good effort!"
        case 6...8:
            return "Excellent work!!"
        case 9...10:
            return "Amazing job!!"
        case 11...19:
            return "🎉 Incredible!! 🎉"
        case 20...:
            return "Why? Used cheat…？？?"
        default:
            return "Finished!"
        }
    }
}
