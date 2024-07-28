#pragma header

#define round(a) floor(a + 0.5)
#define texture flixel_texture2D
#define iResolution openfl_TextureSize
#define iChannel0 bitmap
#define focusDetail 7.0

uniform float posX; // from 0.0 to 1.0
uniform float posY; // from 0.0 to 1.0
uniform float focusPower; // 10.0

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec2 pos = vec2(posX, posY);
	vec2 focus = uv - pos;

	vec4 outColor = vec4(0.0);

	for (int i=0; i< int(focusDetail); i++) {
		float power = 1.0 - focusPower * (1.0/iResolution.x) * float(i);
		outColor += texture(iChannel0, focus * power + pos);
	}
	
	outColor *= 1.0 / focusDetail;

	fragColor = outColor;
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}