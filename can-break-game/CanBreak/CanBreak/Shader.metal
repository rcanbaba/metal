//
//  Shader.metal
//  CanBreak
//
//  Created by Can Babaoğlu on 26.10.2022.
//

#include <metal_stdlib>
using namespace metal;

struct ModelConstants {
    float4x4 modelViewMatrix;
};

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 textureCoordinates [[ attribute(2) ]];
};

struct VertexOut {
    float4 position [[ position ]];
    float4 color;
    float2 textureCoordinates;
};

struct SceneConstants {
    float4x4 projectionMatrix;
};

// in vertex func prefix -> vertex
// const device -> constant at device space
// constant -> at constant space
vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                               constant ModelConstants &modelConstants [[ buffer(1) ]],
                               constant SceneConstants &sceneConstants [[ buffer(2) ]]) {

    VertexOut vertexOut;
    
    float4x4 matrix = sceneConstants.projectionMatrix * modelConstants.modelViewMatrix;
    vertexOut.position = matrix * vertexIn.position;
    
    vertexOut.color = vertexIn.color;
    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
    
    return vertexOut;
}

// in fragment func prefix -> fragment, half4 -> smaller float
fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
    return half4(vertexIn.color);
}

fragment half4 textured_fragment(VertexOut vertexIn [[ stage_in ]],
                                 sampler sampler2d [[ sampler(0) ]],
                                 texture2d<float> texture [[ texture(0) ]]) {
    
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    // if the color alpha = 0, discard there
    if (color.a == 0.0) {
        discard_fragment();
    }
    return half4(color.r, color.g, color.b, 1);
}

fragment half4 textured_mask_fragment(VertexOut vertexIn [[ stage_in ]],
                                      texture2d<float> texture [[ texture(0) ]],
                                      texture2d<float> maskTexture [[ texture(1)]],
                                      sampler sampler2d [[ sampler(0) ]]) {
    
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    float4 maskColor = maskTexture.sample(sampler2d, vertexIn.textureCoordinates);
    float maskOpacity = maskColor.a;
    // if the opacity < 0.5, fragment will be empty when rendered.
    if (maskOpacity < 0.5) {
        discard_fragment();
    }
    return half4(color.r, color.g, color.b, 1);
}
