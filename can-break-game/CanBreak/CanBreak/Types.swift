//
//  Model.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 27.10.2022.
//

import simd

struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
    var texture: SIMD2<Float>
}

struct ModelConstants {
    var modelViewMatrix = matrix_identity_float4x4
    var materialColor = SIMD4<Float>(repeating: 1)
    var normalMatrix = matrix_identity_float3x3
    var specularIntensity: Float = 1
    var shininess: Float = 1
}

struct SceneConstants {
    var projectionMatrix = matrix_identity_float4x4
}

struct Light {
    var color = SIMD3<Float>(repeating: 1)
    var ambientIntensity: Float = 1.0
    var diffuseIntensity: Float = 1.0
    var direction = SIMD3<Float>(repeating: 0)
}
