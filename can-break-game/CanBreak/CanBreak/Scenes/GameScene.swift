//
//  GameScene.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 27.10.2022.
//

import MetalKit

class GameScene: Scene {
    var quad: Plane
    var cube: Cube
    
    override init(device: MTLDevice, size: CGSize) {
        cube = Cube(device: device)
        quad = Plane(device: device, imageName: "picture.png")
        super.init(device: device, size: size)
        add(childNode: cube)
        add(childNode: quad)
        
        quad.position.z = -3
        quad.scale = float3(repeating: 3)
        
//        let quad2 = Plane(device: device, imageName: "picture.png")
//        quad2.scale = SIMD3<Float>(repeating: 0.5)
//        quad2.position.y = 1.5
//        quad.add(childNode: quad2)
    }
    
    override func update(deltaTime: Float) {
        cube.rotation.y += deltaTime
    }
    
}

