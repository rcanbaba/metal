//
//  Texturable.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 28.10.2022.
//

import MetalKit

protocol Texturable {
    var texture: MTLTexture? { get set }
}

extension Texturable {
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: device)
        
        var texture: MTLTexture? = nil
        
        let textureLoaderOptions: [MTKTextureLoader.Option: NSObject]
        
        // TODO: learn how to set latest ios versions textureLoaderOptions
        let origin = NSString(string: MTKTextureLoader.Origin.bottomLeft.rawValue)
        
        textureLoaderOptions = [MTKTextureLoader.Option.origin: origin]
        if let textureURL = Bundle.main.url(forResource: imageName, withExtension: nil) {
            do {
                texture = try textureLoader.newTexture(URL: textureURL, options: textureLoaderOptions)
            } catch {
                print("texture not created")
            }
        }
        return texture
    }
}
