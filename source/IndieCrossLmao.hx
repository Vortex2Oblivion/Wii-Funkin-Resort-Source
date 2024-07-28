package;

class IndieCrossLmao extends MusicBeatState {
    override function create() {
        super.create();
        var dumb:FlxSprite = new FlxSprite().loadGraphic('hidden/images/pibby${FlxG.random.int(0,1)}.png');
        dumb.antialiasing = ClientPrefs.globalAntialiasing;
        dumb.screenCenter();
        add(dumb);
        new FlxTimer().start(5, function(tmr:FlxTimer) {
            LoadingState.loadAndSwitchState(new PlayState());
        });
    }
}