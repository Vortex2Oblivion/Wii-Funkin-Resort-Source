package;

class Spacebar extends FlxSprite {
    public function new() {
        frames = ;
        animation.addByPrefix("idle", "spacebar", 24, false);
        animation.addByPrefix("glove", "spacebar glove press", 24, false);
        animation.addByPrefix("sword", "spacebar sword press", 24, false);
        super();
    }
    public function attack(?mech:String = "glove") {
        animation.play(mech, true);
    }
}