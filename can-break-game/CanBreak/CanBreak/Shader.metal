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

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

struct VertexOut {
    float4 position [[ position ]];
    float4 color;
};

// in vertex func prefix -> vertex
// const device -> constant at device space
// constant -> at constant space
vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]]) {

    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    
    return vertexOut;
}

// in fragment func prefix -> fragment, half4 -> smaller float
fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
    return half4(vertexIn.color); // red color (r, g, b, a)
}
