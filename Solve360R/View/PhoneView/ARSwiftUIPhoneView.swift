
import SwiftUI
import AVFoundation
import Combine

struct ARSwiftUIPhoneView: View {
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
    let answerGradient = Gradient(stops: [
        .init(color: Color(red:0.0,green:0.7,blue:1.0).opacity(0.8),location:0.0),
        .init(color: Color(red:0.0,green:0.4,blue:0.8).opacity(0.8),location:0.4),
        .init(color: Color(red:0.0,green:0.4,blue:0.75).opacity(0.8),location:0.5),
        .init(color: Color(red:0.0,green:0.4,blue:0.8).opacity(0.8),location:0.6),
        .init(color: Color(red:0.0,green:0.7,blue:1.0).opacity(0.8),location:1.0),
    ])

    var body: some View {
        VStack(spacing: 5) {
            // 上部: Life と Time を横並び（横幅拡大）
            HStack(spacing: 15) {
                Spacer()
                // Life
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.white)
                        .opacity(0.5)
                    HStack(spacing: 5){
                        Text("Life").foregroundStyle(.black).font(.subheadline)
                        HStack(spacing: 3){
                            ForEach(0..<nowlife,id:\.self) { _ in
                                Image(systemName: "heart.fill").foregroundStyle(.red).font(.subheadline)
                            }
                            ForEach(nowlife..<3,id:\.self) { _ in
                                Image(systemName: "heart").foregroundStyle(.red).font(.subheadline)
                            }
                        }
                    }
                }
                .frame(width: 180, height: 45)
                Spacer()

                // Time
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.white)
                                    .opacity(0.5)
                                HStack(spacing: 5){
                                    Image(systemName: "clock").foregroundStyle(.black).font(.subheadline)
                                    Text("Remaining Time：") .font(.subheadline).foregroundStyle(.black)
                                    Text(String(format: "%.1f", timeRemaining))
                                        .font(.subheadline)
                                        .foregroundStyle(.black)
                                }
                            }
                .frame(width: 180, height: 45)
                Spacer()
            }
            .padding(.top, 10)
            .padding(.horizontal, 20)
            
            Spacer()
            
            // 下部: 数字ボタン + 回答ボタン
            ZStack{
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(.white)
                    .frame(width: 650,height: 100)
                    .opacity(0.5)
                    .overlay {
                        VStack(spacing: 5){
                            numberButton
                            answerButton
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                    }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
        }
        .onAppear {
            startTimer()
        }
        .onReceive(Timer.publish(every: 0.08, on: .main, in: .common).autoconnect()) { _ in
            if isGameStarted && !isGameFinished && timeRemaining > 0 {
                if timeRemaining != 0 {
                    timeRemaining -= 0.1
                }
            } else if isGameStarted && !isGameFinished && timeRemaining <= 0.1 {
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
    
    @MainActor
    private func handleTimeUp() {
        print("時間切れ！ゲームオーバー")
        finishAction()
    }
}

extension ARSwiftUIPhoneView {
    private var numberButton :some View{
        HStack(spacing: 20){
            ForEach(numberbutton){nb in
                Button {
                    numberbutton.map{numberbutton[$0.number - 1].isselected = false}
                    numberbutton[nb.number - 1].isselected = true
                    vm.selectedNumber = nb.number
                } label: {
                    ZStack{
                        if nb.isselected{
                            Circle()
//                                .scale(0.8)
                                .fill(
                                    LinearGradient(gradient: buttonSelectedGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .scaleEffect(1.2)
                                .overlay(Circle().scale(1.2).stroke(Color.blue,lineWidth:2))
//                                .frame(width: 55)
//                                .border(.red)
                            Text("\(nb.number)")
                                .font(.system(size: 32))
                                .foregroundStyle(.white)
                                .fontWeight(.heavy)
                        }else{
                            Circle()
                                .fill(
                                    LinearGradient(gradient: buttonGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .scaleEffect(1.1)
                                .shadow(color: .black.opacity(0.2), radius: 3, x: 1, y: 1)
//                                .border(.red)
                            Text("\(nb.number)")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                                .fontWeight(.heavy)
                        }
                    }
//                    .frame(height: 50)
                    .padding(.horizontal,1)
                }.buttonStyle(.plain)
            }
        }
        .padding(.bottom,3)
    }

    private var answerButton : some View{
        Button{
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
        } label: {
            if numberbutton.allSatisfy{ !$0.isselected }{
                ZStack{
                    Capsule()
                        .fill(
                            LinearGradient(gradient: answerGradient, startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: 160, height: 35)
                        .overlay(Capsule().stroke(Color.blue,lineWidth:2))
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
                        .shadow(color: .black.opacity(0.6), radius: 3, x: 1, y: 1)
                    Text("Answer")
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                }
                .offset(y:3)
            }else{
                ZStack{
                    Capsule()
                        .fill(
                            LinearGradient(gradient: answerGradient, startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: 160, height: 35)
                        .overlay(Capsule().stroke(Color.blue,lineWidth:2))
                        .shadow(color: .black.opacity(0.6), radius: 3, x: 1, y: 1)
                    Text("Answer")
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                }
                .offset(y:3)
            }
        }.buttonStyle(.plain)
            .frame(width: 180, height: 35)
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

#Preview {
    ARSwiftUIPhoneView(
        vm: ARViewModel(),
        isGameStarted: .constant(true),
        isGameFinished: .constant(false),
        recordCount: .constant(0)
    )
}
