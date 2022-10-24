//
//  MainViewController.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 24.10.2022.
//

import UIKit
import MetalKit

class MainViewController: UIViewController {
    
    private var metalView = MTKView()
    private var device: MTLDevice!
    private var commandQueue: MTLCommandQueue!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        // device: reference to the GPU
        // 1 device and 1 commandQueue for per APP
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        
        metalView.clearColor = Colors.background
        metalView.delegate = self
        commandQueue = device.makeCommandQueue()
        
    }

    
    private func configureUI() {
        view.addSubview(metalView)
        metalView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            metalView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            metalView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            metalView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            metalView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension MainViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // called whenever the view size changed, rotating the device etc.
    }
    
    // draw textures for every frame
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let descriptor = view.currentRenderPassDescriptor else {return}
        // command buffer created to hold command encoder
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        // finished encoding all the commands then sent the command buffer to GPU(device)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
