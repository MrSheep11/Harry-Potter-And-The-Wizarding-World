#version 330
#extension GL_ARB_separate_shader_objects : require

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#include <minecraft:fog.glsl>
#endif

#include <minecraft:dynamictransforms.glsl>
#include <minecraft:oit.glsl>

uniform sampler2D Sampler0;

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
layout(location = 0) in float sphericalVertexDistance;
layout(location = 1) in float cylindricalVertexDistance;
#endif

layout(location = 2) in vec4 vertexColor;
layout(location = 3) in vec2 texCoord0;
layout(location = 4) flat in float hpwwGuiMarker;
layout(location = 5) in vec2 hpwwGuiLocalOffset;

#ifndef OIT_ALPHA_ONLY
layout(location = 0) out vec4 fragColor;
#endif

vec2 hpwwGuiFlipTexCoord(vec2 uv) {
    float localDx = dFdx(hpwwGuiLocalOffset.x);
    if (abs(localDx) >= 0.00001) {
        float uPerLocalX = dFdx(uv.x) / localDx;
        uv.x -= 2.0 * hpwwGuiLocalOffset.x * uPerLocalX;
    }

    float localDy = dFdy(hpwwGuiLocalOffset.y);
    if (abs(localDy) < 0.00001) {
        return uv;
    }

    float vPerLocalY = dFdy(uv.y) / localDy;
    uv.y -= 2.0 * hpwwGuiLocalOffset.y * vPerLocalY;
    return uv;
}

void main() {
    vec2 hpwwSampleCoord = hpwwGuiMarker > 0.5 ? hpwwGuiFlipTexCoord(texCoord0) : texCoord0;

#ifdef IS_GRAYSCALE
    vec4 texColor = texture(Sampler0, hpwwSampleCoord).rrrr;
#else
    vec4 texColor = texture(Sampler0, hpwwSampleCoord);
#endif

    bool hpwwUsesControlColor = hpwwGuiMarker > 0.5;

#ifdef IS_SEE_THROUGH
    vec4 color = hpwwUsesControlColor ? texColor : texColor * vertexColor;
#else
    vec4 color = hpwwUsesControlColor ? texColor * ColorModulator : texColor * vertexColor * ColorModulator;
#endif
    if (color.a < 0.1) {
        discard;
    }

#ifdef OIT_ACCUMULATE
    color = sampleColorForAccumulation(color);
#endif
#if !defined(IS_SEE_THROUGH) && !defined(IS_GUI)
#ifdef OIT_ACCUMULATE
    vec4 hpwwFogColor = vec4(FogColor.rgb * color.a, FogColor.a);
#else
    vec4 hpwwFogColor = FogColor;
#endif
    color = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, hpwwFogColor);
#endif
#ifdef OIT_ALPHA_ONLY
    executeAlphaOnlyPhase(gl_FragCoord.z, color.a);
#else
    fragColor = color;
#endif
}
