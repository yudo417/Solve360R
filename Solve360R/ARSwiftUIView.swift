

import SwiftUI
import AVFoundation
import Combine

struct NumberButton:Identifiable {
    let id = UUID()
    var isselected:Bool
    var number :Int

}

struct ARSwiftUIView: View {

    @State var numberbutton:[NumberButton] = (1...9).map{ NumberButton(isselected: false, number: $0) }
    @State var selectedNumber:Int = 0
    @ObservedObject var vm : ARViewModel
    @State var nowlife : Int = 3
    @State private var timer : Timer?
    @State private var timeRemaining: Float = 30
    @Binding var isGameStarted :Bool
    @Binding var isGameFinished :Bool
    @Binding var recordCount :Int

    let buttonGradient = Gradient(stops: [
        .init(color: Color.white.opacity(0.8), location: 0.0),
        .init(color: Color.cyan.opacity(0.8), location: 0.7),
        .init(color: Color.blue.opacity(0.8), location: 1.0),
    ])
    let buttonSelectedGradient = Gradient(stops: [
        .init(color: Color(red: 0.0, green: 0.3, blue: 0.6).opacity(1.0), location: 0.0), // 濃いブルー
        .init(color: Color(red: 0.0, green: 0.5, blue: 0.8).opacity(1.0), location: 0.5), // 中間のブルー
        .init(color: Color(red: 0.0, green: 0.7, blue: 1.0).opacity(1.0), location: 1.0)  // 鮮やかなシアン
    ])
    let answerGradient = Gradient(stops: [
        .init(color: Color(red:0.0,green:0.7,blue:1.0).opacity(0.8),location:0.0),
        .init(color: Color(red:0.0,green:0.4,blue:0.8).opacity(0.8),location:0.4),
        .init(color: Color(red:0.0,green:0.4,blue:0.75).opacity(0.8),location:0.5),
        .init(color: Color(red:0.0,green:0.4,blue:0.8).opacity(0.8),location:0.6),
        .init(color: Color(red:0.0,green:0.7,blue:1.0).opacity(0.8),location:1.0),
    ])

    //-MARK: ContentView
    var body: some View {

        VStack{
            HStack{
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.white)
                        .opacity(0.5)
                    HStack{
                        Text("Remaining Life").foregroundStyle(.black)
                        HStack{
                            ForEach(0..<nowlife,id:\.self) { _ in
                                Image(systemName: "heart.fill").foregroundStyle(.red)
                            }
                            ForEach(nowlife..<3,id:\.self) { _ in
                                Image(systemName: "heart").foregroundStyle(.red)
                            }
                        }
                    }
                }.frame(width: 400, height: 60)
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.white)
                        .opacity(0.5)
                    HStack{
                        Image(systemName: "clock").foregroundStyle(.black)
                        Text(String(format: "Remaining Time: %.1f", timeRemaining)) .font(.title)
                            .foregroundStyle(.black)
                    }
                }.frame(width: 400, height: 60)
                    .padding()
                Spacer()
            }.font(.title)
                .padding(.top,20)
            Spacer()
            ZStack{
                RoundedRectangle(cornerRadius: 60)
                    .foregroundStyle(.white)
                    .frame(height: 300)
                    .opacity(0.5)
                    .overlay {
                        VStack(spacing:20){
                            numberButton
                            answerButton
                        }
                        .padding()
                    }
            }
            .padding(50)
        }
        .onAppear { // ビューが表示されたらタイマー開始
                    startTimer()
                }
        .onReceive(Timer.publish(every: 0.08, on: .main, in: .common).autoconnect()) { _ in
            if isGameStarted && !isGameFinished && timeRemaining > 0 {
                if timeRemaining != 0 {
                    timeRemaining -= 0.1
                }
                    } else if isGameStarted && !isGameFinished && timeRemaining <= 0 {
                        handleTimeUp()
                    }
                }
        .onChange(of: isGameStarted) { oldValue, newValue in
            if newValue{
                startTimer()
            }
        }

    }
    @MainActor
       private func startTimer() {
           timeRemaining = 60
       }
//    @MainActor
//    private func stopTimer() {
//            timer?.invalidate()
//            timer = nil
//        }
    @MainActor
    private func handleTimeUp() {
//           stopTimer()
           print("時間切れ！ゲームオーバー")
        finishAction()
//           startTimer() // 再スタート
       }

}



