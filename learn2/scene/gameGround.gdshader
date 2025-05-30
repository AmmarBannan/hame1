shader_type canvas_item;
render_mode blend_mix, unshaded;

// Glass properties
uniform vec4 glass_color : source_color = vec4(0.8, 0.9, 1.0, 0.7);
uniform float ior : hint_range(0.9, 3.0) = 1.5; // Index of Refraction
uniform float roughness : hint_range(0.0, 1.0) = 0.1;
uniform float thickness : hint_range(0.0, 1.0) = 0.5;

// Light distortion effects
uniform float distortion_strength : hint_range(0.0, 0.1) = 0.02;
uniform float chromatic_shift : hint_range(0.0, 0.05) = 0.01;
uniform float fresnel_power : hint_range(0.0, 10.0) = 5.0;

// Environment reflection
uniform sampler2D reflection_texture;
uniform float reflection_intensity : hint_range(0.0, 1.0) = 0.3;

// Required for screen reading
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest_mipmap;

void fragment() {
    // Calculate screen UVs
    vec2 uv = SCREEN_UV;
    
    // Create distortion pattern (simulating glass imperfections)
    vec2 distortion;
    distortion.x = sin(uv.y * 100.0 + TIME * 2.0) * 0.005;
    distortion.y = cos(uv.x * 80.0 + TIME * 1.5) * 0.005;
    
    // Apply thickness-based distortion
    distortion *= thickness * distortion_strength;
    
    // Chromatic aberration (color separation)
    vec3 refracted_color;
    refracted_color.r = texture(screen_texture, uv + distortion * (1.0 + chromatic_shift)).r;
    refracted_color.g = texture(screen_texture, uv + distortion).g;
    refracted_color.b = texture(screen_texture, uv + distortion * (1.0 - chromatic_shift)).b;
    
    // Fresnel effect (edges reflect more)
    vec3 view_dir = normalize(-vec3(FRAGCOORD.xy, 1.0));
    float fresnel = pow(1.0 - abs(dot(view_dir, vec3(0.0, 0.0, 1.0))), fresnel_power);
    
    // Sample reflection
    vec3 reflection = texture(reflection_texture, uv + distortion * 2.0).rgb;
    
    // Combine effects
    vec3 final_color = mix(refracted_color, reflection, fresnel * reflection_intensity);
    
    // Apply glass tint and roughness
    final_color *= glass_color.rgb;
    final_color = mix(final_color, vec3(0.5), roughness * 0.5);
    
    // Output with transparency
    COLOR = vec4(final_color, glass_color.a);
}