shader_type canvas_item;

uniform float Reducao;

uniform vec4 Cor : source_color;

uniform float Alpha_Cor : hint_range(0.0, 1.0, 0.05);

void vertex() {
	UV.x += TIME * Reducao;
	UV.y -= TIME * Reducao;
}

void fragment(){
	vec4 Texture_Color = texture(TEXTURE, UV) ;
	COLOR = mix(Texture_Color, Cor, Alpha_Cor);
}