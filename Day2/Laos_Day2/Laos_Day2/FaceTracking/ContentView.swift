//
//  ContentView.swift
//  Laos_Day2
//
//  Created by YU WONGEUN on 2/15/25.
//

import SwiftUI
import ARKit
import SceneKit

struct ContentView: View {
    @State private var showFaceMesh = false
    @State private var show3DMask = false
    
    var body: some View {
        ZStack {
            ARViewContainer(showFaceMesh: $showFaceMesh, show3DMask: $show3DMask)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                HStack {
                    Button("Face Mesh") {
                        showFaceMesh.toggle()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("3D Mask") {
                        show3DMask.toggle()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var showFaceMesh: Bool
    @Binding var show3DMask: Bool
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device.")
        }
        
        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration)
        
        arView.delegate = context.coordinator
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, ARSCNViewDelegate {
    var parent: ARViewContainer
    var maskNode: SCNNode?
    
    init(_ parent: ARViewContainer) {
        self.parent = parent
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return nil }
        
        let faceGeometry = ARSCNFaceGeometry(device: renderer.device!)!
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.fillMode = .lines
        node.geometry?.firstMaterial?.transparency = 0.5
        
        updateFaceNode(node, for: faceAnchor)
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        updateFaceNode(node, for: faceAnchor)
    }
    
    func updateFaceNode(_ node: SCNNode, for anchor: ARFaceAnchor) {
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry else { return }
        
        faceGeometry.update(from: anchor.geometry)
        node.isHidden = !parent.showFaceMesh
        
        if parent.show3DMask {
            add3DMask(to: node, anchor: anchor)
        } else {
            remove3DMask(from: node)
        }
    }
    
    func add3DMask(to node: SCNNode, anchor: ARFaceAnchor) {
        if maskNode == nil {
            guard let maskURL = Bundle.main.url(forResource: "mask", withExtension: "scn"),
                  let maskNode = SCNReferenceNode(url: maskURL) else {
                print("Failed to load mask model")
                return
            }
            maskNode.load()
            
            maskNode.scale = SCNVector3(0.2, 0.2, 0.2)
            maskNode.position = SCNVector3(0, 0, 0)

            self.maskNode = maskNode
        }
        
        if let maskNode = maskNode {
            node.addChildNode(maskNode)
        }
    }

    func remove3DMask(from node: SCNNode) {
        maskNode?.removeFromParentNode()
    }


}


#Preview {
    ContentView()
}

