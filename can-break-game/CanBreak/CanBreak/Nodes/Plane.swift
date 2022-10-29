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
                   color: SIMD4<Float>(1, 0, 0, 1),
                   texture: SIMD2<Float>(0, 1)),
            
            Vertex(position: SIMD3<Float>(-1, -1, 0),
                   color: SIMD4<Float>(0, 1, 0, 1),
                   texture: SIMD2<Float>(0, 0)),
            
            Vertex(position: SIMD3<Float>(1, -1, 0),
                   color: SIMD4<Float>(0, 0, 1, 1),
                   texture: SIMD2<Float>(1, 0)),
            
            Vertex(position: SIMD3<Float>(1, 1, 0),
                   color: SIMD4<Float>(1, 0, 1, 1),
                   texture: SIMD2<Float>(1, 1)),
    ]
        
    
    private let indices: [UInt16] = [ 0, 1, 2,
                                      2, 3, 0
                                    ]
    
    private var constants = Constants()
    private var time: Float = 0
    
    var modelConstants = ModelConstants()
    
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
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<SIMD3<Float>>.stride + MemoryLayout<SIMD4<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
      
        return vertexDescriptor
    }
    
    // Texturable
    var texture: MTLTexture?
    
    // Mask
    
    var maskTexture: MTLTexture?
    
    init (device: MTLDevice) {
        super.init()
        buildBuffers(device: device)
        pipelineState = buildPipelineState(device: device)
    }
    
    // + texture image
    init (device: MTLDevice, imageName: String) {
        super.init()
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            fragmentFunctionName = "textured_fragment"
        }
        
        buildBuffers(device: device)
        pipelineState = buildPipelineState(device: device)
    }
    
    // + mask image
    init (device: MTLDevice, imageName: String, maskImageName: String) {
        super.init()
        buildBuffers(device: device)
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            fragmentFunctionName = "textured_fragment"
        }
        if let maskTexture = setTexture(device: device, imageName: maskImageName) {
            self.maskTexture = maskTexture
            fragmentFunctionName = "textured_mask_fragment"
        }
        pipelineState = buildPipelineState(device: device)
    }
    
    private func buildBuffers(device: MTLDevice) {
        // in structs .stride method more reliable that .size
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
    }
}

extension Plane: Renderable {
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        guard let indexBuffer = indexBuffer else {return}
        
        let aspect = Float(750.0 / 1334.0)
        // 65 -> field of view
        let projectionMatrix = matrix_float4x4(projectionFov: radians(fromDegrees: 65), aspect: aspect, nearZ: 0.1, farZ: 100)
        
        modelConstants.modelViewMatrix = matrix_multiply(projectionMatrix, modelViewMatrix)
        
        commandEncoder.setRenderPipelineState(pipelineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 1)
        commandEncoder.setFragmentTexture(texture, index: 0)
        commandEncoder.setFragmentTexture(maskTexture, index: 1)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
}
extension Plane: Texturable { }
