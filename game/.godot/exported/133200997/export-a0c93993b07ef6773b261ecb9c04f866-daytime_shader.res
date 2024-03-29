RSRC                     Shader            ��������                                                  resource_local_to_scene    resource_name    code    script           local://Shader_cfb71 �          Shader          �  shader_type canvas_item;

uniform sampler2D day_time_colors : hint_default_white;

uniform float twilight_duration_factor = 1.0f;

uniform float current_time : hint_range(0, 1) = 0.0f;

uniform float sunrise_time : hint_range(0, 1) = 0.1f;
uniform float sunset_time : hint_range(0, 1) = 0.9f;

uniform float twilight_duration : hint_range(0, 1) = 0.2f;

uniform float shader_opacity : hint_range(0, 1) = 1.0f;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float get_time_color_pct() {
	float scaled_twilight_duration = twilight_duration * twilight_duration_factor;
	
	if (current_time < sunrise_time) {
		return 0.0f; // (Morning) night
	}
	else if (current_time < sunrise_time + scaled_twilight_duration) {
		// Divide by two as only the first half of the texture is used
		return (current_time - sunrise_time) / (2.0f * scaled_twilight_duration); // Sunrise fade
	}
	else if (current_time < sunset_time - scaled_twilight_duration) {
		return 0.5f; // Daytime
	}
	else if (current_time < sunset_time) {
		// Divide by two as only the second half of the texture is used
		return 0.5f + (current_time - (sunset_time - scaled_twilight_duration)) / (2.0f * scaled_twilight_duration); // Sunset fade
	}
	return 1.0f; // Night (evening)
}

void fragment() {
	vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	float x_pos = get_time_color_pct();
	vec4 sky_color = texture(day_time_colors, vec2(x_pos, 0.0f));
	sky_color.a = shader_opacity;
	COLOR = screen_color * sky_color;
}
       RSRC