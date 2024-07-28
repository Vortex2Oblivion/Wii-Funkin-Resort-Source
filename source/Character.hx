package;

import openfl.geom.ColorTransform;
import shaders.ColorFillEffect;
import flixel.util.FlxDestroyUtil;
import animateatlas.AtlasFrameMaker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import Section.SwagSection;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import lime.utils.Assets;
import haxe.Json;

using StringTools;

typedef CharacterFile = {
	var animations:Array<AnimArray>;
	var image:String;
	var scale:Float;
	var sing_duration:Float;
	var healthicon:String;

	var position:Array<Float>;
	var camera_position:Array<Float>;

	var flip_x:Bool;
	var no_antialiasing:Bool;
	var healthbar_colors:Array<Int>;

	var skewX:Null<Float>;
	var skewY:Null<Float>;
	var angle:Null<Float>;
}

typedef AnimArray = {
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
}

class Character extends FlxSprite {
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = DEFAULT_CHARACTER;

	public var colorTween:FlxTween;
	public var holdTimer:Float = 0;
	public var heyTimer:Float = 0;
	public var specialAnim:Bool = false;
	public var animationNotes:Array<Dynamic> = [];
	public var stunned:Bool = false;
	public var singDuration:Float = 4; // Multiplier of how long a character holds the sing pose
	public var idleSuffix:String = '';
	public var danceIdle:Bool = false; // Character use "danceLeft" and "danceRight" instead of "idle"
	public var skipDance:Bool = false;

	public var healthIcon:String = 'face';
	public var animationsArray:Array<AnimArray> = [];

	public var positionArray:Array<Float> = [0, 0];
	public var cameraPosition:Array<Float> = [0, 0];

	public var hasMissAnimations:Bool = true;

	// Used on Character Editor
	public var imageFile:String = '';
	public var jsonScale:Float = 1;
	public var noAntialiasing:Bool = false;
	public var originalFlipX:Bool = false;
	public var healthColorArray:Array<Int> = [255, 0, 0];

	public static final DEFAULT_CHARACTER:String = 'bf'; // In case a character is missing, it will use BF on its place

	private var rawJson:String;

	public var shadow:CharacterShadow = new CharacterShadow(0, 0);

	var black:ColorFillEffect = new ColorFillEffect(0, 0, 0, 1);

	public var shadowSkewX:Float = 200;
	public var shadowSkewY:Float = 0;
	public var shadowFlipY:Bool = false;
	public var shadowDistance:Float = 0.25;

	public var otherCharacters:Array<Character>;

	// fix some dumb bug where extra players wont idle
	public var ignorePlayerHoldChecks:Bool = false;

	public var shadowFlipX:Bool = false;

