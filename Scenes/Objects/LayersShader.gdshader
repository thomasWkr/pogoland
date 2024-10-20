shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform float modifier: hint_range(0.0,1.0) = 1;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, flash_color.rgb, modifier);
	COLOR = color;
}
