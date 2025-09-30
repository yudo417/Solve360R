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
                        Text("Remaining Time：") .font(.title)
                            .foregroundStyle(.black)
                        Text(String(format: " %.1f", timeRemaining)) .font(.title)
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
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 2, y: 4)
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
                        .overlay{
                            Capsule()
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
                        }
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 2, y: 4)
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
#Preview{
    ResultView(vm: ARViewModel(), path: .constant([]))
}


