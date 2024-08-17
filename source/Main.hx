package;

import flixel.system.FlxAssets;
import haxe.Json;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import backend.SpecsState;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.app.Application;

#if desktop
import Discord.DiscordClient;
#end

//crash handler stuff
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import haxe.Http;
#end

using StringTools;
using flixel.util.FlxSpriteUtil;

class Main extends Sprite
{
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: TitleState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public static var fpsVar:FPS;

	public static final devBuild:Bool = #if dev_build true #else false #end;


	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{

		#if (flixel < "5.6.0")
		#error "update your flixel boy\nhaxelib upgrade flixel"
		#end

		#if html5 
		#error "pls dont steal kbh games"
		#end

		//FlxAssets.FONT_DEFAULT = "assets/fonts/wii.ttf";
		//FlxAssets.FONT_DEBUGGER = "assets/fonts/wii.ttf";

		Lib.current.addChild(new Main());
		FlxG.mouse.load(new FlxSprite().loadGraphic(Paths.image("pointer")).pixels);
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}
	
		ClientPrefs.loadDefaultKeys();
		addChild(new FlxGame(game.width, game.height, game.initialState, game.framerate, game.framerate, game.skipSplash, game.startFullscreen));

		#if !mobile
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.showFPS;
		}
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
		
		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end

		#if desktop
		if (!DiscordClient.isInitialized) {
			DiscordClient.initialize();
			Application.current.window.onClose.add(function() {
				DiscordClient.shutdown();
			});
		}
		#end
		// shader coords fix
		FlxG.signals.gameResized.add(function (w, h) {
			if (FlxG.cameras != null) {
			  for (cam in FlxG.cameras.list) {
			   @:privateAccess
			   if (cam != null && cam.filters != null)
				   resetSpriteCache(cam.flashSprite);
			  }
			}

			if (FlxG.game != null)
			resetSpriteCache(FlxG.game);
	   });
	}
	static function resetSpriteCache(sprite:Sprite):Void {
		@:privateAccess {
		        sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "WFR_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg = "--->|Crash Handler written by: sqirra-rng, modified by DeRealTurbo|<---\n\n" + errMsg;
		errMsg += "\nUncaught Error: " + e.error + "\n";

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		errMsg += "\n\n" + SpecsState.toString() + "\n";

		File.saveContent(path, errMsg + "\n");

		//note to self, remove this before releasing source code.
		/*var request:Http = new Http("nuh uh");

		request.onStatus = (status) -> {
			trace("onStatus");
			trace(status);
		};
	
		request.onError = (msg) -> {
			trace("onError");
			trace(msg);
		};
	
		request.onData = function(data) {
			trace("onData");
			trace(data);
		}
	
		
		@:privateAccess
		request.setPostData(Json.stringify({
			content: 'A crash has happened on: ' + Type.getClassName(Type.getClass(FlxG.state)) + "\nThe details are as followed:",
			username: "Tommy from Wii Funkin' Resort",
			avatar_url:"https://www.mediafire.com/convkey/d784/aqs2p47xqgc5yfk9g.jpg?size_id=5",
			embeds: [{
				color: 0xFF0000,
				title: "Error!",
				description: errMsg
			}]
		}));
		request.addHeader("Content-Type","application/json");
		request.request(true);*/

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		//systools.Dialogs.message("Error!", errMsg, true);
		DiscordClient.shutdown();
		Sys.exit(1);
	}
	#end
}
