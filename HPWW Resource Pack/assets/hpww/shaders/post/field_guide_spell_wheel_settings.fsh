#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D InSampler;
uniform sampler2D OverlaySampler;

layout(std140) uniform OverlayConfig {
    int PixelScale;
    int TopPadding;
};

layout(location = 0) in vec2 texCoord;
layout(location = 0) out vec4 fragColor;

void main() {
    ivec2 screenSize = textureSize(InSampler, 0);
    ivec2 pixel = ivec2(texCoord * vec2(screenSize));
    // Render targets are bottom-up; the uploaded PNG starts at its top row.
    pixel.y = screenSize.y - 1 - pixel.y;

    int scale = max(PixelScale, 1);
    ivec2 overlaySize = textureSize(OverlaySampler, 0) * scale;
    ivec2 origin = ivec2((screenSize.x - overlaySize.x) / 2, TopPadding);
    ivec2 local = pixel - origin;

    fragColor = texture(InSampler, texCoord);
    if (all(greaterThanEqual(local, ivec2(0))) && all(lessThan(local, overlaySize))) {
        vec4 overlay = texelFetch(OverlaySampler, local / scale, 0);
        fragColor.rgb = mix(fragColor.rgb, overlay.rgb, overlay.a);
    }
}
