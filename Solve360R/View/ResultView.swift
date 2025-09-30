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
                                        Color.white.opacity(0.9),
                                        Color.white.opacity(0.7)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 350, height: 400)
                            .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)

                        VStack(spacing: 25) {
                            // 結果アイコン
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.green, Color.blue]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                    .shadow(color: .green.opacity(0.5), radius: 15, x: 0, y: 8)

                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            }
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )

                            // 結果テキスト
                            VStack(spacing: 15) {
                                Text("Game Complete!")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.blue.opacity(0.8))

                                Text("Your Score")
                                    .font(.title2)
                                    .foregroundColor(.purple.opacity(0.7))
                                    .fontWeight(.medium)

                                // スコア表示
//                                HStack(spacing: 20) {
//                                    VStack(spacing: 5) {
                                        Text("\(animatedScore)")
                                            .font(.system(size: 60, weight: .bold, design: .rounded))
                                            .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.1))
                                            .contentTransition(.numericText(countsDown: false))
                                            .animation(.spring(response: 0.4, dampingFraction: 0.9), value: animatedScore)
                                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                                            .animation(.bouncy(duration: 1.0, extraBounce: 0.7).repeatForever(autoreverses: false), value: isAnimating)



//                                    }
//                                }

                                // 評価メッセージ
                                Text(evaluationMessage)
                                    .font(.system(size: 20, weight: .medium, design: .serif))
                                    .foregroundColor(.black.opacity(0.8))
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
                                            Color.blue,
                                            Color.purple
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 280, height: 70)
                                .shadow(color: .blue.opacity(0.5), radius: 15, x: 0, y: 8)

                            HStack(spacing: 12) {
                                Image(systemName: "house.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)

                                Text("Back to Title")
                                    .font(.system(size: 24, weight: .semibold, design: .serif))
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
            return "Used cheat…？？?"
        default:
            return "Finished!"
        }
    }
}
