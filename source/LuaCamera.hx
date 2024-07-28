import openfl.filters.BitmapFilter;

typedef LuaCamera =
{
    var cam:FlxCamera;
    var shaders:Array<BitmapFilter>;
    var shaderNames:Array<String>;
}