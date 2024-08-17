package;

import flixel.tweens.misc.VarTween;
import openfl.filters.ShaderFilter;
#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import openfl.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import flixel.sound.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
import shaders.GlitchEffect;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];
	var selectedSomething:Bool = false;

	var characterSpr:FlxSprite;
	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	var grid:FlxGridOverlay;

	var record:FlxSprite;
	var box1:FlxSprite;
	var box2:FlxSprite;

	var daWiiks:WeekData;

	var curCat:Int = 0;
	var categories:Array<String> = ['swordplay', 'boxing', 'basketball'];
	/**
	 * Map for all the weeks and their songs and icons
	 */
	final _weekData:Map<String, Array<Array<String>>> = [
		"swordplay" => [
			['sword up', 'swordmatt'],
			['kendo', 'swordmatt'],
			['true edge', 'swordmatt']
		],
		"boxing" => [
			['mobility', 'boxmatt'],
			['glove check', 'boxmatt'],
			['final fist', 'boxmatt']
		],
		"basketball" => [
			['tommy', 'tommy'],
			['ones', 'tommy'],
			['overtime', 'thegang']
		],
		"freeplaysword" => [
			['everl4st', 'swordmatt'],
			['daito', 'swordmatt'],
			['fault line', 'swordmatt']
		],
		"freeplaybox" => [
			['ringside', 'boxmatt'],
			['decked', 'boxmatt'],
			['gameboy', 'boxmatt'],
			['doodle', 'mart']
		],
		"freeplayball" => [
			['skilled', 'tommy'],
			['beefed-up', 'beefxmatt'],
			['twos', 'tommyxbeef']
		],
		"frisbee" => [
			['gr00ve', 'matt'],
			['genz', 'matt'],
			['resort', 'matt']
		],
		"w1resort" => [
			['light-it-up-resort', 'swordmatt'],
			['ruckus-resort', 'swordmatt'],
			['target-practice-resort', 'swordmatt']
		],
		"w2resort" => [
			['blacklight', 'boxmatt'],
			['sporting-resort', 'boxmatt'],
			['boxing-match-resort', 'boxmatt']
		],
		"glitch" => [
			['proto', 'orangedefect'],
			['gba', 'orangedefect'],
			['parasitic', 'orangedefect'],
			['d3fect', 'bothdefect']
		]
	];

	/*var _weekDisplayNames:Map<String, String> = [ //Workaround for weird crash ig?
		"swordplay" => "Swordplay",
		"boxing" => "boxing",
		"basketball" => "Basketball",
		"freeplaysword" => "Swordplay (freeplay)",
		"freeplaybox" => "Boxing (freeplay)",
		"freeplayball" => "Basketball (freeplay)",
		"tutorial" => "Tutorial",
		"w1resort" => "Resort Remixes (Wiik 1)",
		"w2resort" => "Resort Remixes (Wiik 2)",
		"glitch" => "D3FECT",
	];*/
	

	var glitch:GlitchEffect = new GlitchEffect();
	

	public var camHUD:FlxCamera = new FlxCamera();

	public static var instance:FreeplayState;

	var _recordSpeed:Float = 0;

	var infoText:FlxText = new FlxText();


	override function create()
	{
		instance = this;
		
		if(Progress.getData('playedSwordplay')) {categories.push('freeplaysword'); trace("added freeplaysword");}
		if(Progress.getData('playedBoxing')) {categories.push('freeplaybox'); trace("added freeplaybox");}
		if(Progress.getData('playedBasketball')) {categories.push('freeplayball'); trace("added freeplayball");}
		/*if(Progress.getData('playedTutorial'))*/ {categories.push('frisbee'); trace("added frisbee");}
		if(Progress.getData('playedWiik1Remixes')) {categories.push('w1resort'); trace("added w1resort");}
		if(Progress.getData('playedWiik2Remixes')) {categories.push('w2resort'); trace("added w2resort");}
		if(Progress.getData('playedDefected')) {categories.push('glitch'); trace("added glitch");}

		if(ClientPrefs.shaders){
			var shader:ShaderFilter = new ShaderFilter(glitch.shader);
			FlxG.camera.filters = [shader];
			camHUD.filters = [shader];
		}

		glitch.speed = 0.35;
		glitch.amount = 0.0;
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		#if debug
		trace("our cat is " +  categories[curCat]);


		trace(WeekData.weeksList);
		#end

		/*for (i in 0...WeekData.weeksList.length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.loadTheFirstEnabledMod();

		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//*/



		ClientPrefs.loadPrefs();
		trace("loaded LastSection: " + ClientPrefs.lastSectionSelected);
		loadFreeplayList(ClientPrefs.lastSectionSelected);
		

		bg = new FlxSprite();
		bg.frames = Paths.getSparrowAtlas('bg');
		bg.animation.addByPrefix('bg', 'bg idle', 24, true);
		bg.animation.play('bg', true);
		bg.scale.set(2.135, 2.135);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.screenCenter();
		add(bg);
		
	
		characterSpr = new FlxSprite();
		characterSpr.antialiasing = ClientPrefs.globalAntialiasing;
        add(characterSpr);

		record = new FlxSprite(-625, 830).loadGraphic(Paths.image('menu/recordWhole'));
		record.antialiasing = ClientPrefs.globalAntialiasing;
		record.scrollFactor.set();
		add(record);

		box1 = new FlxSprite(-400, 720).loadGraphic(Paths.image('menu/fpbox1'));
		box1.antialiasing = ClientPrefs.globalAntialiasing;
		box1.scrollFactor.set();
		add(box1);

		box2 = new FlxSprite(-400, 720).loadGraphic(Paths.image('menu/fpbox1'));
		box2.antialiasing = ClientPrefs.globalAntialiasing;
		box2.scrollFactor.set();
		add(box2);

		FlxTween.tween(record, {x: 175 , y: 100 }, 0.9, {ease: FlxEase.quadOut});

		FlxTween.tween(box1, {x: 0 , y: 0 }, 0.9, {ease: FlxEase.quadOut});
		FlxTween.tween(box2, {x: 0 , y: 0 }, 0.9, {ease: FlxEase.quadOut});

		var dots:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/dots'));
		dots.screenCenter();
		dots.updateHitbox();
		dots.antialiasing = ClientPrefs.globalAntialiasing;
		dots.scrollFactor.set();
		add(dots);

		grpSongs = new FlxTypedGroup<Alphabet>();
		//grpSongs.visible = false;
		add(grpSongs);


		for (i in 0...songs.length)
		{
			var songNameFix:String = songs[i].songName.replace("_", " ");
			songNameFix = songNameFix.replace("-", " ");
			/*
				Example:
				if song is called "Wass-Up", it becomes "Wass Up"
			*/

			var songText:Alphabet = new Alphabet(90, 320, songNameFix, true);
			songText.isMenuItem = true;
			songText.targetY = i - curSelected;
			grpSongs.add(songText);

			var maxWidth = 980;
			if (songText.width > maxWidth)
			{
				songText.scaleX = maxWidth / songText.width;
			}
			songText.snapToPosition();

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		scoreBG = new FlxSprite(21, 80).makeGraphic(491, 43, 0xFF000000);
		scoreBG.alpha = 0.6;
		scoreBG.cameras = [camHUD];
		add(scoreBG);

		scoreText = new FlxText(scoreBG.x+12, scoreBG.y, 0, "Score:", 32);
		scoreText.font = Paths.font("wii.ttf");
		scoreText.cameras = [camHUD];
		scoreText.antialiasing = ClientPrefs.globalAntialiasing;
		add(scoreText);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "Difficulty:", 24);
		diffText.font = scoreText.font;
		//add(diffText);

		if(curSelected >= songs.length) curSelected = 0;

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		//changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		*/
		changeCharacterMenu();

		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD, false);


		var mainuiart:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/mainuiart'));
		mainuiart.screenCenter();
		mainuiart.updateHitbox();
		mainuiart.antialiasing = ClientPrefs.globalAntialiasing;
		mainuiart.scrollFactor.set();
		mainuiart.cameras = [camHUD];
		add(mainuiart);


		infoText.antialiasing = ClientPrefs.globalAntialiasing;
		infoText.scrollFactor.set();
		infoText.cameras = [camHUD];
		infoText.font = Paths.font("wii.ttf");
		infoText.size = 48;
		infoText.color = FlxColor.WHITE;
		infoText.y += 660;
		infoText.updateHitbox();
		infoText.screenCenter(X);
		add(infoText);

		Conductor.changeBPM(128);

		trace("loaded LastPosition: " + ClientPrefs.lastSongPosition);

		if(ClientPrefs.lastSongPosition == 0){
			changeSelection(0,false);
		} else if(ClientPrefs.lastSongPosition == songs.length -1){

			//changeSelection(-1);
		} else {
			changeSelection(ClientPrefs.lastSongPosition -1,false);			
		}		



	}

	var tweenChr:FlxTween = null;
	var recordTween:FlxTween = null;
	var boxTween:FlxTween = null;

	function loadFreeplayList(?change:Int = 0){
		curCat += change;
		if (curCat >= categories.length)
			curCat = 0;
		if (curCat < 0)
			curCat = categories.length - 1;
		

		if((curCat + 1 == categories.length) && categories.length == 10){
			FlxTween.tween(glitch, {amount: 0.035 }, 0.25, {ease: FlxEase.linear});
		}
		else
			FlxTween.tween(glitch, {amount: 0.0 }, 0.25, {ease: FlxEase.linear});

		var initSonglist = _weekData.get(categories[curCat].toLowerCase());
		for (i in 0...initSonglist.length) {
				// Creates an array of their strings
				var listArray = initSonglist[i];

				// Variables I like yes mmmm tasty
				var week = Std.parseInt(listArray[2]);
				var icon = listArray[1];
				var song = listArray[0];

				var diffsStr = listArray[3];
				var diffs = ["easy", "normal", "hard"];

				var color = listArray[4];
				var actualColor:Null<FlxColor> = null;

				if (color != null)
					actualColor = FlxColor.fromString(color);

				if (diffsStr != null)
					diffs = diffsStr.split(",");

				// Creates new song data accordingly
				songs.push(new SongMetadata(song, 0, icon, FlxColor.TRANSPARENT));
		}
		if(curSelected + 1 > songs.length){
			curSelected = 0;
		}
		/*try {
			infoText.text = _weekDisplayNames.get(categories[curCat].toLowerCase());
			trace(infoText.text);
		}
		catch (e:Dynamic) {
			trace(e);
		}*/
		switch(curCat){ //I get a null object ref unless i do this??????????? Yes ik its not pretty before people complain
			case 0: infoText.text = '< Swordplay >';
			case 1: infoText.text = '< Boxing >';
			case 2: infoText.text = '< Basketball >';
			case 3: infoText.text = '< Swordplay (freeplay) >';
			case 4: infoText.text = '< Boxing (freeplay) >';
			case 5: infoText.text = '< Basketball (freeplay) >';
			case 6: infoText.text = '< Frisbee >';
			case 7: infoText.text = '< Resort Remixes (Wiik 1) >';
			case 8: infoText.text = '< Resort Remixes (Wiik 2) >';
			case 9: infoText.text = '< D3FECTED >';
		}

		ClientPrefs.lastSectionSelected = curCat;
		ClientPrefs.saveSettings();
		trace("Cur lastSectionSelected" + curCat);

		infoText.updateHitbox();
		infoText.screenCenter(X);

		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
	}

	private function fuckTweenChr(?name:String = null, ?dontDoShitLmao:Bool = false) {

		if(dontDoShitLmao) return;

		if(tweenChr != null){
            tweenChr.cancel();
        }

		selectedSomething = true;
		persistentUpdate = false;

		var time:Float = 0.15;
        tweenChr = FlxTween.tween(characterSpr, {x: FlxG.width/2 + 300},time,{
            ease: FlxEase.circIn,
            onComplete: function(t:FlxTween){
                if (name != null) characterSpr.loadGraphic(Assets.exists('hidden/images/$name.png') ? 'hidden/images/$name.png' : Paths.image('menu/$name'));
                tweenChr = FlxTween.tween(characterSpr,{x: 300}, time,{
                    ease: FlxEase.circOut,
                    onComplete: function(t:FlxTween){
                        tweenChr = null;
						selectedSomething = false;
						persistentUpdate = false;
                    }
                });
            }
        });
	}


	private function moveRecord(){
		var time:Float = 0.15;
        recordTween = FlxTween.tween(record, {x: 0},time,{
            ease: FlxEase.circIn,
            onComplete: function(t:FlxTween){
                recordTween = FlxTween.tween(record,{x: 400}, time,{
                    ease: FlxEase.circOut,
                    onComplete: function(t:FlxTween){
                    }
                });
            }
        });
	}

	private function moveBoxes(){
		var time:Float = 0.15;
        boxTween = FlxTween.tween(box2, {x: -200},time,{
            ease: FlxEase.circIn,
            onComplete: function(t:FlxTween){
                boxTween = FlxTween.tween(box2,{x: 0}, time,{
                    ease: FlxEase.circOut,
                    onComplete: function(t:FlxTween){
                    }
                });
            }
        });
	}

	//why the fuck did the old coder make this just pick a random portrait???
	private function changeCharacterMenu(?force:Bool = false, ?dontDoShitLmao:Bool = false) {
		var nameSpr:String;
		if (songs[curSelected].songCharacter == "tommy") force = true; // it doesnt change on the tommy songs for whatever reason???
		if(curSelected + 1 <= songs.length){
			switch (songs[curSelected].songCharacter){
				case 'tommy' | 'thegang' | 'tommyxmatt' | 'tommyxbeef':   nameSpr = 'tommy';
				case 'swordmatt':                                         nameSpr = 'matt_sword';
				case 'orangedefect' | 'bothdefect' | 'glitch':            nameSpr = 'matt_defected';
				case 'matt' | 'mart':           						  nameSpr = 'none';
				default:                                                  nameSpr = 'matt_boxing'; //everything else
			}
			if(songs[curSelected].songCharacter != nameSpr || force) fuckTweenChr(nameSpr, dontDoShitLmao);
		}
    }

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public inline function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;

	function reloadSongs(){
		for (i in 0...songs.length)
			{
				var songText:Alphabet = new Alphabet(90, 320, songs[i].songName, true);
				songText.isMenuItem = true;
				songText.targetY = i - curSelected;
				grpSongs.add(songText);
	
				var maxWidth = 980;
				if (songText.width > maxWidth)
				{
					songText.scaleX = maxWidth / songText.width;
				}
				songText.snapToPosition();
	
				Paths.currentModDirectory = songs[i].folder;
				var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
				icon.sprTracker = songText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
	
				// songText.x += 40;
				// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
				// songText.screenCenter(X);
			}
	}
	var holdTime:Float = 0;
	override function beatHit(){
		super.beatHit();
		if (FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms)
			FlxG.camera.zoom += 0.03;
		if (camHUD.zoom < 1.35 && ClientPrefs.camZooms)
			camHUD.zoom += 0.03;
	}
	override function update(elapsed:Float)
	{
		glitch.time += elapsed;
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		record.angle += _recordSpeed * (PlayState.SONG == null ? 1 : PlayState.SONG.bpm / 100);

		if(controls.UI_RIGHT_P){
			if(curCat == 5){
				curSelected == 0;
			}
			
			grpSongs.clear();
			removeIcons();
			iconArray = [];
			songs = [];
			loadFreeplayList(1);
			reloadSongs();
			changeCharacterMenu();
			//moveBoxes();
			//moveRecord();
		}
		else if(controls.UI_LEFT_P){
			if(curCat == 7){
				curSelected == 0;
			}
			grpSongs.clear();
			removeIcons();
			iconArray = [];
			songs = [];
			loadFreeplayList(-1);
			reloadSongs();
			changeCharacterMenu();
				//moveBoxes();
				//moveRecord();
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		scoreText.cameras = [camHUD];
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if(songs.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
				changeCharacterMenu(false, true);
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
				changeCharacterMenu(false, true);
				
			}

			if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					changeDiff();
				}
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				changeDiff();
				changeCharacterMenu(false, true);
				
			}
		}

		/*if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else*/ if (upP || downP) changeDiff();

		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(() ->new MainMenuState());
			//camHUD.visible = false;
		}

		if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			if(instPlaying != curSelected)
			{
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = curSelected;
				Conductor.changeBPM(PlayState.SONG.bpm);
				FlxTween.num(_recordSpeed, 5, 1, {ease: FlxEase.quadOut}, updateFunction);
				#end
			}
		}

		else if (accepted)
		{
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			/*#if MODS_ALLOWED
			if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
			#else
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			#end
				poop = songLowercase;
				curDifficulty = 1;
				trace('Couldnt find file');
			}*/

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
			if(colorTween != null) {
				colorTween.cancel();
			}
			
			if (FlxG.keys.pressed.SHIFT && (Main.devBuild || Progress.getData("playedDefected"))){
				LoadingState.loadAndSwitchState(new ChartingState());
				//camHUD.visible = false;
			}else{
				ClientPrefs.saveSettings();
				LoadingState.loadAndSwitchState(new PlayState());
				//camHUD.visible = false;
			}

			FlxG.sound.music.volume = 0;
					
			destroyFreeplayVocals();
		}
		else if(controls.RESET)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (FlxG.sound.music != null){

			Conductor.songPosition = FlxG.sound.music.time;
		}
		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * 1 * 1), 0, 1));
		camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
		super.update(elapsed);
	}

	function updateFunction(Value:Float){
		_recordSpeed = Value;
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty = 2;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		if(curSelected <= songs.length){
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		}
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
		curDifficulty = 2;
		#if debug
		trace(curDifficulty);
		#end
	}
	

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;

		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		if(curSelected <= songs.length){
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		}
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}

		ClientPrefs.lastSongPosition = curSelected;
		ClientPrefs.saveSettings();
		trace("Cur lastSongPosition " + curSelected);
		
	}

	private function positionHighscore() {
		scoreBG.scale.x = scoreText.x + 6;
		scoreBG.x = scoreBG.scale.x / 2;
	}

	function removeIcons(){
		for(member in members){
			if(Std.isOfType(member, HealthIcon)){
				member.destroy();
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}
