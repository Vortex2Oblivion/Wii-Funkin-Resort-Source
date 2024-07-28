package shaders;

import flixel.system.FlxAssets.FlxShader;


class GlitchEffect {
    public var shader(default, null):GlitchShader = new GlitchShader();
    public var amount(default, set):Float = 0.0;
	public var speed(default, set):Float = 0.0;
    public var time(default, set):Float = 0.0;


	public function set_amount(value:Float) {
		amount = value;
		shader.AMT.value = [amount];
		return amount;
	}

	public function set_speed(value:Float) {
		speed = value;
		shader.SPEED.value = [speed];
		return speed;
	}

    public function set_time(value:Float) {
		time = value;
		shader.iTime.value = [time];
		return time;
	}

	public function new()
	{
		shader.AMT.value = [0.0];
        shader.SPEED.value = [0.0];
		shader.iTime.value = [0.0];
	}

    public inline function update(elapsed:Float){
        time += elapsed;
    }

}

class GlitchShader extends FlxShader {
    @:glFragmentSource('
    // Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel
    #pragma header

    #define iResolution vec3(openfl_TextureSize, 0.0)
    uniform float iTime;
    #define iChannel0 bitmap
    #define texture flixel_texture2D

    // third argument fix
    vec4 flixel_texture2D(sampler2D bitmap, vec2 coord, float bias) {
        vec4 color = texture2D(bitmap, coord, bias);
        if (!hasTransform)
        {
            return color;
        }
        if (color.a == 0.0)
        {
            return vec4(0.0, 0.0, 0.0, 0.0);
        }
        if (!hasColorTransform)
        {
            return color * openfl_Alphav;
        }
        color = vec4(color.rgb / color.a, color.a);
        mat4 colorMultiplier = mat4(0.0);
        colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
        colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
        colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
        colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
        color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
        if (color.a > 0.0)
        {
            return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
        }
        return vec4(0.0, 0.0, 0.0, 0.0);
    }

    //2D (returns 0.0 - 1.0)
    float random2d(vec2 n) { 
        return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
    }

    float randomRange (in vec2 seed, in float min, in float max) {
            return min + random2d(seed) * (max - min);
    }

    // return 1 if v inside 1d range
    float insideRange(float v, float bottom, float top) {
    return step(bottom, v) - step(top, v);
    }

    //inputs
    uniform float AMT;
    uniform float SPEED;
    
    void mainImage( out vec4 fragColor, in vec2 fragCoord )
    {
        
        float time = floor(iTime * SPEED * 60.0);    
        vec2 uv = fragCoord.xy / iResolution.xy;
        
        //copy orig
        vec3 outCol = texture(iChannel0, uv).rgb;
        
        //randomly offset slices horizontally
        float maxOffset = AMT/2.0;
        for (float i = 0.0; i < 10.0 * AMT; i += 1.0) {
            float sliceY = random2d(vec2(time , 2345.0 + float(i)));
            float sliceH = random2d(vec2(time , 9035.0 + float(i))) * 0.25;
            float hOffset = randomRange(vec2(time , 9625.0 + float(i)), -maxOffset, maxOffset);
            vec2 uvOff = uv;
            uvOff.x += hOffset;
            if (insideRange(uv.y, sliceY, fract(sliceY+sliceH)) == 1.0 ){
                outCol = texture(iChannel0, uvOff).rgb;
            }
        }
        
        //do slight offset on one entire channel
        float maxColOffset = AMT/6.0;
        float rnd = random2d(vec2(time , 9545.0));
        vec2 colOffset = vec2(randomRange(vec2(time , 9545.0),-maxColOffset,maxColOffset), 
                        randomRange(vec2(time , 7205.0),-maxColOffset,maxColOffset));
        if (rnd < 0.33){
            outCol.r = texture(iChannel0, uv + colOffset).r;
            
        }else if (rnd < 0.66){
            outCol.g = texture(iChannel0, uv + colOffset).g;
            
        } else{
            outCol.b = texture(iChannel0, uv + colOffset).b;  
        }
        
        fragColor = vec4(outCol,texture(iChannel0, uv).a);
    }

    void main() {
        mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
    }
    ')
    public function new()
        {
            super();
        }
}