	public function new(x:Float, y:Float, ?character:String = 'bf', ?isPlayer:Bool = false) {
		super(x, y);

		animOffsets = new Map();

		curCharacter = character;
		this.isPlayer = isPlayer;
		shadow = new CharacterShadow(x, y, character, isPlayer);
		antialiasing = ClientPrefs.globalAntialiasing;
		shadow.antialiasing = ClientPrefs.globalAntialiasing;
		shadow.colorTransform = new ColorTransform(0, 0, 0, 0.15);

		if (PlayState.curStage.contains('ring'))
			shadowDistance = 0.125; // shorten shadows cuz indoors

		shadow.height /= 10;
		shadow.scale.set(shadowFlipY ? -1.1 : 1.1, shadowFlipY ? -shadowDistance : shadowDistance);
		shadow.shader = ClientPrefs.shaders ? new shaders.BlurEffect().shader : null;
		switch (curCharacter) {
			// case 'your character name in case you want to hardcode them instead':
			case '' | 'nogf' | 'empty' | 'blank' | 'none':
				visible = false;
				trace("NO VALUE THINGY LOL DONT LOAD SHIT");

			default:
				var characterPath:String = 'characters/' + curCharacter + '.json';

				#if MODS_ALLOWED
				var path:String = Paths.modFolders(characterPath);
				if (!FileSystem.exists(path)) {
					path = Paths.getPreloadPath(characterPath);
				}
				if (Assets.exists("hidden/data/" + curCharacter + '.json'))
					path = "hidden/data/" + curCharacter + '.json';

				if (!FileSystem.exists(path))
				#else
				var path:String = Paths.getPreloadPath(characterPath);
				if (!Assets.exists(path))
				#end
				{
					path = Paths.getPreloadPath('characters/' + DEFAULT_CHARACTER +
						'.json'); // If a character couldn't be found, change him to BF just to prevent a crash
				}

				switch curCharacter {
					case 'defectedblue':
						rawJson = '{
								"animations": [
									{
										"offsets": [
											0,
											0
										],
										"indices": [],
										"fps": 24,
										"anim": "idle",
										"loop": true,
										"name": "bluedefecte idle"
									},
									{
										"offsets": [
											0,
											0
										],
										"indices": [],
										"fps": 24,
										"anim": "singLEFT",
										"loop": false,
										"name": "bluedefecte left"
									},
									{
										"offsets": [
											0,
											0
										],
										"indices": [],
										"fps": 24,
										"anim": "singDOWN",
										"loop": false,
										"name": "bluedefecte down"
									},
									{
										"offsets": [
											0,
											0
										],
										"indices": [],
										"fps": 24,
										"anim": "singUP",
										"loop": false,
										"name": "bluedefecte up"
									},
									{
										"offsets": [
											0,
											0
										],
										"indices": [],
										"fps": 24,
										"anim": "singRIGHT",
										"loop": false,
										"name": "bluedefecte right"
									}
								],
								"no_antialiasing": false,
								"image": "bluedefecte",
								"position": [
									0,
									-100
								],
								"healthicon": "bluedefect",
								"flip_x": false,
								"healthbar_colors": [
									52,
									53,
									203
								],
								"camera_position": [
									0,
									0
								],
								"sing_duration": 6.1,
								"scale": 1
							}';

					case 'defected':
						rawJson = '{
								"animations": [
									{
										"offsets": [
											0,
											0
										],
										"indices": [],
										"fps": 24,
										"anim": "idle",
										"loop": true,
										"name": "defected idle"
									},
									{
										"offsets": [
											0,
											0
										],
										"indices": [],
										"fps": 24,
										"anim": "singLEFT",
										"loop": false,
										"name": "defected left"
									},
									{
										"offsets": [
											0,
											0
										],
										"indices": [],
										"fps": 24,
										"anim": "singDOWN",
										"loop": false,
										"name": "defected down"
									},
									{
										"offsets": [
											0,
											0
										],
										"indices": [],
										"fps": 24,
										"anim": "singUP",
										"loop": false,
										"name": "defected up"
									},
									{
										"offsets": [
											0,
											0
										],
										"indices": [],
										"fps": 24,
										"anim": "singRIGHT",
										"loop": false,
										"name": "defected right"
									}
								],
								"no_antialiasing": false,
								"image": "defected",
								"position": [
									0,
									-100
								],
								"healthicon": "orangedefect",
								"flip_x": false,
								"healthbar_colors": [
									255,
									125,
									0
								],
								"camera_position": [
									0,
									0
								],
								"sing_duration": 6.1,
								"scale": 1
							}';

					default: rawJson = File.getContent(path);
				}

				#if debug
				trace(rawJson);
				#end
				var json:CharacterFile = cast Json.parse(rawJson);
				var spriteType = "sparrow";
				// sparrow
				// packer
				// texture
				#if MODS_ALLOWED
				var modTxtToFind:String = Paths.modsTxt(json.image);
				var txtToFind:String = Paths.getPath('images/' + json.image + '.txt', TEXT);

				// var modTextureToFind:String = Paths.modFolders("images/"+json.image);
				// var textureToFind:String = Paths.getPath('images/' + json.image, new AssetType();

				if (FileSystem.exists(modTxtToFind) || FileSystem.exists(txtToFind) || Assets.exists(txtToFind))
				#else
				if (Assets.exists(Paths.getPath('images/' + json.image + '.txt', TEXT)))
				#end
				{
					spriteType = "packer";
				}

				#if MODS_ALLOWED
				var modAnimToFind:String = Paths.modFolders('images/' + json.image + '/Animation.json');
				var animToFind:String = Paths.getPath('images/' + json.image + '/Animation.json', TEXT);

				// var modTextureToFind:String = Paths.modFolders("images/"+json.image);
				// var textureToFind:String = Paths.getPath('images/' + json.image, new AssetType();

				if (FileSystem.exists(modAnimToFind) || FileSystem.exists(animToFind) || Assets.exists(animToFind))
				#else
				if (Assets.exists(Paths.getPath('images/' + json.image + '/Animation.json', TEXT)))
				#end
				{
					spriteType = "texture";
				}

