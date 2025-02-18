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
                    if let usdzModel = try? ModelEntity.loadModel(named: "4_7") {
                        usdzModel.transform = Transform(
                            scale: [0.04,0.04,0.04], rotation: simd_quatf(angle:  -.pi/2, axis: [1,0,0]) * simd_quatf(angle:  -.pi/2, axis: [0,0,1]), translation: [0,0,0]
                            )
                        anchorEntity.addChild(usdzModel)
                        print("あった")

                        parent.arView.scene.addAnchor(anchorEntity)
                        
                    }

                    if let usdzModel = try? ModelEntity.loadModel(named: "8_3") {
                        usdzModel.transform = Transform(
                            scale: [0.04,0.04,0.04], rotation: simd_quatf(angle:  -.pi/2, axis: [1,0,0]) * simd_quatf(angle:  -.pi/2, axis: [0,0,1]), translation: [0,0,-0.2]
                            )
                        anchorEntity.addChild(usdzModel)
                        print("あった")

                        parent.arView.scene.addAnchor(anchorEntity)
                        
                    }

                    IsPlacedObject = true

                }
            }
        }
    }
}
