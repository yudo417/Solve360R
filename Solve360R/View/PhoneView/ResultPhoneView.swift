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
                .frame(width: 550, height: 300)
                .shadow(color: Color(red: 0.3, green: 0.4, blue: 0.6).opacity(0.3), radius: 30, x: 0, y: 15)

            VStack(spacing: 20) {
                // 上部: トロフィー＆スコア
                HStack(spacing: 40) {
                    // 左: トロフィー（アイキャッチ）
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
                    
                    // 右: スコア情報（メインコンテンツ）
                    VStack(alignment: .center, spacing: 6) {
                        Text("GAME Finished!")
                            .font(.system(size: 30, weight: .black, design: .rounded))
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
                                Text("GAME Finished!")
                                    .font(.system(size: 30, weight: .black, design: .rounded))
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
                        
                        HStack(alignment: .firstTextBaseline, spacing: 22) {
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
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                                .offset(y: -10)
                        }
                        
                        Text(evaluationMessage)
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.35, green: 0.45, blue: 0.6))
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
                        Image(systemName: "house.fill")
                            .font(.system(size: 26))
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
                                        Color(red: 0.35, green: 0.55, blue: 0.85),
                                        Color(red: 0.45, green: 0.35, blue: 0.75)
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
                                                Color.white.opacity(0.35),
                                                Color.clear
                                            ],
                                            startPoint: .top,
                                            endPoint: .center
                                        )
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
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
                            .shadow(color: Color(red: 0.35, green: 0.45, blue: 0.75).opacity(0.5), radius: 20, x: 0, y: 10)
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
            return "Why? Used cheat…？？?"
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
