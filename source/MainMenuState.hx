package;

import lime.media.openal.AL;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import openfl.Lib;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import shaders.GlitchEffect;


using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public static var curDiff:Int = 0;
	public static var diff:String = '';

	var menuItems:FlxTypedGroup<FlxSprite>;
	//private var camGame:FlxCamera;

	// private static var lastDifficultyName:String = '';
	// var curDifficulty:Int = -1;

	public static var difficulty:Array<String> = [
		'hard',
		'hard',
		'hard'
	];
	
	var optionShit:Array<String> = [
		'swordfightsport',
		'boxingsport',
		'basketsport',
		'remixes',
		'freeplay',
		'credits',
		'options'
		//#if MODS_ALLOWED 'mods', #end
		//#if ACHIEVEMENTS_ALLOWED 'awards', #end
	];

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var diffText:FlxText;
	var text:FlxText;

	var dumbTimer:FlxTimer = new FlxTimer();

	var glitch:GlitchEffect = new GlitchEffect();

	var undoDaPitch:Bool = false;


	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("main menu", null);
		#end
		
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		FlxG.mouse.visible = true;

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuback'));
		//bg.scrollFactor.set(0, yScroll);
		//bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var bars:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menubars'));
		//bars.scrollFactor.set(0, yScroll);
		//bars.setGraphicSize(Std.int(bars.width * 1.175));
		bars.updateHitbox();
		bars.screenCenter();
		bars.antialiasing = ClientPrefs.globalAntialiasing;
		add(bars);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		glitch.speed = 0.225;
		glitch.amount = 0.15;
		glitch.time = 0.0;


		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = 1;
			menuItem.scale.y = 1;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " hover", 12);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " press", 12);
			menuItem.animation.play('idle');
			trace(i + '-mainmenu/' + optionShit[i]);
			if(i == 3 && !Progress.getData('playedDefected') && Progress.getData('defectedInMenu')){
				menuItem.shader = glitch.shader;
				trace("glitch");
			}
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();

			switch (i)
			{
				case 0:
				menuItem.y = 0;
				menuItem.x = 0;
				case 1:
				menuItem.y = 0;
				menuItem.x = 0;
				case 2:
				menuItem.y = 0;
				menuItem.x = 0;
				case 3:
				menuItem.y = 0;
				menuItem.x = 0;
				case 4:
				menuItem.y = 0;
				menuItem.x = 0;
				case 5:
				menuItem.y = 0;
				menuItem.x = 0;
				case 6:
				menuItem.y = 0;
				menuItem.x = 0;

			}
		}


		text = new FlxText(400, 0, 0, "Press shift to change difficulty", 12);
		text.scrollFactor.set();
		text.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(text);

		diffText = new FlxText(550, 20, 0, "", 12);
		diffText.scrollFactor.set();
		diffText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(diffText);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();
		changediff();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();

		Conductor.changeBPM(128);

		
	}




	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{

		glitch.update(elapsed);

		

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			//if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-4);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(4);
			}
			if (FlxG.keys.justPressed.SHIFT)
			{
				changediff(1);
			}

			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(() ->new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'youtube')
				{
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'swordfightsport':
										PlayState.storyPlaylist = ['sword up', 'kendo', 'true edge'];
										playweek();
									case 'boxingsport':
										PlayState.storyPlaylist = ['mobility', 'glove check', 'final fist'];
										playweek();
									case 'basketsport':
										PlayState.storyPlaylist = ['tommy', 'ones', 'overtime'];
										playweek(false);
									case 'remixes':
										if(!Progress.getData('playedDefected') && Progress.getData('defectedInMenu')){
											PlayState.storyPlaylist = ['proto', 'gba', 'parasitic'];
											playweek(true);
											undoDaPitch = true;
										}
										else
											FlxG.switchState(() ->new StoryMenuState());
									case 'freeplay':
										FlxG.switchState(() ->new FreeplayState());
									case 'credits':
										FlxG.switchState(() ->new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
						}
					});
				}
			}
			#if dev_build
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				FlxG.switchState(() ->new MasterEditorMenu());
			}
			#end
		}

		if (FlxG.sound.music != null){

			Conductor.songPosition = FlxG.sound.music.time;
		}


		

		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));

		super.update(elapsed);

		Lib.application.window.title = "Wii Funkin' Resort";

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	override function beatHit(){
		super.beatHit();


		if (FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms)
			FlxG.camera.zoom += 0.03;
	}

	inline function doesOverlap(spr:FlxSprite):Bool
		return FlxG.mouse.overlaps(spr);


	function playweek(?isPibby:Bool = false) {
		PlayState.isStoryMode = true;
		PlayState.mainmenu = true;
		diff = difficulty[curDiff];
		if (difficulty[curDiff] != 'normal')
		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-' + diff, PlayState.storyPlaylist[0].toLowerCase());
		else
		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(), PlayState.storyPlaylist[0].toLowerCase());
		PlayState.campaignScore = 0;
		PlayState.campaignMisses = 0;
		if(isPibby){
			LoadingState.loadAndSwitchState(new IndieCrossLmao());
		}
		else{
			LoadingState.loadAndSwitchState(new PlayState());
		}
		FreeplayState.destroyFreeplayVocals();
	}

	function changediff(wah:Int = 0)
		{
			curDiff += wah;

			if (curDiff >= difficulty.length)
				curDiff = 0;
			if (curDiff < 0)
				curDiff = difficulty.length - 1;
			diffText.text = '< ' + difficulty[curDiff] + ' >';
		}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.alpha = 0.7;
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				spr.alpha = 1;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}