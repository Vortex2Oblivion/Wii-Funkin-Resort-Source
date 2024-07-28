package shaders;

import flixel.system.FlxAssets.FlxShader;

class ColorFillEffect
{
    public var shader(default,null):ColorFillShader = new ColorFillShader();
    public var red:Float = 0.0;
    public var green:Float = 0.0;
    public var blue:Float = 0.0;
    public var fade:Float = 1.0;
	public function new(r,g,b,f):Void
    {
        shader.red.value = [red];
        shader.green.value = [green];
        shader.blue.value = [blue];
        shader.fade.value = [fade];
    }
}

class ColorFillShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform float red;
        uniform float green;
        uniform float blue;
        uniform float fade;
        
        void main()
        {
            vec4 spritecolor = flixel_texture2D(bitmap, openfl_TextureCoordv);
            vec4 col = vec4(red/255,green/255,blue/255, spritecolor.a);
            vec3 finalCol = mix(col.rgb*spritecolor.a, spritecolor.rgb, fade);
        
            gl_FragColor = vec4( finalCol.r, finalCol.g, finalCol.b, spritecolor.a );
        }
    ')

    public function new()
    {
       super();
    }
}