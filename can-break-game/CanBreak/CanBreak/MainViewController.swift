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
    private var renderer: Renderer?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setMetal()
    }
    
    private func setMetal() {
        // device: reference to the GPU
        // 1 device and 1 commandQueue for per APP
        metalView.device = MTLCreateSystemDefaultDevice()
        // not on simulator
        guard let device = metalView.device else {
            fatalError("Device not created! Run on a physical device.")
        }
        metalView.clearColor = Colors.skyBlue
        // Do this settings, there is a bug if you dont set
        metalView.depthStencilPixelFormat = .depth32Float
        renderer = Renderer(device: device)
        
        //renderer?.scene = GameScene(device: device, size: view.bounds.size)
        renderer?.scene = InstanceScene(device: device, size: view.bounds.size)
        metalView.delegate = renderer
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
