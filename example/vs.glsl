#version 140
in vec3 a_pos;
in vec2 a_uv;
in vec4 a_color;
in vec2 a_atlas_pos;
in vec2 a_atlas_size;
in float a_scale;

out vec4 f_color;
out vec2 f_uv;
out vec2 f_atlas_pos;
out vec2 f_atlas_size;
out float f_scale;

uniform vec2 u_view_size;
uniform vec2 u_tex_size;

void main() {
    f_color = a_color;
    f_scale = a_scale;
    f_uv = a_uv;
    f_atlas_pos = a_atlas_pos / u_tex_size;
    f_atlas_size = a_atlas_size / u_tex_size;
    gl_Position = vec4(2.0*a_pos.x/u_view_size.x - 1.0, 1.0 - 2.0*a_pos.y/u_view_size.y, 0, 1);
}