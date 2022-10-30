//
//  LightingScene.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 30.10.2022.
//

import MetalKit

class LightingScene: Scene {
    
    let mushroom: Model
    
    override init(device: MTLDevice, size: CGSize) {
        mushroom = Model(device: device, modelName: "mushroom")
        
        super.init(device: device, size: size)
        
        mushroom.position.y = -1
        add(childNode: mushroom)
        
        light.color = SIMD3<Float>(0, 0, 1)
        light.ambientIntensity = 0.5
    }
    
    
    
}
