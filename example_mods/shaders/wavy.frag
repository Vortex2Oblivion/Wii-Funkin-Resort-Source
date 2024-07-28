//SHADERTOY PORT FIX
#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
//SHADERTOY PORT FIX
uniform float frequency;
uniform float amplitude;
void main()
{
    vec2 texCoord = fragCoord.xy / iResolution.xy;
    
    vec2 pulse = sin(iTime - frequency * texCoord);
    float dist = 2.0 * length(texCoord.y - 0.5);
    
    vec2 newCoord = texCoord + amplitude * vec2(0.0, pulse.x + pulse.y);
    
    vec2 interpCoord = mix(newCoord, texCoord, dist);
	
	fragColor = texture(iChannel0, interpCoord);
}