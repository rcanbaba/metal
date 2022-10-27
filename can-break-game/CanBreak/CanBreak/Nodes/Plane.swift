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
    
// [
//     -1,  1, 0, // V0
//     -1, -1, 0, // V1
//      1, -1, 0, // v2
//      1,  1, 0  // v3
// ]
    
    var vertices: [Vertex] = [
            Vertex(position: SIMD3<Float>(-1, 1, 0),
                   color: SIMD4<Float>(1, 0, 0, 1)),
            Vertex(position: SIMD3<Float>(-1, -1, 0),
                   color: SIMD4<Float>(0, 1, 0, 1)),
            Vertex(position: SIMD3<Float>(1, -1, 0),
                   color: SIMD4<Float>(0, 0, 1, 1)),
            Vertex(position: SIMD3<Float>(1, 1, 0),
                   color: SIMD4<Float>(1, 0, 1, 1))
    ]
        
    
    private let indices: [UInt16] = [ 0, 1, 2,
                                      2, 3, 0
                                    ]
    
    private var constants = Constants()
    private var time: Float = 0
    
    // Renderable
    var pipelineState: MTLRenderPipelineState!
    var fragmentFunctionName: String = "fragment_shader"
    var vertexFunctionName: String = "vertex_shader"
    
    var vertexDescriptor: MTLVertexDescriptor {
      let vertexDescriptor = MTLVertexDescriptor()
      
      vertexDescriptor.attributes[0].format = .float3
      vertexDescriptor.attributes[0].offset = 0
      vertexDescriptor.attributes[0].bufferIndex = 0
      
      vertexDescriptor.attributes[1].format = .float4
      vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
      vertexDescriptor.attributes[1].bufferIndex = 0
      
      vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
      
      return vertexDescriptor
    }
    
    init (device: MTLDevice) {
        super.init()
        buildBuffers(device: device)
        pipelineState = buildPipelineState(device: device)
    }
    
    private func buildBuffers(device: MTLDevice) {
        // in structs .stride method more reliable that .size
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
        
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        
        guard let indexBuffer = indexBuffer else {return}
        
        time += deltaTime
        let animateBy = abs(sin(time) / 2 + 0.5)
        constants.animatedBy = animateBy
        
        commandEncoder.setRenderPipelineState(pipelineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)

    }
}

extension Plane: Renderable {
}
