//
//  Plane.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 27.10.2022.
//

import MetalKit

class Plane: Node {
    
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    private var vertices: [Float] = [  -1,  1, 0, // V0
                                       -1, -1, 0, // V1
                                        1, -1, 0, // v2
                                        1,  1, 0  // v3
                                    ]
    
    private let indices: [UInt16] = [ 0, 1, 2,
                                      2, 3, 0
                                    ]
    
    private var constants = Constants()
    private var time: Float = 0
    
    init (device: MTLDevice) {
        super.init()
        buildBuffers(device: device)
    }
    
    private func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
        
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        
        guard let indexBuffer = indexBuffer else {return}
        
        time += deltaTime
        let animateBy = abs(sin(time) / 2 + 0.5)
        constants.animatedBy = animateBy
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)

    }
}
