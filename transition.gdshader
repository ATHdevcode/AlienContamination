shader_type canvas_item;


uniform float change:hint_range(0.0, 1.0, 0.1);


void vertex() {
	//VERTEX = (MODEL_MATRIX * vec4(VERTEX,0.0,0.8)).xy;
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	COLOR = texture(TEXTURE, vec2(UV.x,UV.g));
	
	
	if(COLOR.a == 0.0){
		
		COLOR.a = change;
		COLOR.b = 0.0;
	
		
	}

	
	
	if (COLOR == vec4(1.0,1.0,1.0,1.0)){
		
		COLOR = texture(TEXTURE, vec2(UV.x,UV.y));
		
		COLOR.a = -change+1.0;
		
		//COLOR.a = UV.y;
		COLOR.r = 0.0;
		COLOR.b = 0.756;
	}
	//COLOR.a = 0.8;
	
	
	
	//COLOR.a = 1.0;
	//COLOR.r = UV.y;
	//OLOR.b = UV.x;
	
	//COLOR = vec4(UV.x,UV.y, core_color.r, core_color.g);
	
	//COLOR.a = alpha;
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
