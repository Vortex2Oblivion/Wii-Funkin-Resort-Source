package shaders;

import flixel.system.FlxAssets.FlxShader;


class ScreenShader extends FlxShader {

    @:glFragmentSource('
        #pragma header

        uniform sampler2D sourceBitmap;

        void main()
        {
            vec2 st = openfl_TextureCoordv.xy;  // Note, already normalized
            gl_FragColor = flixel_texture2D(sourceBitmap, st);
        }
    ')

    public function new()
    {
        super();
    }
}