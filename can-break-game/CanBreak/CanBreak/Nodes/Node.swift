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
    
    var width: Float = 1.0
    var height: Float = 1.0
    
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
    
    func boundingBox(_ parentModelViewMatrix: matrix_float4x4) -> CGRect {
        let modelViewMatrix = matrix_multiply(parentModelViewMatrix, modelMatrix)
        var lowerLeft = SIMD4<Float>(-width/2, -height/2, 0, 1)
        lowerLeft = matrix_multiply(modelViewMatrix, lowerLeft)
        var upperRight = SIMD4<Float>(width/2, height/2, 0, 1)
        upperRight = matrix_multiply(modelViewMatrix, upperRight)
        
        let boundingBox = CGRect(x: CGFloat(lowerLeft.x), y: CGFloat(lowerLeft.y), width: CGFloat(upperRight.x - lowerLeft.x), height: CGFloat(upperRight.y - lowerLeft.y))
        return boundingBox
    }
    
}