				switch (spriteType) {
					case "packer":
						frames = Paths.getPackerAtlas(json.image);
						shadow.frames = Paths.getPackerAtlas(json.image);

					case "sparrow":
						frames = Assets.exists('hidden/images/${json.image}.png') ? FlxAtlasFrames.fromSparrow('hidden/images/${json.image}.png',
							'hidden/images/${json.image}.xml') : Paths.getSparrowAtlas(json.image);
						shadow.frames = Assets.exists('hidden/images/${json.image}.png') ? FlxAtlasFrames.fromSparrow('hidden/images/${json.image}.png',
							'hidden/images/${json.image}.xml') : Paths.getSparrowAtlas(json.image);

					case "texture":
						frames = AtlasFrameMaker.construct(json.image);
						shadow.frames = AtlasFrameMaker.construct(json.image);
				}
				imageFile = json.image;

				if (json.scale != 1) {
					jsonScale = json.scale;
					setGraphicSize(Std.int(width * jsonScale));
					updateHitbox();
				}

				positionArray = json.position;
				cameraPosition = json.camera_position;

				healthIcon = json.healthicon;
				singDuration = json.sing_duration;
				flipX = json.flip_x;
				shadowFlipX = flipX;
				if (json.no_antialiasing) {
					antialiasing = false;
					noAntialiasing = true;
				}

				if (json.healthbar_colors != null && json.healthbar_colors.length > 2)
					healthColorArray = json.healthbar_colors;

				antialiasing = !noAntialiasing;
				if (!ClientPrefs.globalAntialiasing)
					antialiasing = false;

