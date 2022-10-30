//
//  LightingScene.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 30.10.2022.
//

import MetalKit

class LightingScene: Scene {
    
    let mushroom: Model
    var previousTouchLocation: CGPoint = .zero
    
    override init(device: MTLDevice, size: CGSize) {
        mushroom = Model(device: device, modelName: "mushroom")
        
        super.init(device: device, size: size)
        
        mushroom.position.y = -1
        add(childNode: mushroom)
        
        light.color = SIMD3<Float>(0, 0, 1)
        light.ambientIntensity = 0.5
    }
    
    override func touchesBegan(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        previousTouchLocation = touch.location(in: view)
    }
    
    override func touchesMoved(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: view)
        
        let delta = CGPoint(x: previousTouchLocation.x - touchLocation.x, y: previousTouchLocation.y - touchLocation.y)
        
        let sensitivity: Float = 0.01
        mushroom.rotation.x += Float(delta.y) * sensitivity
        mushroom.rotation.y += Float(delta.x) * sensitivity
        
        previousTouchLocation = touchLocation
    }
    
}
