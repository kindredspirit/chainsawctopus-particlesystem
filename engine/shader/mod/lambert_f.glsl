#version 130
precision lowp float;

float comp_diffuse(vec3 no, vec3 lit)	{
	return max( dot(no,lit), 0.0);
}