				animationsArray = json.animations;
				if (animationsArray != null && animationsArray.length > 0) {
					for (anim in animationsArray) {
						var animAnim:String = '' + anim.anim;
						var animName:String = '' + anim.name;
						var animFps:Int = anim.fps;
						var animLoop:Bool = !!anim.loop; // Bruh
						var animIndices:Array<Int> = anim.indices;
						if (animIndices != null && animIndices.length > 0) {
							animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
							shadow.animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
						} else {
							animation.addByPrefix(animAnim, animName, animFps, animLoop);
							shadow.animation.addByPrefix(animAnim, animName, animFps, animLoop);
						}

						if (anim.offsets != null && anim.offsets.length > 1) {
							addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
						}
					}
				} else {
					quickAnimAdd('idle', 'BF idle dance');
				}
				// trace('Loaded file to character ' + curCharacter);
		}
		originalFlipX = flipX;

		// if(animOffsets.exists('singLEFTmiss') || animOffsets.exists('singDOWNmiss') || animOffsets.exists('singUPmiss') || animOffsets.exists('singRIGHTmiss')) hasMissAnimations = true;
		recalculateDanceIdle();
		dance();

		if (isPlayer) {
			flipX = !flipX;
			shadow.flipX = !flipX;
			shadowFlipX = !shadowFlipX;
		}

		switch (curCharacter) {
			case 'pico-speaker':
				skipDance = true;
				loadMappedAnims();
				playAnim("shoot1");
		}
	}

	override function update(elapsed:Float) {
		if (!debugMode && animation.curAnim != null) {
			if (heyTimer > 0) {
				heyTimer -= elapsed * PlayState.instance.playbackRate;
				if (heyTimer <= 0) {
					if (specialAnim && animation.curAnim.name == 'hey' || animation.curAnim.name == 'cheer') {
						specialAnim = false;
						dance();
					}
					heyTimer = 0;
				}
			} else if (specialAnim && animation.curAnim.finished) {
				specialAnim = false;
				dance();
			}

			switch (curCharacter) {
				case 'pico-speaker':
					if (animationNotes.length > 0 && Conductor.songPosition > animationNotes[0][0]) {
						var noteData:Int = 1;
						if (animationNotes[0][1] > 2)
							noteData = 3;

						noteData += FlxG.random.int(0, 1);
						playAnim('shoot' + noteData, true);
						animationNotes.shift();
					}
					if (animation.curAnim.finished)
						playAnim(animation.curAnim.name, false, false, animation.curAnim.frames.length - 3);
			}

			if (!isPlayer || ignorePlayerHoldChecks) {
				if (animation.curAnim.name.startsWith('sing')) {
					holdTimer += elapsed;
				}

				if (holdTimer >= Conductor.stepCrochet * (0.0011 / (FlxG.sound.music != null ? FlxG.sound.music.pitch : 1)) * singDuration) {
					dance();
					holdTimer = 0;
				}
			}

			if (animation.curAnim.finished && animation.getByName(animation.curAnim.name + '-loop') != null) {
				playAnim(animation.curAnim.name + '-loop');
			}
		}
		shadow.update(elapsed);
		super.update(elapsed);
	}

	public var danced:Bool = false;

	public function copyAtlasValues() {
		if (!ClientPrefs.shadows)
			return;
		@:privateAccess
		{
			// if(PlayState.curStage.contains('ring') || PlayState.curStage.contains('frisbee')){
			shadow.scrollFactor = scrollFactor;
			shadow.origin = origin;
			shadow.flipX = flipX;
			shadow.x = x;
			if (!curCharacter.contains("defected"))
				shadow.y = y;
			// }
		}
	}

	public override function destroy() {
		super.destroy();
		destoryShadow();
	}

	public inline function destoryShadow() {
		if (shadow != null)
			shadow = FlxDestroyUtil.destroy(shadow);
	}

	public override function draw() {
		if (!PlayState.curStage.contains('resort')) {
			if (ClientPrefs.shadows) {
				shadow.draw();
				copyAtlasValues();
			}
		}
		super.draw();
	}

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance() {
		if (!debugMode && !skipDance && !specialAnim) {
			if (danceIdle) {
				danced = !danced;

				if (danced)
					playAnim('danceRight' + idleSuffix);
				else
					playAnim('danceLeft' + idleSuffix);
			} else if (animation.getByName('idle' + idleSuffix) != null) {
				playAnim('idle' + idleSuffix);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void {
		specialAnim = false;
		animation.play(AnimName, Force, Reversed, Frame);
		shadow.playAnim(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName)) {
			offset.set(daOffset[0], daOffset[1]);
			color = 0xFFFFFF;
		} else {
			if (AnimName.contains("miss") && !animOffsets.exists(AnimName)) {
				offset.set(animOffsets.get(AnimName.replace("miss", ""))[0], animOffsets.get(AnimName.replace("miss", ""))[1]);
				animation.play(AnimName.replace("miss", ""), Force, Reversed, Frame);
				color = 0x565694;
			} else {
				offset.set(0, 0);
				color = 0xFFFFFF;
			}
		}

		if (curCharacter.startsWith('gf')) {
			if (AnimName == 'singLEFT') {
				danced = true;
			} else if (AnimName == 'singRIGHT') {
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN') {
				danced = !danced;
			}
		}
	}

	function loadMappedAnims():Void {
		var noteData:Array<SwagSection> = Song.loadFromJson('picospeaker', Paths.formatToSongPath(PlayState.SONG.song)).notes;
		for (section in noteData) {
			for (songNotes in section.sectionNotes) {
				animationNotes.push(songNotes);
			}
		}
		TankmenBG.animationNotes = animationNotes;
		animationNotes.sort(sortAnims);
	}

	function sortAnims(Obj1:Array<Dynamic>, Obj2:Array<Dynamic>):Int {
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1[0], Obj2[0]);
	}

	public var danceEveryNumBeats:Int = 2;

	private var settingCharacterUp:Bool = true;

	public function recalculateDanceIdle() {
		var lastDanceIdle:Bool = danceIdle;
		danceIdle = (animation.getByName('danceLeft' + idleSuffix) != null && animation.getByName('danceRight' + idleSuffix) != null);

		if (settingCharacterUp) {
			danceEveryNumBeats = (danceIdle ? 1 : 2);
		} else if (lastDanceIdle != danceIdle) {
			var calc:Float = danceEveryNumBeats;
			if (danceIdle)
				calc /= 2;
			else
				calc *= 2;

			danceEveryNumBeats = Math.round(Math.max(calc, 1));
		}
		settingCharacterUp = false;
	}

	public inline function addOffset(name:String, x:Float = 0, y:Float = 0) {
		animOffsets[name] = [x, y];
	}

	public function quickAnimAdd(name:String, anim:String) {
		animation.addByPrefix(name, anim, 24, false);
		shadow.animation.addByPrefix(name, anim, 24, false);
	}
}
