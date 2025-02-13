//
//  RotatingEarthView2.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 11.02.25.
//

import SwiftUI
import SceneKit

struct RotatingEarthView: View {
    @State private var selectedTexture = "world-map"
    
    struct TextureOption {
        let id: String 
        let title: String
    }
    
    let textureOptions: [TextureOption] = [
        TextureOption(id: "world-map", title: "Earth View"),
        TextureOption(id: "GlobalWarming-1986-2005", title: "Global Warming 1986-2005"),
        TextureOption(id: "GlobalWarming-2020-2039", title: "Global Warming 2020-2039"),
        TextureOption(id: "GlobalWarming-2040-2059", title: "Global Warming 2040-2059"),
        TextureOption(id: "GlobalWarming2080-2099", title: "Global Warming 2080-2099")
    ]
    
    var body: some View {
        ZStack {
            EarthSceneView(selectedTexture: selectedTexture)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Picker("Earth View", selection: $selectedTexture) {
                    ForEach(textureOptions, id: \.id) { option in
                        Text(option.title)
                            .foregroundColor(.white)
                            .tag(option.id)
                    }
                }
                .pickerStyle(.wheel)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.black)
            }
        }
    }
}

struct EarthSceneView: UIViewRepresentable {
    var selectedTexture: String
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = createScene()
        sceneView.backgroundColor = .black
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        if let earthNode = uiView.scene?.rootNode.childNode(withName: "earthNode", recursively: true) {
            earthNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: selectedTexture)
        }
    }
    
    private func createScene() -> SCNScene {
        let scene = SCNScene()
        
        // Debug: Verify image loading
        if let skyboxImage = UIImage(named: "stars-texture1") {
            print("Skybox image loaded successfully")
            scene.background.contents = skyboxImage
        } else {
            print("Failed to load skybox image")
        }
        
        // Set up spherical skybox
        let skyboxNode = SCNNode()
        skyboxNode.geometry = SCNSphere(radius: 210)
        skyboxNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "stars-texture1")
        skyboxNode.geometry?.firstMaterial?.isDoubleSided = true
        skyboxNode.geometry?.firstMaterial?.cullMode = .front
        scene.rootNode.addChildNode(skyboxNode)
        
        // Erde erstellen
        let earthNode = createEarthNode()
        earthNode.name = "earthNode" // Add name for identification
        scene.rootNode.addChildNode(earthNode)
        
        // Kamera hinzufügen
        let cameraNode = createCameraNode()
        scene.rootNode.addChildNode(cameraNode)
        
        // Licht hinzufügen
        addLighting(to: scene)
        
        return scene
    }
    
    private func createEarthNode() -> SCNNode {
        let earthNode = SCNNode()
        earthNode.geometry = SCNSphere(radius: 1)
        earthNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: selectedTexture)
        
        // Rotation hinzufügen
        let rotation = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 200)
        earthNode.runAction(.repeatForever(rotation))
        
        return earthNode
    }
    
    
    private func createCameraNode() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        return cameraNode
    }
    
    private func addLighting(to scene: SCNScene) {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 3, y: 3, z: 3)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = UIColor(white: 0.3, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLight)
    }
}

#Preview {
    RotatingEarthView()
}
