shader_type canvas_item;

uniform sampler2D screen_texture : source_color;
uniform float speed = 0.15;

void fragment () {
	COLOR = texture(screen_texture, vec2(UV.x - TIME * speed, UV.y));
}