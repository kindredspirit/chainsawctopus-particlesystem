#version 130
precision lowp float;

in vec2 tex_coord;
uniform sampler2D unit_input;

void main()	{
	gl_FragColor = texture(unit_input, tex_coord);
	//gl_FragColor = vec4( pow(gl_FragColor.r,50.0) );
}
