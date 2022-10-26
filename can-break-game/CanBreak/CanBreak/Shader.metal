//
//  Shader.metal
//  CanBreak
//
//  Created by Can Babaoğlu on 26.10.2022.
//

#include <metal_stdlib>
using namespace metal;


// in vertex func prefix -> vertex
vertex float4 vertex_shader(const device packed_float3 *vertices [[ buffer(0)]], uint vertexId [[ vertex_id]]) {
    return float4(vertices[vertexId], 1);
}

// in fragment func prefix -> fragment, half4 -> smaller float
fragment half4 fragment_shader() {
    return half4(1, 0, 0, 1); // red color (r, g, b, a)
}
