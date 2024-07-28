package;

import flixel.sound.FlxSound;
import flixel.ui.FlxButton;
import flixel.tweens.FlxTween;

class ResortPauseMenu extends MusicBeatSubstate {

    var exit:FlxButton;
    var resetButton:FlxButton;
    var resume:FlxButton;

    function stopButtonPresses(){
        for(member in members){
            if (member is FlxButton){
                cast(member, FlxButton).status = DISABLED;
            }
        }
    }

    override function create() {
        super.create();
        var black:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(black);
        black.alpha = 0;
        FlxTween.tween(black, {alpha: 0.3}, 0.5);
        exit = new FlxButton(0, 0, '', () -> {
            stopButtonPresses();
            var snd:FlxSound = new FlxSound().loadEmbedded("assets/sounds/pause/wii_sfx_4.ogg").play();
            snd.onComplete = () -> {
                PlayState.isStoryMode ? FlxG.switchState(() -> new MainMenuState()) : FlxG.switchState(() -> new FreeplayState());
                PlayState.cancelMusicFadeTween();
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
                PlayState.changedDifficulty = false;
                PlayState.chartingMode = false;
            }
        });
        exit.loadGraphic("assets/images/pause/exit.png", true, 372, 129);
        exit.screenCenter(Y);
        exit.x = 132;
        exit.antialiasing = ClientPrefs.globalAntialiasing;
        exit.alpha = 0;
        add(exit);
        FlxTween.tween(exit, {alpha: 1}, 0.5);
        resetButton = new FlxButton(0, 0, '', () -> {
            stopButtonPresses();
            var snd:FlxSound = new FlxSound().loadEmbedded("assets/sounds/pause/wii_sfx_4.ogg").play();
            snd.onComplete = () -> {
                PlayState.instance.paused = true; // For lua
                FlxG.sound.music.volume = 0;
                PlayState.instance.vocals.volume = 0;
                FlxG.switchState(()->new PlayState());
            }
        });
        resetButton.loadGraphic("assets/images/pause/reset.png", true, 372, 129);
        resetButton.screenCenter(Y);
        resetButton.x = 793;
        add(resetButton);
        resetButton.alpha = 0;
        resetButton.antialiasing = ClientPrefs.globalAntialiasing;
        FlxTween.tween(resetButton, {alpha: 1}, 0.5);
        resume = new FlxButton(0, -165, '', () -> {
            stopButtonPresses();
            var snd:FlxSound = new FlxSound().loadEmbedded("assets/sounds/pause/wii_sfx_4.ogg").play();
            snd.onComplete = () -> {
                FlxG.state.closeSubState();  
            }
        });
        resume.loadGraphic("assets/images/pause/resume.png", true, 1280, 165);
        resume.screenCenter(X);
        resume.antialiasing = ClientPrefs.globalAntialiasing;
        add(resume);
        resume.alpha = 0;
        FlxTween.tween(resume, {y: 0, alpha: 1}, 0.5);
        var bottom:FlxSprite = new FlxSprite(0, 165);
        bottom.loadGraphic("assets/images/pause/bottom.png");
        bottom.screenCenter(X);
        bottom.antialiasing = ClientPrefs.globalAntialiasing;
        add(bottom);
        bottom.alpha = 0;
        FlxTween.tween(bottom, {y: 0, alpha: 1}, 0.5);
        FlxG.sound.play("assets/sounds/pause/wii_sfx_1.ogg");
        cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
        FlxG.mouse.load(Paths.image("pointer").bitmap);
        FlxG.mouse.visible = true;
    }
}