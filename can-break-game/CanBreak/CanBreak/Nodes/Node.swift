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
    
    func add(childNode: Node){
        children.append(childNode)
    }
    
    // recursively renderer
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        for child in children {
            child.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        }
    }
}
