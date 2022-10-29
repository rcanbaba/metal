//
//  Camera.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 30.10.2022.
//

import MetalKit

class Camera: Node {
    
    var viewMatrix: matrix_float4x4 {
      return modelMatrix
    }
    
    // fov = field of view
    var fovDegrees: Float = 65
    var fovRadians: Float {
        return radians(fromDegrees: fovDegrees)
    }
    var aspect: Float = 1
    var nearZ: Float = 0.1
    var farZ: Float = 100
    
    var projectionMatrix: matrix_float4x4 {
        return matrix_float4x4(projectionFov: fovRadians, aspect: aspect, nearZ: nearZ, farZ: farZ)
    }
    
}
