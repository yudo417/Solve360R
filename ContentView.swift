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
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = [.horizontal, .vertical]
                arView.session.run(configuration)
        let anchor = AnchorEntity(world: [0,-0.3,-1.2])

        // ARセッションの設定
        let plate = MeshResource.generateBox(size: [0.5,0.01,0.5])
        let plateMaterial = SimpleMaterial(color: .white, isMetallic: true)
        let modelEntity = ModelEntity(mesh: plate, materials: [plateMaterial])
        let PlateEntity = ModelEntity(mesh: .generateBox(size: [0.5,0.5,0.01]), materials: [SimpleMaterial(color: .white, isMetallic: true)])


        modelEntity.transform = Transform(
            translation: [-0.15,0.15,0]
            )
        if let usdzModel = try? ModelEntity.loadModel(named: "1_9") {
            let kadoAnchor = AnchorEntity(world: [0,0,-2])
            usdzModel.transform = Transform(
                scale: [0.05,0.05,0.05], rotation: simd_quatf(angle:  0, axis: [1,0,0]), translation: [0,0,0]
                )
            kadoAnchor.addChild(usdzModel)
            arView.scene.addAnchor(kadoAnchor)
            print("あった")
        }
        DispatchQueue.main.asyncAfter(deadline:.now() + 10){
            print("きた")
            arView.scene.addAnchor(anchor)
        }
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // 更新が必要な場合に使用
    }
}