extension ARSwiftUIView {
    private var numberButton :some View{
        HStack{
            ForEach(numberbutton){nb in
                Button {
                    numberbutton.map{numberbutton[$0.number - 1].isselected = false}
                    numberbutton[nb.number - 1].isselected = true
                    vm.selectedNumber = nb.number

                } label: {
                    ZStack{
                        if nb.isselected{
                            Circle()
                                .scale(1.1)
                                .fill(
                                    LinearGradient(gradient: buttonSelectedGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .overlay(Circle().scale(1.1).stroke(Color.blue,lineWidth:5))
                            Text("\(nb.number)")
                                .font(.system(size: 85))
                                .foregroundStyle(.white)
                                .fontWeight(.heavy)
                        }else{
                            Circle()
                                .fill(
                                    LinearGradient(gradient: buttonGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                            Text("\(nb.number)")
                                .font(.system(size: 60))
                                .foregroundStyle(.white)
                                .fontWeight(.heavy)
                        }

                    }
                    .padding(.horizontal,3)
                }.buttonStyle(.plain)


            }
        }
        .padding(.bottom,10)
    }

    private var answerButton : some View{
        Button{//Answer Button
            print("Selected Number : \(vm.selectedNumber)")
            print("Generated Number : \(vm.generatedAnswer)")
            vm.compareNumber()
            judgeHP()
            if !(vm.selectedNumber == 0){
                withAnimation(.easeIn) {
                    numberbutton[vm.selectedNumber - 1].isselected = false
                }
            }
            vm.selectedNumber = 0
            print(nowlife)
            print(vm.isCorrect)
            // HPが1かつ不正解のときはブロック生成をスルー
//                NotificationCenter.default.post(name: .genereteBox, object: nil)

        } label: {
            if numberbutton.allSatisfy{ !$0.isselected }{
                ZStack{
                    Capsule()
                        .fill(
                            LinearGradient(gradient: answerGradient, startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: 250, height: 100)
                        .overlay(Capsule().stroke(Color.blue,lineWidth:4))
                    Text("Answer")
                        .foregroundStyle(.white)
                        .font(.system(size: 50))
                }
            }else{
                ZStack{
                    Capsule()
                        .fill(
                            LinearGradient(gradient: answerGradient, startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: 250, height: 100)
                        .overlay(Capsule().stroke(Color.blue,lineWidth:4))
                    Text("Answer")
                        .foregroundStyle(.white)
                        .font(.system(size: 50))
                }.offset(y:-17.5)
            }
        }.buttonStyle(.plain)
            .frame(width: 300,height: 100)
    }

    func judgeHP(){
        if (!(vm.isCorrect ?? false)) && nowlife == 1{
            print("gameOver")

            nowlife -= 1
            self.finishAction()

        }else if !(vm.isCorrect ?? false){
            vm.coordinator?.OutSound()
            nowlife -= 1
            NotificationCenter.default.post(name: .genereteBox, object: nil)
        }else{
            vm.coordinator?.OkSound()
            vm.recordcount += 1
            print("OK")
            NotificationCenter.default.post(name: .genereteBox, object: nil)
        }
    }

    private func finishAction() {
        isGameFinished = true
        NotificationCenter.default.post(name: .finishGame, object: nil)
    }



}

struct resultView:View{
    @ObservedObject var vm : ARViewModel
    @Binding var path:[Screen]
    @State private var isAnimating = false
    @State private var showConfetti = false
    
    var body: some View{
        ZStack {
            // 美しいグラデーション背景
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.3, blue: 0.6),
                    Color(red: 0.3, green: 0.5, blue: 0.9),
                    Color(red: 0.5, green: 0.7, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // 装飾的な背景要素
            VStack {
                ForEach(0..<8) { i in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 60 + CGFloat(i * 15), height: 60 + CGFloat(i * 15))
                        .offset(
                            x: isAnimating ? 100 : -100,
                            y: isAnimating ? -50 : 50
                        )
                        .animation(
                            Animation.easeInOut(duration: 4)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.1),
                            value: isAnimating
                        )
                }
            }
            
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
                            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                        
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
                                    .foregroundColor(.primary)
                                
                                Text("Your Score")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                    .fontWeight(.medium)
                                
                                // スコア表示
                                HStack(spacing: 15) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.orange, Color.red]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 80, height: 80)
                                        
                                        Text("\(vm.recordcount)")
                                            .font(.system(size: 36, weight: .black, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Correct")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                        Text("Answers")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                // 評価メッセージ
                                Text(evaluationMessage)
                                    .font(.title3)
                                    .foregroundColor(.primary)
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
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                
                Spacer()
                
                // フッター情報
                HStack(spacing: 15) {
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("Great job solving AR math puzzles!")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.horizontal, 40)
        }
        .onAppear {
            isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showConfetti = true
            }
        }
    }
    
    // スコアに基づく評価メッセージ
    private var evaluationMessage: String {
        switch vm.recordcount {
        case 0...2:
            return "Keep practicing! AR math gets easier with time."
        case 3...5:
            return "Good effort! You're getting the hang of it."
        case 6...8:
            return "Excellent work! You're a math puzzle master!"
        case 9...:
            return "Incredible! You're absolutely unstoppable!"
        default:
            return "Amazing job solving AR math puzzles!"
        }
    }
}
