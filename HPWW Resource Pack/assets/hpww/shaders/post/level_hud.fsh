#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D AtlasSampler;
layout(std140) uniform TileConfig {
    vec4 TileData;
};
layout(location = 0) in vec2 localPixel;
layout(location = 0) out vec4 fragColor;

void main() {
    ivec4 Tile = ivec4(TileData);
    ivec2 p = ivec2(floor(localPixel));
    if (any(lessThan(p, ivec2(0))) || any(greaterThanEqual(p, Tile.zw))) discard;
    int index = abs(Tile.x);
    if (Tile.y == 0) {
        if (p.x < 5 && index == 82) discard; // zero is unsigned
        if (p.x < 5) index = Tile.x < 0 ? 94 : 93;
        else p.x -= 5;
    }
    vec4 ink = texelFetch(AtlasSampler, ivec2(index % 16, index / 16) * 32 + p, 0);
    if (ink.a < 0.5) discard;
    fragColor = vec4(ink.rgb, 1.0);
}
