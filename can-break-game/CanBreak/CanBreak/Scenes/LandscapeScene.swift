//
//  LandscapeScene.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 30.10.2022.
//

import MetalKit

class LandscapeScene: Scene {
    
    let sun: Model
    let ground: Plane
    let grass: Instance
    let mushroom: Model
    
    override init(device: MTLDevice, size: CGSize) {
        sun = Model(device: device, modelName: "sun")
        ground = Plane(device: device)
        grass = Instance(device: device, modelName: "grass", instances: 10000)
        mushroom = Model(device: device, modelName: "mushroom")
        super.init(device: device, size: size)
         
        sun.materialColor = SIMD4<Float>(1,1,0,1)
        add(childNode: sun)
        setupScene()
    }
    
    override func update(deltaTime: Float) {
    }
    
    func setupScene() {
        ground.materialColor = SIMD4<Float>(0.4, 0.3, 0.1, 1) // brown
        add(childNode: ground)
        add(childNode: grass)
        add(childNode: mushroom)
        
    }
}
