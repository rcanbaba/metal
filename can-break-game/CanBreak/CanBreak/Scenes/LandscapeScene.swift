//
//  LandscapeScene.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 30.10.2022.
//

import MetalKit

class LandscapeScene: Scene {
    
    let sun: Model
    
    override init(device: MTLDevice, size: CGSize) {
        sun = Model(device: device, modelName: "sun")
        super.init(device: device, size: size)
         
        sun.materialColor = SIMD4<Float>(1,1,0,1)
        add(childNode: sun)
    }
    
    override func update(deltaTime: Float) {
    }
}
