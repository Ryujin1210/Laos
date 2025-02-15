//
//  MeomoryWeak_Ex.swift
//  Laos_Day2
//
//  Created by YU WONGEUN on 2/15/25.
//


// MARK: - This Code for Memory problem sample

import SwiftUI
import ARKit
import SceneKit

struct MeomoryWeak_Ex: View {
    @State private var showFaceMesh = false
    @State private var showFacePoints = false
    
    var body: some View {
        ZStack {
            ARViewContainer2(showFaceMesh: $showFaceMesh, showFacePoints: $showFacePoints)
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
                    
                    Button("Face Points") {
                        showFacePoints.toggle()
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

struct ARViewContainer2: UIViewRepresentable {
    @Binding var showFaceMesh: Bool
    @Binding var showFacePoints: Bool
    
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
    
    func makeCoordinator() -> Coordinator2 {
        Coordinator(self)
    }
}

// MARK: - weak version
class Coordinator2: NSObject, ARSCNViewDelegate {
    var parent: ARViewContainer2
    
    init(_ parent: ARViewContainer2) {
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
        
        if parent.showFacePoints {
            showFacePoints(node: node, anchor: anchor)
        } else {
            removeFacePoints(node: node)
        }
    }
    
    func showFacePoints(node: SCNNode, anchor: ARFaceAnchor) {
        removeFacePoints(node: node)
        
        for (index, point) in anchor.geometry.vertices.enumerated() {
            let sphere = SCNSphere(radius: 0.001)
            sphere.firstMaterial?.diffuse.contents = UIColor.red
            
            let pointNode = SCNNode(geometry: sphere)
            pointNode.position = SCNVector3(point)
            pointNode.name = "facePoint"
            
            let textNode = SCNNode()
            textNode.geometry = SCNText(string: "\(index)", extrusionDepth: 0.1)
            textNode.scale = SCNVector3(0.0003, 0.0003, 0.0003)
            textNode.position = SCNVector3(point.x + 0.005, point.y + 0.005, point.z)
            
            node.addChildNode(pointNode)
            node.addChildNode(textNode)
            
        }
    }
    
    func removeFacePoints(node: SCNNode) {
        node.childNodes.forEach { childNode in
            if childNode.name == "facePoint" {
                childNode.removeFromParentNode()
            }
        }
    }
    
}

// MARK: - weak solution 


#Preview {
    MeomoryWeak_Ex()
}
