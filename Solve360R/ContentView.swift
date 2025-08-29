//
//  ContentView.swift
//  ARKitView1
//
//  Created by 林　一貴 on 2025/01/12.
//

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
    @State var isTutrialSheet:Bool = false
    @State var isInitalTutrial:Bool = true
    var body:some View{
        VStack{
            Spacer()
            VStack{
                Text("SpinSolve360").font(.system(size:50))
            }
            Spacer()
            HStack{
                Spacer()
                    if isInitalTutrial{
                        Button {
                            isInitalTutrial = false
                            isTutrialSheet.toggle()
                        } label: {
                            ZStack{
                                Circle().foregroundStyle(.blue)
                                    .frame(width: 150, height: 150)
                                Text("How?").font(.title).fontWeight(.bold)
                            }
                        }.buttonStyle(.plain)
                    }else{
                        ZStack{
                            Circle()
                                .foregroundStyle(.gray)
                                .frame(width: 150, height: 150)
                            Text("How?").font(.title).fontWeight(.bold)
                        }
                    }

                Spacer()

                if isInitalTutrial{

                        ZStack{
                            Circle().foregroundStyle(.gray)
                                .frame(width: 150, height: 150)
                            Text("Play!").font(.title).fontWeight(.bold)
                        }

                }else{
                    Button {
                        onStart()
                    } label: {
                        ZStack{
                            Circle().foregroundStyle(.blue)
                                .frame(width: 150, height: 150)
                            Text("Play!").font(.title).fontWeight(.bold)
                        }
                    }.buttonStyle(.plain)
                }


                Spacer()
            }

            Spacer()

        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isTutrialSheet = true
                } label: {
                    Image(systemName: "info.circle").font(.title).foregroundStyle(.blue).padding()
                }

            }
        }
        .fullScreenCover(isPresented: $isTutrialSheet) {
            TutrialView(isTutrialSheet: $isTutrialSheet)
        }

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
    ContentView()
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
