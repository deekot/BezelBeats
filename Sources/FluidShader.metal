#include <metal_stdlib>
using namespace metal;

// 3D Tube Signed Distance Function
float sdRoundedBox(float2 p, float2 b, float r) {
    float2 q = abs(p) - b + r;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

[[ stitchable ]] half4 fluidShader(float2 position, half4 currentColor, float time, float amplitude, float2 screenSize) {
    
    // Normalize coordinates (-1 to 1)
    float2 uv = (position - 0.5 * screenSize) / screenSize.y;
    
    // Bezel Settings
    float borderThickness = 0.03; // Approx half-inch relative to screen height
    float2 boxSize = float2(screenSize.x / screenSize.y * 0.5 - borderThickness, 0.5 - borderThickness);
    
    // Calculate distance field for the border
    float d = sdRoundedBox(uv, boxSize, 0.05);
    
    // Create the "Hollow" effect (only draw the edge)
    float edge = abs(d) - borderThickness;
    
    // If we are inside the transparent middle, return clear
    if (d < 0.0 && abs(d) > borderThickness) {
        return half4(0, 0, 0, 0);
    }
    
    // --- FLUID INK EFFECT ---
    // Warp UVs with sine waves based on time & audio
    float2 warp = uv;
    warp.x += sin(warp.y * 10.0 + time * 2.0) * 0.02 * (1.0 + amplitude);
    warp.y += cos(warp.x * 10.0 + time * 1.5) * 0.02 * (1.0 + amplitude);
    
    // Color Palette (Neon Cyan, Purple, Magenta)
    float3 col1 = float3(0.0, 1.0, 1.0); // Cyan
    float3 col2 = float3(0.8, 0.0, 1.0); // Purple
    float3 col3 = float3(1.0, 0.0, 0.5); // Magenta
    
    // Mix colors based on position and warp
    float mixFactor = sin(warp.x * 5.0 + time) * 0.5 + 0.5;
    float3 finalColor = mix(col1, col2, mixFactor);
    finalColor = mix(finalColor, col3, sin(warp.y * 8.0 - time) * 0.5 + 0.5);
    
    // --- 3D CYLINDRICAL LIGHTING ---
    // We use the distance from the center of the border line (edge variable)
    // 'edge' goes from -thickness to +thickness.
    // Map -thickness (inner) to dark, 0 (center) to bright, +thickness (outer) to dark
    
    float normalizedDist = edge / borderThickness; // -1 to 1
    
    // Specular Highlight (The "Shiny Tube" look)
    float light = 1.0 - abs(normalizedDist);
    light = pow(light, 3.0); // Sharpen the highlight
    
    // Apply lighting
    finalColor *= (0.5 + light * 1.5); // Boost brightness at center of tube
    
    return half4(half3(finalColor), 1.0);
}
