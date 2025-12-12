/*

Inspired by Apple Liquid Glass.


MIT License

Copyright (c) 2025 Vishnu Prakash Balaji

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

#version 320 es
precision highp float;

// Flutter's shader runtime helpers
#include <flutter/runtime_effect.glsl>

// ============================================================================
//                               CONSTANTS
// ============================================================================
#define PI         3.14159265359
#define BLUR_STEPS 12      // Number of samples per blur ring
#define MAX_RECTS  4       // Maximum supported glass rectangles

// ============================================================================
//                          INPUT UNIFORMS FROM FLUTTER
// ============================================================================

// Screen / container size in pixels
uniform vec2   u_size;

// Bounding box for shader (used to optimize rendering)
uniform vec4   uBounds;

// Distortion & blending parameters
uniform float  uBlendPx;           // Smooth-min blend size (for merging rects)
uniform float  uRefractStrength;   // Refraction strength (glass bending)
uniform float  uDistortFalloffPx;  // How quickly distortion fades inside
uniform float  uDistortExponent;   // Curve exponent for distortion falloff

// Radial blur
uniform float  uRadialBlurPx;

// Specular highlight (shiny bright reflections)
uniform float  uSpecAngle;
uniform float  uSpecStrength;
uniform float  uSpecPower;
uniform float  uSpecWidthPx;

// Lightband (glowing highlight strip)
uniform float  uLightbandOffsetPx;
uniform float  uLightbandWidthPx;
uniform float  uLightbandStrength;
uniform vec3   uLightbandColor;

// Anti-aliasing around glass edges
uniform float  uAAPx;

// Number of rectangles being drawn
uniform float  uRectCount;

// Per-rectangle uniforms
uniform vec4   uRect0;  uniform float uCorner0;  uniform vec4 uTintColor0;
uniform vec4   uRect1;  uniform float uCorner1;  uniform vec4 uTintColor1;
uniform vec4   uRect2;  uniform float uCorner2;  uniform vec4 uTintColor2;
uniform vec4   uRect3;  uniform float uCorner3;  uniform vec4 uTintColor3;

// Background texture (content behind the glass)
uniform sampler2D u_texture_input;

// Final output
out vec4 fragColor;

// ============================================================================
//                         UTILITY / HELPER FUNCTIONS
// ============================================================================

// Shorthand for normalized pixel conversion
// Convert px value to normalized unit based on screen height
#define R u_size
float px(float v) { return v / R.y; }

// Sample background with clamping (avoid edges going out of UV range)
vec3 bg(vec2 uv) {
    return texture(u_texture_input, clamp(uv, 0.0, 1.0)).rgb;
}

// Rectangle getter (GLSL lacks arrays of uniforms)
vec4 getRect(int i) {
    return (i==0)?uRect0 :(i==1)?uRect1 :(i==2)?uRect2 :uRect3;
}
float getCorner(int i) {
    return (i==0)?uCorner0 :(i==1)?uCorner1 :(i==2)?uCorner2 :uCorner3;
}
vec4 getTint(int i) {
    return (i==0)?uTintColor0 :(i==1)?uTintColor1 :(i==2)?uTintColor2 :uTintColor3;
}

// Signed distance to a rounded rectangle
// Negative: inside
// Zero: at border
// Positive: outside
float sdRoundRect(vec2 p, vec2 halfSize, float radius) {
    vec2 q = abs(p) - (halfSize - vec2(radius));
    return length(max(q, vec2(0.0))) + min(max(q.x, q.y), 0.0) - radius;
}

// Smooth minimum (used to combine multiple rectangles smoothly)
float sminPoly(float a, float b, float k) {
    float h = clamp(0.5 + 0.5*(b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

// Radial blur used inside the glass
vec3 radialBlur(vec2 uv, float radiusPx) {
    if (radiusPx < 0.5) return bg(uv);

    vec3 sum = bg(uv);
    float nr = px(radiusPx); // normalized radius
    int count = 1;

    // 4 nested rings of blur
    for (int ring = 1; ring <= 4; ++ring) {
        float rad = nr * float(ring) / 4.0;

        for (int j = 0; j < BLUR_STEPS; ++j) {
            float a = float(j) * 2.0 * PI / float(BLUR_STEPS);
            sum += bg(uv + vec2(cos(a), sin(a)) * rad);
            count++;
        }
    }

    return sum / float(count);
}

// ============================================================================
//                                     MAIN
// ============================================================================
void main() {

    // ----------------------------------------
    // Fragment coordinate
    // ----------------------------------------
    vec2 fragPx = FlutterFragCoord().xy;

    #ifdef IMPELLER_TARGET_OPENGLES
    // Fix Y-flip on GLES
    fragPx.y = R.y - fragPx.y;
    #endif

    // If pixel is outside the shader bounds, return background only
    if (fragPx.x < uBounds.x || fragPx.x > uBounds.z ||
    fragPx.y < uBounds.y || fragPx.y > uBounds.w) {
        fragColor = texture(u_texture_input, fragPx / R);
        return;
    }

    // Normalize coordinates
    vec2 uv0 = fragPx / R;
    vec2 uvCenter = (fragPx - 0.5 * R) / R.y;

    // For merging rectangles
    float blendK = px(uBlendPx);
    int rectCount = int(uRectCount);

    // Signed distances
    float dUnion = 0.0;
    float d[MAX_RECTS];

    // ----------------------------------------
    // Compute distance for each rectangle
    // ----------------------------------------
    for (int i = 0; i < MAX_RECTS; ++i) {

        // Ignore rects outside rectCount
        if (i >= rectCount) {
            d[i] = 1e5;
            continue;
        }

        vec4 r = getRect(i);

        #ifdef IMPELLER_TARGET_OPENGLES
        // Flip Y for Flutter
        r.y = R.y - r.y;
        #endif

        // Convert rect to normalized values
        vec2 halfSize = (r.zw * 0.5) / R.y;
        vec2 center = (r.xy - 0.5 * R) / R.y;

        // SDF for the rounded rectangle
        d[i] = sdRoundRect(uvCenter - center, halfSize, getCorner(i) / R.y);

        // Smooth union blend
        dUnion = (i == 0) ? d[i] : sminPoly(dUnion, d[i], blendK);
    }

    // ----------------------------------------
    // Create mask for glass region
    // ----------------------------------------
    float mask = smoothstep(px(uAAPx), -px(uAAPx), dUnion);

    // ----------------------------------------
    // Compute gradient (normal of the SDF)
    // ----------------------------------------
    vec2 grad = vec2(dFdx(dUnion), dFdy(dUnion));

    #ifdef IMPELLER_TARGET_OPENGLES
    grad.y = -grad.y;
    #endif

    grad = normalize(grad + 1e-6);

    // ----------------------------------------
    // Compute refraction distortion
    // ----------------------------------------
    float falloff = pow(
    smoothstep(-px(uDistortFalloffPx), 0.0, dUnion),
    uDistortExponent
    );

    vec2 refrOffset = grad * falloff * uRefractStrength * mask;

    #ifdef IMPELLER_TARGET_OPENGLES
    refrOffset.y = -refrOffset.y;
    #endif

    // ----------------------------------------
    // Background with radial blur and refraction
    // ----------------------------------------
    vec3 glassBase = radialBlur(uv0 + refrOffset * 0.6, uRadialBlurPx);

    // ----------------------------------------
    // Accumulate tint colors from all rectangles
    // ----------------------------------------
    vec3 accum = vec3(0.0);
    float wSum = 0.0;

    for (int i = 0; i < MAX_RECTS; ++i) {
        if (i >= rectCount) break;

        float weight = exp(-d[i] / blendK);
        vec4 tint = getTint(i);

        // Apply per-rect tint via alpha
        accum += mix(glassBase, tint.rgb, tint.a) * weight;
        wSum += weight;
    }

    // Final tinted glass color
    vec3 glass = accum / wSum;

    // ----------------------------------------
    // Specular highlights (two opposite light directions)
    // ----------------------------------------
    vec3 N3 = normalize(vec3(grad, 0.6));
    vec3 L1 = normalize(vec3(cos(uSpecAngle),  sin(uSpecAngle),  0.5));
    vec3 L2 = normalize(vec3(-cos(uSpecAngle), -sin(uSpecAngle), 0.5));

    float rim = smoothstep(px(-uSpecWidthPx), 0.0, dUnion);

    glass += (
    pow(max(dot(N3, L1), 0.0), uSpecPower) +
    pow(max(dot(N3, L2), 0.0), uSpecPower)
    ) * uSpecStrength * rim;

    // ----------------------------------------
    // Lightband (bright strip highlight)
    // ----------------------------------------
    float lb = smoothstep(0.0, px(uLightbandWidthPx),
    dUnion + px(uLightbandOffsetPx));

    glass += uLightbandColor * lb * uLightbandStrength;

    // ----------------------------------------
    // Final blending with background
    // ----------------------------------------
    fragColor = vec4(mix(bg(uv0), glass, mask), 1.0);
}
