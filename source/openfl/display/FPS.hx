package openfl.display;

import haxe.macro.Compiler;
import flixel.FlxG;
import lime.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
import external.memory.Memory;

using StringTools;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField {
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	//what the fuck hxcpp
	public static var memoryInUse:String;
	public static var memoryPeak:String;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000) {
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("assets/fonts/wii.ttf", 14, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void {
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000) {
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentFPS > ClientPrefs.framerate)
			currentFPS = ClientPrefs.framerate;

		if (currentCount != cacheCount /*&& visible*/) {
			text = "FPS: " + currentFPS;
			var memoryMegas:Float = 0;

			memoryInUse = CoolUtil.formatBytes(Memory.getCurrentUsage());
			memoryPeak = CoolUtil.formatBytes(Memory.getPeakUsage());

			#if openfl
			text += '\nMemory: ${memoryInUse} / ${CoolUtil.formatBytes(Memory.getPeakUsage())}';
			#end

			textColor = 0xFFFFFFFF;
			if (memoryMegas > 3000 || currentFPS <= ClientPrefs.framerate / 2) {
				textColor = 0xFFFF0000;
			}

			if(ClientPrefs.showDebugInfo){
				#if !FLX_NO_POINT_POOL
				@:privateAccess
				text += "\nFlxPoint: " + flixel.math.FlxPoint.FlxBasePoint.pool._count;
				#end

				#if (gl_stats && !disable_cffi && (!html5 || !canvas))
				text += "\nTotal Draw Calls: " + Context3DStats.totalDrawCalls();
				/*text += "\nStage Draw Calls: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
				text += "\nStage 3D Draw Calls: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);*/
				#end

				text += "\nOS: " + System.platformLabel;
				text += "\nHaxe: " + Compiler.getDefine("haxe");
				text += "\nHaxeFlixel: " + Std.string(FlxG.VERSION);
				text += "\nOpenFL: " + Compiler.getDefine("openfl");
				text += "\nLime: " + Compiler.getDefine("lime");

				text += "\nState: " + Type.getClassName(Type.getClass(FlxG.state));
				text += "\nSubstate: " + Type.getClassName(Type.getClass(FlxG.state.subState)) ?? "No SubState";
			}


			text += "\n";
		}

		cacheCount = currentCount;
	}
}
