shader_type canvas_item;

uniform vec4 flash_colour : source_color = vec4(1.0);
uniform float strength : hint_range(0.0, 1.0) = 0.;
void fragment() {
	vec4 colour = texture(TEXTURE, UV);
	colour.rgb = mix(colour.rgb, flash_colour.rgb, strength);
	COLOR = colour;
}
