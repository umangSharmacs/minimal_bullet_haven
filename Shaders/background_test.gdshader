shader_type canvas_item;

//void vertex() {
	//// Called for every vertex the material is visible on.
//}
uniform vec2 direction;
uniform float offset_x;
uniform float offset_y;

void fragment() {
	
	vec2 uv = UV; 
	//uv+= (TIME * direction * 0.01);
	uv.x += offset_x;
	uv.y += offset_y;
	
	vec4 textureColor = texture(TEXTURE, uv);
	
	COLOR = textureColor;
}
