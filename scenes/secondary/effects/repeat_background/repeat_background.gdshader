shader_type canvas_item;

uniform vec2 motion = vec2(-25);
uniform float scale = .25;

void vertex() {
	UV = (VERTEX + TIME * motion) * TEXTURE_PIXEL_SIZE * (1.0/scale);
}