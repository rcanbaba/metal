//
//  Shader.metal
//  CanBreak
//
//  Created by Can Babaoğlu on 26.10.2022.
//

#include <metal_stdlib>
using namespace metal;

struct Constants {
    float animateBy;
};

// in vertex func prefix -> vertex
// const device -> constant at device space
// constant -> at constant space
vertex float4 vertex_shader(const device packed_float3 *vertices [[ buffer(0) ]],
                            constant Constants &constants [[ buffer(1) ]],
                            uint vertexId [[ vertex_id]]) {
    float4 position = float4(vertices[vertexId], 1);
    position.x += constants.animateBy;
    return position;
}

// in fragment func prefix -> fragment, half4 -> smaller float
fragment half4 fragment_shader() {
    return half4(1, 0, 0, 1); // red color (r, g, b, a)
}
