import SwiftUI
import SwiftData

struct ResultPhoneView: View {
    @ObservedObject var vm: ARViewModel
    @Environment(\.modelContext) var modelContext
    @Query(sort: \RecordData.score, order: .reverse) var records: [RecordData]
    @Binding var path: [Screen]
    @State private var isAnimating = false
    @State private var showConfetti = false
    @State private var animatedScore = 0

    var body: some View {
        ZStack {
            Colors.background

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
                .frame(width: 550, height: 300)
                .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)

            VStack(spacing: 20) {
                // 上部: トロフィー＆スコア
                HStack(spacing: 40) {
                    // 左: トロフィー（アイキャッチ）
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 1.0, green: 0.88, blue: 0.25),
                                        Color(red: 1.0, green: 0.65, blue: 0.15)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.6), lineWidth: 4)
                            )
                            .shadow(color: Color.yellow.opacity(0.7), radius: 20, x: 0, y: 8)

                        Image(systemName: "trophy.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                    .scaleEffect(isAnimating ? 1.15 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                    
                    // 右: スコア情報（メインコンテンツ）
                    VStack(alignment: .center, spacing: 6) {
                        Text("GAME Complete!")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.blue.opacity(0.8))
                            .tracking(2)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 16) {
                            Text("\(animatedScore)")
                                .font(.system(size: 60, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.1))
                                .contentTransition(.numericText(countsDown: false))
                                .animation(.spring(response: 0.4, dampingFraction: 0.9), value: animatedScore)
                                .scaleEffect(isAnimating ? 1.2 : 1.0)
                                .animation(.bouncy(duration: 2.0, extraBounce: 0.7).repeatForever(autoreverses: false), value: isAnimating)

                            Text("pts")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.85))
                                .offset(y: -10)
                        }
                        
                        Text(evaluationMessage)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                            .lineLimit(1)
                    }
                    .frame(minWidth: 280)
                }
                
                // 下部: HOMEボタン（中央配置）
                Button {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        path = []
                        vm.recordcount = 0
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "house.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                        
                        Text("BACK TO HOME")
                            .font(.system(size: 16, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .tracking(1.2)
                    }
                    .frame(width: 240, height: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.48, green: 0.68, blue: 1.0),
                                        Color(red: 0.58, green: 0.38, blue: 0.95)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.4),
                                                Color.clear
                                            ],
                                            startPoint: .top,
                                            endPoint: .center
                                        )
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                            )
                            .shadow(color: .blue.opacity(0.7), radius: 20, x: 0, y: 10)
                    )
                }
                .buttonStyle(ScaleButtonStyle())
            }
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

    private func updateRecords() {
        print("a")
        print("animatedscore:\(animatedScore)")
        if animatedScore > 0 {
            if records.count < 10 {
                modelContext.insert(RecordData(score: animatedScore, date: Date()))
                print("データが追加された")
            } else if records[9].score < animatedScore {
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

#Preview {
    ResultPhoneView(
        vm: ARViewModel(),
        path: .constant([])
    )
}
