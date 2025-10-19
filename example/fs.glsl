#version 140
in vec4 f_color;
in vec2 f_uv;
in vec2 f_atlas_pos;
in vec2 f_atlas_size;
in float f_scale;
out vec4 fragment;
uniform sampler2D u_tex;
uniform int u_tex_type;

vec4 sdf(vec4 col) {
	float d = (col.a - (128./255.)) / (32./255.);
	float w = 0.8 / f_scale;
	float a = 1.f - clamp((d + 0.5*w - 0.1) / w, 0., 1.);
	return vec4(col.rgb * a, a); // premultiply
}

void main() {
	vec4 color = vec4(f_color.rgb * f_color.a, f_color.a); // premult
	// Texture region wrapping
	vec2 uv = f_atlas_pos + fract(f_uv) * f_atlas_size;
	// Sample texture and handle RGBA vs A
	vec4 tex_color = vec4(1.);
	if (u_tex_type == 1) {
		// RGBA pre-multiplied
		tex_color = texture(u_tex, uv);
	} else if (u_tex_type == 2) {
		// Alpha (make pre-multiplied white)
		tex_color = vec4(texture(u_tex, uv).x);
	} else if (u_tex_type == 3) {
		// RGB SDF
		tex_color = sdf(texture(u_tex, uv));
	} else if (u_tex_type == 4) {
		// SDF
		tex_color = sdf(vec4(1.,1.,1.,texture(u_tex, uv).x));
	}
	fragment = tex_color * color;
}
