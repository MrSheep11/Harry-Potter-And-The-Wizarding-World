#version 330
#extension GL_ARB_separate_shader_objects : require

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 AtlasSize;
};
layout(std140) uniform TileConfig {
    vec4 TileData; // atlas index, counter position (-1 for badge), width, height
};
layout(location = 0) out vec2 localPixel;

void main() {
    ivec4 Tile = ivec4(TileData);
    // Integer scaling keeps the art crisp: 192 px at 1080p, 256 px at 1440p.
    float scale = clamp(floor(min(OutSize.x / 280.0, OutSize.y / 180.0)), 1.0, 8.0);
    vec2 origin = vec2(6.0 * scale);
    if (Tile.y >= 0) {
        origin.y += 34.0 * scale;
        scale = max(1.0, floor(0.75 * scale + 0.5));
        origin.x += float(Tile.y == 0 ? 0 : 5 + 5 * Tile.y) * scale;
    }
    // Same winding as vanilla screenquad, but rasterize only the badge or digit.
    vec2 uv = vec2((gl_VertexIndex << 1) & 2, gl_VertexIndex & 2);
    localPixel = vec2(uv.x, 1.0 - uv.y) * vec2(Tile.zw);
    vec2 pixel = origin + localPixel * scale;
    gl_Position = vec4(pixel / OutSize * vec2(2.0, -2.0) + vec2(-1.0, 1.0), 0.0, 1.0);
}
