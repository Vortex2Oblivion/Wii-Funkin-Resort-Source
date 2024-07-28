local screens = {
	["mobility"] = "ONE",
	["glove-check"] = "TWO",
	["final-fist"] = "THREE",
	["ringside"] = "ONE",
	["decked"] = "TWO",
	["gameboy"] = "THREE",
	["doodle"] = "THREE",
	["backlight"] = "ONE",
	["sporting-resort"] = "TWO",
	["boxing-match-resort"] = "THREE"
}

function onCreate()
	makeLuaSprite('wall', 'ringWall', 0, 0);
	addLuaSprite('wall', false);
	setScrollFactor('wall', 0.9, 0.9)

	makeAnimatedLuaSprite('ringBoppers','ringBoppers', 0, -10);
	addAnimationByPrefix('ringBoppers','ringBoppers','peoplebackground',24,false);
	addLuaSprite('ringBoppers', false);
	setScrollFactor('ringBoppers', 0.9, 0.9)

	makeLuaSprite('Bars', 'ringBars', 0, -120);
	addLuaSprite('Bars', false);
	setScrollFactor('Bars', 0.9, 0.9)

	makeLuaSprite('Front', 'ringFront', 0, 0);
	addLuaSprite('Front', false);

	makeLuaSprite('ringScreen','ringscreen'..screens[string.lower(songName)], 1150, -200);
	addLuaSprite('ringScreen', false);
end
function onBeatHit()
	playAnim('ringBoppers','ringBoppers',true);
end
