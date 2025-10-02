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
        .init(color: Color(red: 0.0, green: 0.3, blue: 0.6).opacity(1.0), location: 0.0),
        .init(color: Color(red: 0.0, green: 0.5, blue: 0.8).opacity(1.0), location: 0.5),
        .init(color: Color(red: 0.0, green: 0.7, blue: 1.0).opacity(1.0), location: 1.0)
    ])
    let answerGradientActive = Gradient(stops: [
        .init(color: Color(red:0.1,green:0.8,blue:1.0).opacity(1.0),location:0.0),
        .init(color: Color(red:0.0,green:0.6,blue:1.0).opacity(1.0),location:0.5),
        .init(color: Color(red:0.1,green:0.8,blue:1.0).opacity(1.0),location:1.0),
    ])
    let answerGradientInactive = Gradient(stops: [
        .init(color: Color(red:0.3,green:0.5,blue:0.8).opacity(0.7),location:0.0),
        .init(color: Color(red:0.2,green:0.4,blue:0.7).opacity(0.7),location:0.5),
        .init(color: Color(red:0.3,green:0.5,blue:0.8).opacity(0.7),location:1.0),
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
                                .fill(
                                    LinearGradient(gradient: buttonSelectedGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .scaleEffect(1.1)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.white.opacity(0.6),
                                                    Color.cyan.opacity(0.8)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 5
                                        )
                                        .scaleEffect(1.1)
                                )
                                .shadow(color: Color.cyan.opacity(0.6), radius: 15, x: 0, y: 0)
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 2, y: 4)
                                .overlay(
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                gradient: Gradient(colors: [
                                                    Color.white.opacity(0.3),
                                                    Color.clear
                                                ]),
                                                center: .topLeading,
                                                startRadius: 5,
                                                endRadius: 50
                                            )
                                        )
                                        .scaleEffect(1.1)
                                )
                            Text("\(nb.number)")
                                .font(.system(size: 85))
                                .foregroundStyle(.white)
                                .fontWeight(.heavy)
                                .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
                        }else{
                            Circle()
                                .fill(
                                    LinearGradient(gradient: buttonGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                        .blur(radius: 1)
                                )
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 2, y: 4)
                                .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 0)
                                .overlay(
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                gradient: Gradient(colors: [
                                                    Color.white.opacity(0.25),
                                                    Color.clear
                                                ]),
                                                center: .topLeading,
                                                startRadius: 5,
                                                endRadius: 40
                                            )
                                        )
                                )
                            Text("\(nb.number)")
                                .font(.system(size: 60))
                                .foregroundStyle(.white)
                                .fontWeight(.heavy)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        }

                    }
                    .padding(.horizontal,3)
                }.buttonStyle(.plain)
//                    .border(.red)


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
            let isSelected = !numberbutton.allSatisfy{ !$0.isselected }
            ZStack{
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: isSelected ? answerGradientActive : answerGradientInactive,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 250, height: 100)
                    .overlay(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: isSelected ? [
                                        Color.white.opacity(0.6),
                                        Color.cyan.opacity(0.9),
                                        Color.white.opacity(0.6)
                                    ] : [
                                        Color.blue.opacity(0.4),
                                        Color.blue.opacity(0.3)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: isSelected ? 5 : 3
                            )
                    )
                    .overlay{
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(isSelected ? 0.35 : 0.15),
                                        Color.clear
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .shadow(color: isSelected ? Color.cyan.opacity(0.6) : .clear, radius: 15, x: 0, y: 0)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 2, y: 4)
                Text("Answer")
                    .foregroundStyle(.white)
                    .font(.system(size: 50))
                    .fontWeight(isSelected ? .bold : .semibold)
                    .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
            }
            .offset(y: isSelected ? -15 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
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


