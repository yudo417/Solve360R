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

enum PutItemKind {
    case NumberBox
    case QuestionBox
    case sign
}

struct ContentView: View {
    var body: some View {
        ARViewContainer()
            .padding()
    }
}

#Preview {
    ContentView()
}

struct ARViewContainer: UIViewRepresentable {
    let arView = ARView(frame: .zero)

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
        Coordinator(self)
    }
    @MainActor
    class Coordinator:NSObject,ARSessionDelegate {
        var parent : ARViewContainer

        private var IsPlacedObject = false

        init(_ parent: ARViewContainer) {
            self.parent = parent
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


                    // ARセッションの設定
                    PutItem(translation: [-0.4,0,0], itemname: "4_7", anchorentity: anchorEntity,putitemkind: .NumberBox,IsRotation: true)
                    PutItem(translation: [-0.2,0,0], itemname: "sign", anchorentity: anchorEntity,putitemkind: .sign)
                    PutItem(translation: [0,0,0], itemname: "questionBox", anchorentity: anchorEntity,putitemkind: .QuestionBox)
                    PutItem(translation: [0.2,0,0], itemname: "sign", anchorentity: anchorEntity,putitemkind: .sign)
                    PutItem(translation: [0.4,0,0], itemname: "8_3", anchorentity: anchorEntity,putitemkind: .NumberBox,IsRotation: true)

                    IsPlacedObject = true

                }
            }
        }

        func PutItem(translation:SIMD3<Float>,itemname:String,anchorentity:AnchorEntity,putitemkind:PutItemKind,IsRotation:Bool = false){// -.pi/2z軸基準に回転制御
            switch putitemkind{
            case .NumberBox:
                if let usdzModel = try? ModelEntity.loadModel(named:itemname){
                    usdzModel.transform = Transform(
                        scale: [0.04,0.04,0.04], rotation: simd_quatf(angle:  -.pi/2, axis: [1,0,0]) * simd_quatf(angle: IsRotation ?  -.pi/2 : 0 , axis: [0,0,1]), translation:translation
                    )
                    anchorentity.addChild(usdzModel)
                    parent.arView.scene.addAnchor(anchorentity)
                }
            case .sign:
                if let usdzModel = try? ModelEntity.loadModel(named:itemname){
                    usdzModel.transform = Transform(
                        scale: [0.04,0.04,0.04], rotation: simd_quatf(angle:  .pi/2, axis: [1,0,0]) * simd_quatf(angle: IsRotation ?  -.pi/2 : .pi , axis: [0,1,0]), translation:translation
                    )
                    anchorentity.addChild(usdzModel)
                    parent.arView.scene.addAnchor(anchorentity)
                }
            case .QuestionBox:
                if let usdzModel = try? ModelEntity.loadModel(named:itemname){
                    usdzModel.transform = Transform(
                        scale: [0.04,0.04,0.04], rotation: simd_quatf(angle:  -.pi/2, axis: [1,0,0]) * simd_quatf(angle:  -.pi/2, axis: [0,0,1]), translation:translation
                    )
                    anchorentity.addChild(usdzModel)
                    parent.arView.scene.addAnchor(anchorentity)
                }
            }
        }
    }
}
