package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	var timeLeftText:FlxText;
	var timeLeft:Int = 5;

	override function create()
	{
		super.create();

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey, watch out!\n
			This Mod contains some flashing lights\n
			THAT CAN NOT BE TURNED OFF!!!\n
			You've been warned!",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		warnText.color = FlxColor.RED;
		add(warnText);

		timeLeftText = new FlxText(0, 600, FlxG.width,);
		timeLeftText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		timeLeftText.color = FlxColor.RED;
		add(timeLeftText);
		new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				timeLeft--;
			}, 5);
	}

	override function update(elapsed:Float)
	{
		if(timeLeft == 0){
			timeLeftText.text = "Continue...";
			FlxTween.color(warnText, 0.25, FlxColor.RED, FlxColor.WHITE);
			FlxTween.color(timeLeftText, 0.25, FlxColor.RED, FlxColor.WHITE);
		}
		else
			timeLeftText.text = Std.string(timeLeft);
		if(!leftState) {
			var back:Bool = controls.BACK;
			if ((controls.ACCEPT || back) && timeLeftText.text == "Continue..." ) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							FlxG.switchState(() ->new TitleState());
						}
					});
					FlxTween.tween(timeLeftText, {alpha: 0}, 1);
			}
		}
		//?????????????????????????????
		FlxG.save.data.flashing = true;
		FlxG.save.flush(); //this is the equivlant to saving thrice in a video game to be extra safe.
		super.update(elapsed);
	}
}
