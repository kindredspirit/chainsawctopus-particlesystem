#version 130

uniform struct Spatial	{
	vec4 pos,rot;
}s_cam;
uniform vec4 proj_cam, screen_size;


vec3 trans_inv(vec3,Spatial);
vec4 get_projection(vec3,vec4);

float get_project_scale(vec4 pos, vec4 pr)	{
	float ortho = step( 0.0, proj_cam.w ) ;
	float kpers = 1.0 / (s_cam.pos.w * pos.w);
	return screen_size.z * mix( kpers, proj_cam.x, ortho );
}

void part_draw(vec3 pos, float size)	{
	gl_Position = get_projection( trans_inv(pos, s_cam), proj_cam );
	gl_PointSize = 2.0*size * get_project_scale( gl_Position, proj_cam );
}