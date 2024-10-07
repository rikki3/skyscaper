shader_type canvas_item;

uniform sampler2D screen_texture : source_color;
uniform float speed = 0.15;

void fragment() {
    float angle = TIME * speed; // Calculate rotation angle
    float s = sin(angle);
    float c = cos(angle);
    
    vec2 uv = UV - 0.5; // Move to center
    vec2 rotated_uv = vec2(
        uv.x * c - uv.y * s,
        uv.x * s + uv.y * c
    );
    rotated_uv += 0.5; // Move back to original position

    COLOR = texture(screen_texture, rotated_uv);
}
