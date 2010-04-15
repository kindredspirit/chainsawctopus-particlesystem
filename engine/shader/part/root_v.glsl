#version 130

in	vec3 at_sys;
out	vec3 to_sys;

uniform vec4 cur_time;
uniform float part_total;

vec3 part_time()	{
	// frame time, life time, global time, last death moment
	return vec3(cur_time.y, cur_time.x - to_sys.x, cur_time.x);
}
vec2 part_uni()	{
	return vec2( to_sys.y * part_total, to_sys.z );
}
float random(float seed)	{
	return fract(sin( 78.233*seed ) * 43758.5453);
}

float reset();
float update();
bool born_ready();

void main()	{
	to_sys = at_sys;
	float live = 1.0;
	if(at_sys.x > 0.0)
		live = update();
	else if( born_ready() )	{
		to_sys.x = cur_time.x;
		to_sys.z += 1.0;
		live = reset();
	}
	to_sys.x *= 2.0*live-1.0;
}