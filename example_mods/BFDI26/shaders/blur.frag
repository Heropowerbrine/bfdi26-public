#pragma header

// SHADER BY EXISTICAL ON SHADERTOY https://www.shadertoy.com/view/Xltfzj i only ported and edited it a bit

vec2 uv = openfl_TextureCoordv.xy;
float pi = 6.28318530718; // Pi * 2
uniform float directions;
uniform float quality;
uniform float size;
uniform float merge;

void main() {
    vec2 radius = size / openfl_TextureSize.xy;
	vec4 ocolor = texture2D(bitmap, uv);
    vec4 color = texture2D(bitmap, uv);
	
    // Blur calculations
    for (float d = 0.0; d < pi; d += pi / directions) {
		for (float i = 1.0 / quality; i < 1.001; i += 1.0 / quality) {
			color += texture2D(bitmap, uv + vec2(cos(d), sin(d) * 2) * radius * i);		
        }
    }
    
    color /= quality * directions + 1.0;
    gl_FragColor = ocolor * (1.0 - merge) + color * merge;
}