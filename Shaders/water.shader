shader_type canvas_item;

uniform sampler2D noise1;
uniform sampler2D noise2;
uniform vec2 scroll1 = vec2(0.1, -0.2);
uniform vec2 scroll2 = vec2(-0.01, 0.08);

void fragment(){
	vec4 noise1_val = texture(noise1, UV + TIME*scroll1);
	vec4 noise2_val = texture(noise2, UV + TIME*scroll2);
	vec4 intensity = (noise1_val + noise2_val)/vec4(2.0);
	if(intensity.r+intensity.g+intensity.b+intensity.a>3.0)
		intensity = vec4(0.4,0.7,1,1);
	else if(intensity.r+intensity.g+intensity.b+intensity.a>2.9)
		intensity = vec4(0.1,0.5,1,1);
	else if(intensity.r+intensity.g+intensity.b+intensity.a>2.6)
		intensity = vec4(0.1,0.4,0.9,1);
	else if(intensity.r+intensity.g+intensity.b+intensity.a>2.3)
		intensity = vec4(0.1,0.3,0.85,1);
	else if(intensity.r+intensity.g+intensity.b+intensity.a>2.0)
		intensity = vec4(0.1,0.25,0.8,1);
	else
		intensity = vec4(0.1,0.2,0.7,1);
	COLOR = vec4(intensity);
}