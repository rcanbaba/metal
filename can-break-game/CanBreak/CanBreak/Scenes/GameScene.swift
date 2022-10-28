//
//  GameScene.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 27.10.2022.
//

import MetalKit

class GameScene: Scene {
    var quad: Plane
    
    override init(device: MTLDevice, size: CGSize) {
        quad = Plane(device: device, imageName: "picture.png", maskImageName: "picture-frame-mask.png")
        super.init(device: device, size: size)
        add(childNode: quad)
        
        let pictureFrame  = Plane(device: device, imageName: "picture-frame.png")
        add(childNode: pictureFrame)
    }
    
}

