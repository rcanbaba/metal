//
//  Renderer.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 26.10.2022.
//

import MetalKit

final class Renderer: NSObject {
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue?
    
    private var vertices: [Float] = [  -1,  1, 0, // V0
                                       -1, -1, 0, // V1
                                        1, -1, 0, // v2
                                        1,  1, 0  // v3
                                    ]
    
    private let indices: [UInt16] = [ 0, 1, 2,
                                      2, 3, 0
                                    ]
    
    private var pipelineState: MTLRenderPipelineState?
    private var vertexBuffer: MTLBuffer?
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        super.init()
        buildModel()
        buildPipelineState()
    }
    
    private func buildModel() {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
    }
    
    private func buildPipelineState() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")
    
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // called whenever the view size changed, rotating the device etc.
    }
    
    // draw textures for every frame
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let pipelineState =  pipelineState, let descriptor = view.currentRenderPassDescriptor else {return}
        // command buffer created to hold command encoder
        let commandBuffer = commandQueue?.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        /// ----------------------------
        commandEncoder?.setRenderPipelineState(pipelineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        /// ----------------------------
        // finished encoding all the commands then sent the command buffer to GPU(device)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}
