//
//  Scene.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 27.10.2022.
//

import MetalKit

class Scene: Node {
    var device: MTLDevice
    var size: CGSize
    var camera = Camera()
    var sceneConstants = SceneConstants()
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        super.init()
        camera.aspect = Float(size.width / size.height)
        camera.position.z = -6
        add(childNode: camera)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        update(deltaTime: deltaTime)
        sceneConstants.projectionMatrix = camera.projectionMatrix
        commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 2)
        for child in children {
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: camera.viewMatrix)
        }
    }
    
    func update(deltaTime: Float) {
        
    }
}
