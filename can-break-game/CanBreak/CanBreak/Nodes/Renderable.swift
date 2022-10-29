//
//  Renderable.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 28.10.2022.
//

import MetalKit

protocol Renderable {
    var pipelineState: MTLRenderPipelineState! { get set }
    var vertexFunctionName: String { get }
    var fragmentFunctionName: String { get }
    var vertexDescriptor: MTLVertexDescriptor { get }
    var modelConstants: ModelConstants { get set }
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4)
}

extension Renderable {
    func buildPipelineState(device: MTLDevice) -> MTLRenderPipelineState {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: vertexFunctionName)
        let fragmentFunction = library?.makeFunction(name: fragmentFunctionName)
      
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
      
        let pipelineState: MTLRenderPipelineState
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            fatalError("error: \(error.localizedDescription)")
        }
        return pipelineState
    }
}
