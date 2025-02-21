//
//  SwiftUIView.swift
//  SpinSolve360
//
//  Created by 林　一貴 on 2025/02/21.
//

import SwiftUI

struct NumberButton:Identifiable {
    let id = UUID()
    var isselected:Bool
    var number :Int

}

struct ARSwiftUIView: View {

    @State var numberbutton:[NumberButton] = (1...9).map{ NumberButton(isselected: false, number: $0) }
    @State var selectedNumber:Int = 0
    @ObservedObject var vm : ARViewModel

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
            Spacer()
            ZStack{
                RoundedRectangle(cornerRadius: 60)
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

    }
}



extension ARSwiftUIView {
    private var numberButton :some View{
        HStack{
            ForEach(numberbutton){nb in
                Button {
                    numberbutton.map{numberbutton[$0.number - 1].isselected = false}
                    numberbutton[nb.number - 1].isselected = true
                    selectedNumber = nb.number

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
            print("Selected Number : \(selectedNumber)")
            vm.coordinator?.dop()
            if !(selectedNumber == 0){
                withAnimation(.easeIn) {
                    numberbutton[selectedNumber - 1].isselected = false
                }
            }
            selectedNumber = 0
            NotificationCenter.default.post(name: .genereteBox, object: nil)
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
                        .font(.system(size: 50))
                }.offset(y:-17.5)
            }
        }.buttonStyle(.plain)
            .frame(width: 300,height: 100)
    }
}
