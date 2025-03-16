shader_type spatial;
uniform sampler2D display_source:repeat_disable;
uniform float distort;
uniform float scanline_scale;
uniform float scanline_strength;
uniform float scanline_speed;
uniform float emission_intensity;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	ROUGHNESS = 0.6;
	ALBEDO = vec3(0.,0.,0.);
	vec2 displayUV = UV-.5;
	vec2 centeredUV = (UV-.5)*2.;
	displayUV.x /= cos(centeredUV.y)*distort + 1. - distort;
	displayUV.y /= cos(centeredUV.x)*distort + 1. - distort;
	displayUV += .5;
	float super_scanline = abs(fract(displayUV.y*scanline_scale*.1-TIME*scanline_speed*.05)-.5)*2.;
	super_scanline = smoothstep(.95,1.,super_scanline);
	displayUV.x+=super_scanline*.01;
	float scanlines = sin(displayUV.y*scanline_scale*100.-TIME*scanline_speed);
	scanlines = scanlines * scanline_strength + 1.-scanline_strength;
	vec4 tex = texture(display_source,displayUV).rgba;
	EMISSION = tex.rgb *tex.a* emission_intensity * vec3(1.,1.,1.)*scanlines + (scanlines)*.05 + super_scanline * .05;
	//EMISSION = vec3(super_scanline);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
