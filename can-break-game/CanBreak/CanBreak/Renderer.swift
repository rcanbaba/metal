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
    var scene: Scene?
    var samplerState: MTLSamplerState?
    var depthStencilState: MTLDepthStencilState?
    
    private var pipelineState: MTLRenderPipelineState?
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        super.init()
        buildSamplerState()
        buildDepthStencilState()
    }
    
    private func buildSamplerState() {
        let descriptor = MTLSamplerDescriptor()
        descriptor.minFilter = .linear
        descriptor.magFilter = .linear
        samplerState = device.makeSamplerState(descriptor: descriptor)
    }
    
    private func buildDepthStencilState() {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
    
}

extension Renderer: MTKViewDelegate {
    // called whenever the view size changed, rotating the device etc.
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene?.sceneSizeWillChange(to: size)
    }
    
    // draw textures for every frame
    // calls draw method 60 times per second
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor
        else {return}
        
        // command buffer created to hold command encoder
        guard let commandBuffer = commandQueue?.makeCommandBuffer(),
              let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else {return}

        // calls draw method 60 times per second
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        
        commandEncoder.setFragmentSamplerState(samplerState, index: 0)
        commandEncoder.setDepthStencilState(depthStencilState)
        
        scene?.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        /// ----------------------------
        // finished encoding all the commands then sent the command buffer to GPU(device)
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
}
