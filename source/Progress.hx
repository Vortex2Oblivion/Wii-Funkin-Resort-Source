package; 

import flixel.util.FlxSave;

class Progress{

    public static var progressSave:FlxSave = new FlxSave();


    public static var saves:Map<String, FlxSave> = [];

    public static var bindPath:String = "wfr";

    public inline static function init()
    {
        createSaveFullPath("progress", "wfr-progress");
    }
    public static function createSaveFullPath(key:String, bindName:String)
        {
            var save = new FlxSave();
            save.bind(bindName, bindPath);
    
            saves.set(key, save);
        }
    
    public static function getData(dataKey:String):Dynamic
        {
            if(saves.exists("progress"))
                return Reflect.getProperty(Reflect.getProperty(saves.get("progress"), "data"), dataKey);
    
            return null;
        }
    
    public static function setData(value:Dynamic, dataKey:String)
        {
            if(saves.exists("progress"))
            {
                Reflect.setProperty(Reflect.getProperty(saves.get("progress"), "data"), dataKey, value);
    
                saves.get("progress").flush();
            }
        }
}