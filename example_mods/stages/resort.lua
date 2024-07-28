
function onCreate()

	makeLuaSprite('bg1', 'the resort0004', -500, -500)
	setScrollFactor('bg1', 0.3, 0.1)
	addLuaSprite('bg1', false);

	makeLuaSprite('bg2', 'the resort0003', -10, 0)
	setScrollFactor('bg2', 0.5, 1.0)
	addLuaSprite('bg2', false);

	makeLuaSprite('bg3', 'the resort0002')
	setScrollFactor('bg3', 0.7, 1.0)
	addLuaSprite('bg3', false);

	makeAnimatedLuaSprite('people', 'Wii Funkin Resort Crowd Bounce (new)', 0, 550);
	addAnimationByPrefix('people', 'Wii Funkin Resort Crowd Bounce (new)', 'crowd bounce', 24, false);
	setScrollFactor('people', 0.9, 1.0)
	addLuaSprite('people', false);
	
	makeLuaSprite('bg4', 'the resort0001');
	addLuaSprite('bg4', false);
end


function onBeatHit()
	playAnim('people', 'Wii Funkin Resort Crowd Bounce (new)', true)
end