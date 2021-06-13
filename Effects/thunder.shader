shader_type canvas_item;

float plot(vec2 st, float pct){
	return smoothstep(pct-0.02, pct, st.y) - smoothstep(pct, pct+0.02, st.y);
}

float rand(vec2 n){
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 n){
	vec2 d = vec2(0.0,1.0);
	vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
	return mix(mix(rand(b), rand(b+d.xy), f.x), mix(rand(b+d.xy), rand(b+d.yy), f.x), f.y);
}

float fbm(vec2 n){
	float total = 0.0, amplitude = 1.0;
	for(int i = 0; i<7; i++){
		total+=noise(n) * amplitude;
		n+=n;
		amplitude*=0.5;
	}
	return total;
}

void fragment(){
	vec2 uv = UV;
	vec4 color = vec4(0.0, 0.0, 0.0, 0.0);
	vec2 t = uv * vec2(2.0, 1.0) - TIME*3.0;
	float y = fbm(t)*0.5;
	float pct = plot(uv, y);
	color+=pct*vec4(0.5, 0.5, 0.9, 1.0);
	COLOR = color;
}