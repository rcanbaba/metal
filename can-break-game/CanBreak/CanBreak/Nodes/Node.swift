//
//  Node.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 27.10.2022.
//

import MetalKit

class Node {
    var name = "Untitled"
    var children: [Node] = []
    var position = SIMD3<Float>(repeating: 0)
    var rotation = SIMD3<Float>(repeating: 0)
    var scale = SIMD3<Float>(repeating: 1)
    var materialColor = SIMD4<Float>(repeating: 1)
    var specularIntensity: Float = 1
    var shininess: Float = 1
    
    var modelMatrix: matrix_float4x4 {
        // set position
        var matrix = matrix_float4x4(translationX: position.x, y: position.y, z: position.z)
        // set rotation
        matrix = matrix.rotatedBy(rotationAngle: rotation.x, x: 1, y: 0, z: 0)
        matrix = matrix.rotatedBy(rotationAngle: rotation.y, x: 0, y: 1, z: 0)
        matrix = matrix.rotatedBy(rotationAngle: rotation.z, x: 0, y: 0, z: 1)
        // set scale
        matrix = matrix.scaledBy(x: scale.x, y: scale.y, z: scale.z)
        return matrix
    }
    
    func add(childNode: Node){
        children.append(childNode)
    }
    
    // recursively renderer
    func render(commandEncoder: MTLRenderCommandEncoder, parentModelViewMatrix: matrix_float4x4) {
        let modelViewMatrix = matrix_multiply(parentModelViewMatrix, modelMatrix)
        for child in children {
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: modelViewMatrix)
        }
        if let renderable = self as? Renderable {
            // pushDebugGroup(_:) and popDebugGroup() methods allow you to inspect each node's render commands when using the GPU debugger more easily
            // TODO: When you release the app, remove debugs
            commandEncoder.pushDebugGroup(name)
            renderable.doRender(commandEncoder: commandEncoder, modelViewMatrix: modelViewMatrix)
            commandEncoder.popDebugGroup()
        }
    }
}
