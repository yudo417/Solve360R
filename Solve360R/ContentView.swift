

import SwiftUI
import RealityKit
import ARKit
import UIKit
import AVFoundation

enum PutItemKind {
    case NumberBox
    case QuestionBox
    case sign
}

struct homeView:View{
    var onStart:() -> Void
    @State var isRecordSheet:Bool = false
    @State var isInitalTutrial:Bool = true
    @State private var isAnimating = false

    var body:some View{
        ZStack {
            // 美しいグラデーション背景
            Colors.background

            // 装飾的な背景要素
            VStack {


                Spacer()

                HStack {
                    ForEach(0..<3) { i in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(isAnimating ? 15 : -15))
                            .animation(
                                Animation.easeInOut(duration: 2.5)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(i) * 0.3),
                                value: isAnimating
                            )
                    }
                }
                .offset(x: 250, y: 100)
            }

            VStack(spacing: 40) {
                Spacer()

                // タイトルセクション
                VStack(spacing: 20) {
                    // メインタイトル
                    Text("AppName")
                        .font(.system(size: 60, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.white, Color.cyan]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .scaleEffect(isAnimating ? 1.20 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )

                    // サブタイトル
//                    Text("AR Math Adventure")
//                        .font(.title2)
//                        .foregroundColor(.white.opacity(0.8))
//                        .fontWeight(.medium)
                }

                Spacer()

                // ボタンセクション
                HStack(spacing: 40) {
                    // How? ボタン
                    VStack {
//                        if isInitalTutrial {
                            Button {
                                isInitalTutrial = false
//                                isRecordSheet.toggle()
                            } label: {
                                ZStack {
                                    // ボタン背景
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.orange,
                                                    Color.red
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 160, height: 160)
                                        .shadow(color: .orange.opacity(0.5), radius: 15, x: 0, y: 8)

                                    // アイコン
                                    VStack(spacing: 8) {
                                        Image(systemName: "questionmark.circle.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                        Text("How?")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .buttonStyle(ScaleButtonStyle())
//                        } else {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 25)
//                                    .fill(Color.gray.opacity(0.3))
//                                    .frame(width: 160, height: 160)
//
//                                VStack(spacing: 8) {
//                                    Image(systemName: "questionmark.circle")
//                                        .font(.system(size: 40))
//                                        .foregroundColor(.white.opacity(0.6))
//                                    Text("How?")
//                                        .font(.title2)
//                                        .fontWeight(.bold)
//                                        .foregroundColor(.white.opacity(0.6))
//                                }
//                            }
//                        }
                    }

                    // Play! ボタン
                    VStack {
//                        if isInitalTutrial {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 25)
//                                    .fill(Color.gray.opacity(0.3))
//                                    .frame(width: 160, height: 160)
//
//                                VStack(spacing: 8) {
//                                    Image(systemName: "play.circle")
//                                        .font(.system(size: 40))
//                                        .foregroundColor(.white.opacity(0.6))
//                                    Text("Play!")
//                                        .font(.title2)
//                                        .fontWeight(.bold)
//                                        .foregroundColor(.white.opacity(0.6))
//                                }
//                            }
//                        } else {
                            Button {
                                onStart()
                            } label: {
                                ZStack {
                                    // ボタン背景
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.green,
                                                    Color.blue
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 160, height: 160)
                                        .shadow(color: .green.opacity(0.5), radius: 15, x: 0, y: 8)

                                    // アイコン
                                    VStack(spacing: 8) {
                                        Image(systemName: "play.circle.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                        Text("Play!")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .buttonStyle(ScaleButtonStyle())
//                        }
                    }
                }

                Spacer()

                // フッター情報
//                HStack(spacing: 20) {
//                    Image(systemName: "arkit")
//                        .font(.title2)
//                        .foregroundColor(.white.opacity(0.7))
//
//                    Text("Powered by ARKit & RealityKit")
//                        .font(.caption)
//                        .foregroundColor(.white.opacity(0.6))
//                }
            }
            .padding(.horizontal, 40)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isRecordSheet = true
                } label: {
                    ZStack{

                        HStack(spacing: 8) {
                            Image(systemName: "crown")
                                .font(.title3)
                                .fontWeight(.semibold)

                            Text("record")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
    //                    .background(
    //                        // グラスモーフィズム背景
    //                        Capsule()
    //                            .fill(.ultraThinMaterial)
    //                            .background(
    //                                LinearGradient(
    //                                    gradient: Gradient(colors: [Color.white.opacity(0.25), Color.white.opacity(0.1)]),
    //                                    startPoint: .topLeading,
    //                                    endPoint: .bottomTrailing
    //                                )
    //                            )
    //                            .clipShape(Capsule())
    //                    )
    //                    .overlay(
    //                        Capsule()
    //                            .stroke(Color.white.opacity(0.4), lineWidth: 1)
    //                    )
                    }
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(ScaleButtonStyle())
                .buttonStyle(.plain)
            }
        }
        .fullScreenCover(isPresented: $isRecordSheet) {
            RecordView(isRecordSheet: $isRecordSheet)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// カスタムボタンスタイル
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}


enum Screen: Hashable {
    case home
    case game
    case result
}

struct ContentView: View {

    @StateObject var vm = ARViewModel()
    @State var isdamaged = false
    @State var isPlaneDetected = false
    @State var isGameStarted = false
    @State var isGameFinished = false
    @State var recordCount:Int = 0
    @State var isresult : Bool = false
    @State  var path = [Screen]()
    var body: some View {

        NavigationStack(path:$path){

            homeView{
                gameStateReset()
                path.append(.game)
            }
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .home:
                    homeView{
                        gameStateReset()
                        path.append(.game)
                    }
                case .game:
                    ZStack{
                        ARViewContainer(vm:vm,isGameStarted: $isGameStarted,isGameFinished: $isGameFinished,isresult: $isresult,path: $path)
                        ARSwiftUIView(vm:vm,isGameStarted: $isGameStarted,isGameFinished: $isGameFinished,recordCount: $recordCount)
                            .navigationBarBackButtonHidden()
                    }.ignoresSafeArea(.all)
                case .result:
                    resultView(vm:vm,path:$path)
                        .navigationBarBackButtonHidden()
                }
            }


        }
    }
    func gameStateReset(){
        isPlaneDetected = false
        isGameStarted = false
        isGameFinished = false
        recordCount = 0
        isresult = false
    }
}

#Preview {
    homeView(onStart: {})
}

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var vm:ARViewModel
    let arView = ARView(frame: .zero)
    @Binding var isGameStarted :Bool
    @Binding var isGameFinished :Bool
    @Binding var isresult:Bool
    @Binding var path:[Screen]

    func makeUIView(context: Context) -> ARView {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)

        arView.session.delegate = context.coordinator
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // 更新が必要な場合に使用
    }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(self)
        vm.coordinator = coordinator
        return coordinator

    }
    // -MARK: MainActor
    @MainActor
    class Coordinator:NSObject,ARSessionDelegate {

        private var IsPlacedObject = false
        var parent : ARViewContainer
        let fomulagenerate = FomulaGenerate()//不等式生成クラス
        var anchorMain : AnchorEntity?  //メイン用に（参照）
        var generatedFomula:[ExclusiveRangeConstraint] = []
        var generatedAnswer: Int = 0
        var okplayer: AVAudioPlayer?
        var outplayer: AVAudioPlayer?
        var finishplayer: AVAudioPlayer?


        init(_ parent: ARViewContainer) {
            self.parent = parent
            super.init()
            NotificationCenter.default.addObserver(self, selector: #selector(generateBoxes), name: .genereteBox, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(finishAction), name: .finishGame, object: nil)
        }

        nonisolated func session(_ session:ARSession,didAdd anchors:[ARAnchor]){



            Task { @MainActor [weak self] in
                guard let self = self else { return }

                guard !self.IsPlacedObject else { return }


                self.handleDidAddAnchors(anchors)
            }
        }

        func handleDidAddAnchors(_ anchors:[ARAnchor]) {
            let _ = print("\(IsPlacedObject)")

            guard !IsPlacedObject else { return }


            for anchor in anchors {

                if let planeAnchor = anchor as? ARPlaneAnchor {

                    let planePosition = SIMD3<Float>(
                        planeAnchor.transform.columns.3.x,
                        planeAnchor.transform.columns.3.y,
                        planeAnchor.transform.columns.3.z
                    )
                    let anchorEntity = AnchorEntity(world: planePosition)
                    self.anchorMain = anchorEntity
                    parent.arView.scene.addAnchor(anchorEntity)

                    let newConfig = ARWorldTrackingConfiguration()
                    newConfig.planeDetection = []
                    parent.arView.session.run(newConfig)


                    // ARセッションの設定

                    PutItem(translation: [-0.2,0,0], itemname: "sign", anchorentity: anchorEntity,putitemkind: .sign)
                    PutItem(translation: [0,0,0], itemname: "questionBox", anchorentity: anchorEntity,putitemkind: .QuestionBox)
                    PutItem(translation: [0.2,0,0], itemname: "sign", anchorentity: anchorEntity,putitemkind: .sign)


                    PutItem(translation: [0,0,0.2], itemname: "sign", anchorentity: anchorEntity, putitemkind: .sign,IsRotation: true)
                    PutItem(translation: [0,0,-0.2], itemname: "sign", anchorentity: anchorEntity, putitemkind: .sign,IsRotation: true)


                    IsPlacedObject = true
                    parent.isGameStarted = true
                    generateBoxes()

                }
            }
        }

        func PutItem(translation:SIMD3<Float>,itemname:String,anchorentity:AnchorEntity,putitemkind:PutItemKind,IsRotation:Bool = false){// -.pi/2z軸基準に回転制御
            switch putitemkind{
            case .NumberBox:
                if let usdzModel = try? ModelEntity.loadModel(named:itemname){
                    usdzModel.name = "NumberBox"
                    usdzModel.transform = Transform(
                        scale: [0.04,0.04,0.04], rotation: simd_quatf(angle:  -.pi/2, axis: [1,0,0]) * simd_quatf(angle: IsRotation ?  -.pi/2 : 0 , axis: [0,0,1]), translation:translation
                    )
                    anchorentity.addChild(usdzModel)
                    //                    parent.arView.scene.addAnchor(anchorentity)
                }
            case .sign:
                if let usdzModel = try? ModelEntity.loadModel(named:itemname){
                    usdzModel.name = "sign"
                    usdzModel.transform = Transform(
                        scale: [0.04,0.04,0.04], rotation: simd_quatf(angle:  .pi/2, axis: [1,0,0]) * simd_quatf(angle: IsRotation ?  .pi/2 : .pi , axis: [0,0,1]), translation:translation
                    )
                    anchorentity.addChild(usdzModel)
                    //                    parent.arView.scene.addAnchor(anchorentity)
                }
            case .QuestionBox:
                if let usdzModel = try? ModelEntity.loadModel(named:itemname){
                    usdzModel.name = "QuestionBox"
                    usdzModel.transform = Transform(
                        scale: [0.04,0.04,0.04], rotation: simd_quatf(angle:  -.pi/2, axis: [1,0,0]) * simd_quatf(angle:  -.pi/2, axis: [0,0,1]), translation:translation
                    )
                    anchorentity.addChild(usdzModel)
                    //                    parent.arView.scene.addAnchor(anchorentity)
                }
            }
        }

        func removeOnlyNumberBoxes(anchor: AnchorEntity) {

            //            for child in anchor.children {
            //                if child.name == "NumberBox" {
            //                    child.removeFromParent()
            //                }
            //            }
            // 1) 削除前に子を全部表示
            //                print("=== removeOnlyNumberBoxes START ===")

            while let child = anchor.children.first(where: { $0.name == "NumberBox" }) {
                //                    print("   --> Removing \(child.name)")
                child.removeFromParent()
            }

            //                print("After removal, anchor has \(anchor.children.count) children:")
            //                for child in anchor.children {
            //                    print("   child left = \(child.name)")
            //                }
            //                print("=== removeOnlyNumberBoxes END ===")

        }

        @objc func generateBoxes(){

            guard let anchor = anchorMain else { return }

            removeOnlyNumberBoxes(anchor: anchor)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }

                (self.generatedFomula,self.generatedAnswer) = fomulagenerate.genefomula()
                PutItem(translation: [-0.4,0,0], itemname: "\(generatedFomula[0].lower)_\(generatedFomula[1].lower)", anchorentity: anchor,putitemkind: .NumberBox,IsRotation: true)//左（弱い）
                PutItem(translation: [0.4,0,0], itemname: "\(generatedFomula[0].upper)_\(generatedFomula[1].upper)", anchorentity: anchor,putitemkind: .NumberBox,IsRotation: true)//右（強い）
                PutItem(translation: [0,0,0.4], itemname: "\(generatedFomula[2].lower)_\(generatedFomula[3].lower)", anchorentity: anchor, putitemkind: .NumberBox)//前（弱い）
                PutItem(translation: [0,0,-0.4], itemname: "\(generatedFomula[2].upper)_\(generatedFomula[3].upper)", anchorentity: anchor, putitemkind: .NumberBox)//後（強い）
                print("ボックスの更新した")
                parent.vm.generatedAnswer = generatedAnswer

            }
        }

        func dop(){
        }

        func OkSound() {
            guard let url = Bundle.main.url(forResource: "quizOk", withExtension: "mp3") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                okplayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

                guard let player = okplayer else { return }

                player.play()

            } catch {
                print(error.localizedDescription)
            }
        }

        func OutSound() {
            guard let url = Bundle.main.url(forResource: "quizOut", withExtension: "mp3") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                okplayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

                guard let player = okplayer else { return }

                player.play()

            } catch {
                print(error.localizedDescription)
            }
        }

        func FinishSound() {
            guard let url = Bundle.main.url(forResource: "finishWhistle", withExtension: "mp3") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                finishplayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

                guard let player = finishplayer else { return }

                player.play()

            } catch {
                print(error.localizedDescription)
            }
        }

        @objc func finishAction(){
            parent.arView.session.pause()
            //            parent.isresult = true
            parent.path.append(.result)
            parent.vm.coordinator?.FinishSound()
            //            parent.isGameFinished = true
        }

    }
}
