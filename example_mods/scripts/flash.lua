local sound = true
local volume = 0.97
local lightningOnSustains = true
local randomizedLightningSounds = true

function tobool(str)
    local bool = false
    if str == "true" then
        bool = true
    end
    return bool
end

function onCreate()
	sound = tobool(getTextFromFile('options/sound.txt'))
	volume = tonumber(getTextFromFile('options/volume.txt'))
	lightningOnSustains = tobool(getTextFromFile('options/lightningOnSustains.txt'))
	randomizedLightningSounds = tobool(getTextFromFile('options/randomizedLightningSounds.txt'))
end

function onCreatePost() -- this function cleans up lag from the sprites being processed
	luaDebugMode = true
	precacheImage('bolt')
	for i = 0, 1 do
	makeAnimatedLuaSprite('bolt'..i, 'bolt', 0, 0)
	addAnimationByPrefix('bolt'..i, 'bolt', 'rayito', 24, false)
	if downscroll then setProperty('bolt'..i..'.flipY', true) end
	scaleObject('bolt'..i, 0.7, 0.7)
	setObjectCamera('bolt'..i, 'camHUD')
	addLuaSprite('bolt'..i, true)
	setProperty('bolt'..i..'.visible', false)
	end
end

local canBolt = false
local inCooldown = true
local total = 0
function goodNoteHit(id, dir, nt, sus)
	if (getProperty('combo') >= 15 and not sus) then
		total = total + 1
		if canBolt or nt == 'Hey!' and not inCooldown and total >= 5 then
			flash(dir, true, getRandomBool(20))
		end
		inCooldown = false
	end
	if (sus or getPropertyFromGroup('notes', id, 'sustainLength') ~= 0) and getProperty('combo') >= 15 or getProperty('bolt0.visible') then
		flash(dir, false, getRandomBool(15))
		runTimer('boltAnimationReplay', getProperty('bolt0.animation.curAnim.delay') * 2.5)
	end
end

function onSpawnNote(id, direction, noteType, sus) if getPropertyFromGroup('notes', id, 'mustPress') and not sus and not inCooldown then runTimer('canBolt', (crochet / 1000) * curBpm / (15 * 2 + (stepCrochet / 57))) end end

function playHitSound(randomized)
	if randomized then runHaxeCode([[hitSound = FlxG.sound.load(Paths.soundRandom('hit', 0, 3), 0.4 * ]]..(volume)..[[, false, null, false, true);]]) else runHaxeCode([[hitSound = FlxG.sound.load(Paths.sound('hit'), 0.4 * ]]..(volume)..[[, false, null, false, true);]]) end
	
	runHaxeCode([[	
		hitSound.pitch = FlxG.random.float(0.4, 1.4);
		hitSound.play();
				]])
end

function flash(dir, playHit, special)
	canBolt = false
	if playHit then 
		inCooldown = true
		total = 0
		if sound then playHitSound(randomizedLightningSounds) end
	end
	
	
	-- OPTIMIZE LATER.
	local strum0X = getPropertyFromGroup('playerStrums', 0, 'x')
	local strum0Y = getPropertyFromGroup('playerStrums', 0, 'y')
	local strum0Width = getPropertyFromGroup('playerStrums', 0, 'width')
	local strum0Height = getPropertyFromGroup('playerStrums', 0, 'height')
	local strum1X = getPropertyFromGroup('playerStrums', 1, 'x')
	local strum1Y = getPropertyFromGroup('playerStrums', 1, 'y')
	local strum1Width = getPropertyFromGroup('playerStrums', 1, 'width')
	local strum1Height = getPropertyFromGroup('playerStrums', 1, 'height')
	local strum2X = getPropertyFromGroup('playerStrums', 2, 'x')
	local strum2Y = getPropertyFromGroup('playerStrums', 2, 'y')
	local strum2Width = getPropertyFromGroup('playerStrums', 2, 'width')
	local strum2Height = getPropertyFromGroup('playerStrums', 2, 'height')
	local strum3X = getPropertyFromGroup('playerStrums', 3, 'x')
	local strum3Y = getPropertyFromGroup('playerStrums', 3, 'y')
	local strum3Width = getPropertyFromGroup('playerStrums', 3, 'width')
	local strum3Height = getPropertyFromGroup('playerStrums', 3, 'height')
	-- OPTIMIZE LATER.

	
	setProperty('bolt0.visible', true)
	if special then setProperty('bolt1.visible', true) end
	for i = 0, 1 do
		setProperty('bolt'..i..'.y', strum0Y + strum0Height * (not downscroll and -2.38 or 0.5))
		playAnim('bolt'..i, 'bolt', true, false)
	end
	if playHit and sound then playSound('hit'..math.floor(math.random(0, 3)), 0.055 * volume) end
	if dir == 0 then
		setProperty('bolt0.x', strum0X + strum0Width * -1)
		
		setProperty('bolt0.flipX', false)
		if special then
			setProperty('bolt1.x', strum0X + strum0Width * 0.4)
			setProperty('bolt1.flipX', true)
		end
	elseif dir == 1 then
		setProperty('bolt0.x', strum1X + strum1Width * 0.4)
		setProperty('bolt0.flipX', true)
		if special then
			setProperty('bolt1.x', strum1X + strum1Width * -1)
			setProperty('bolt1.flipX', false)
		end
	elseif dir == 2 then
		setProperty('bolt0.x', strum2X + strum2Width * -1)
		if special then
			setProperty('bolt1.x', strum2X + strum2Width * 0.33)
			setProperty('bolt1.flipX', true)
		end
		setProperty('bolt0.flipX', false)
	else
		setProperty('bolt0.x', strum3X + strum3Width * 0.3)
		if special then
			setProperty('bolt1.x', strum3X + strum3Width * -1)
			setProperty('bolt1.flipX', false)
		end
		setProperty('bolt0.flipX', true)
	end
	runTimer('bolt0AnimationFinish', getProperty('bolt0.animation.curAnim.delay') * (not special and 2.5 or 0.5))
	if special then runTimer('bolt1AnimationFinish', getProperty('bolt1.animation.curAnim.delay') * 2.5)  end
end

reverseBool = false
function onTimerCompleted(t, l, lL)
	for i = 0, 1 do
		if t == 'bolt'..i..'AnimationFinish' then
			setProperty('bolt'..i..'.visible', false)
		elseif t == 'boltAnimationReplay' then
				setProperty('bolt'..i..'.animation.curAnim.frameRate', getProperty('bolt0.animation.curAnim.frameRate') + math.floor(math.random(-2, 2)))
				playAnim('bolt'..i, 'bolt', true, reverseBool)
		elseif t == 'canBolt' then
			canBolt = true
		end
	end
end