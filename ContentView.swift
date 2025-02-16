//
//  ContentView.swift
//  ARKitView1
//
//  Created by 林　一貴 on 2025/01/12.
//

import SwiftUI
import RealityKit
import ARKit

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

        init(_ parent: ARViewContainer) {
            self.parent = parent
        }

        nonisolated func session(_ session:ARSession,didAdd anchors:[ARAnchor]){
            Task { @MainActor [weak self] in
                            guard let self = self else { return }
                            self.handleDidAddAnchors(anchors)
                        }
        }

        func handleDidAddAnchors(_ anchors:[ARAnchor]) {
            for anchor in anchors {

                if let planeAnchor = anchor as? ARPlaneAnchor {

                    let anchorEntity = AnchorEntity(anchor:planeAnchor)


                    // ARセッションの設定
                    if let usdzModel = try? ModelEntity.loadModel(named: "1_9") {
                        usdzModel.transform = Transform(
                            scale: [0.04,0.04,0.04], rotation: simd_quatf(angle:  -.pi/2, axis: [1,0,0]), translation: [0,0,0]
                            )
                        anchorEntity.addChild(usdzModel)
                        print("あった")
                    }
                    parent.arView.scene.addAnchor(anchorEntity)

                }
            }
        }
    }
}
