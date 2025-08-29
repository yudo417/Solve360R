import SwiftUI

struct TutrialView: View {
    @Binding var isTutrialSheet: Bool
    @State private var currentPage = 0
    @State private var demoChoice: Int? = nil
    @State private var demoTime: Float = 10

    var body: some View {
        VStack{
            Button {
                isTutrialSheet = false
            } label: {
                HStack{
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                    Text("Close Page")
                }
                .foregroundStyle(.blue)
                .font(.largeTitle)
            }

            Spacer()

            ZStack {
                VStack {
                    TabView(selection: $currentPage) {
                        // ステップ1: ゲームの目的
                        VStack {
                            Spacer()
                            Text("Welcom to SpinSolve360 !")
                                .font(.largeTitle)
                                .padding()
                            Spacer()
                            Text("Let's solve many inequalities using AR within 60 seconds to get the highest score !!")

                            Spacer()
                            nextButton(nextpage: 1)
                            .padding()
                        }
                        .tag(0)

                        // ステップ2: ARと方向性
                        VStack(spacing:30) {
                            Spacer()
                            Text("What is 「inequality？」")
                                .font(.largeTitle)
                                .padding()
                            HStack(spacing: 30){
                                Text("2")
                                Text("＜")
                                Text("6")
                            }.font(.largeTitle)
                            Text("For example, among the numbers 2 and 6, 6 is larger. In this case, the 「<」 symbol can be used as shown above to denote the relative sizes of the numbers")
                                .font(.headline)

                            .padding()

                            Spacer()
                            nextButton(nextpage: 2)
                            .padding()
                        }
                        .tag(1)

                        // ステップ3: 不等式の重ね合わせ
                        VStack {
                            Spacer()
                            Text("「Perspective」 is very important key in this game !")
                                .font(.title)
                                .padding()
                            HStack{
                                VStack{
                                    Text("front View")
                                    Image("ex1").resizable().frame(width: 350, height: 250)
                                }
                                VStack{
                                    Text("back View")
                                    Image("ex2").resizable().frame(width: 350, height: 250)
                                }
                            }

                            Text("This is the actual game screen.It is necessary for you to detect flat surfaces such as desks. The white blocks have numbers written on both the front and back, so the view is completely different when seen from the opposite side.")
                            .padding()
                            Spacer()
                            nextButton(nextpage: 3)

                            .padding()
                        }
                        .tag(2)

                        // ステップ4: タイマーとライフ
                        VStack {
                            Spacer()
                            Text("Solve Answer !")
                                .font(.largeTitle)
                                .padding()
                            Image("ex3").resizable()
                                .frame(width: 300, height: 250)
                            VStack{
                                Text("As shown in the diagram, by considering the viewpoints from the front, back, right, and left, you can form four inequalities to determine the value! In this case, we have:")

                                HStack{
                                    Spacer()
                                    VStack{
                                        Text("4 < ? < 8")
                                        Text("2 < ? < 9")
                                        Text("3 < ? < 8")
                                        Text("1 < ? < 6")
                                    }
                                    Spacer()

                                    Text("Thus, the value is 「5」")
                                    Spacer()
                                }
                            }
                            .padding()

                            Spacer()
                            nextButton(nextpage: 4)
                            .padding()
                        }
                        .tag(3)

                        // ステップ5: スコアと開始
                        VStack {
                            Spacer()
                            Text("Game Over")
                                .font(.largeTitle)
                                .padding()
                            Spacer()
                            Text("Be careful—if you make three mistakes, it's game over. Try to get as many correct answers as you can within the time limit and aim for the best score! ")
                            Text("That's all the rules").font(.title3)
                            Text("Now, are you ready? Stand up and walk around to figure out the solution!").font(.title2)
                            Spacer()
                            nextButton(nextpage: 5)
                        }
                        .tag(4)
                    }
                    .padding(.horizontal,100)
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .padding(20)
    }
}


extension TutrialView {
    func nextButton(nextpage:Int) -> some View{
        HStack{
            Spacer()
            Button {
                if self.currentPage != 4 {
                    withAnimation{ self.currentPage = nextpage  }
                }else{
                isTutrialSheet = false
                }
            } label: {
                ZStack{
                    Circle().foregroundStyle(.blue)
                        .frame(width:80, height: 80)
                    Image(systemName:(self.currentPage != 4) ?  "arrowshape.forward" : "xmark").foregroundStyle(.white)
                }
            }.buttonStyle(.plain)

        }
    }
}
