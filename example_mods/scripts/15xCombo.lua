-- Sprites by https://twitter.com/offi69_

-- default options
local precache = true
local sound = false
local volume = 3
local useTickSound = false
local showComboNumbers = false
local centerXcombo = true
local updatePosition = true

function tobool(str)
    local bool = false
    if str == "true" then
        bool = true
    end
    return bool
end

function onCreate()
	precache = tobool(getTextFromFile('options/precache.txt'))
	sound = tobool(getTextFromFile('options/sound.txt'))
	volume = tonumber(getTextFromFile('options/volume.txt'))
	useTickSound = tobool(getTextFromFile('options/useTickSound.txt'))
	showComboNumbers = tobool(getTextFromFile('options/showComboNumbers.txt'))
	centerXcombo = tobool(getTextFromFile('options/centerXcombo.txt'))
	updatePosition = tobool(getTextFromFile('options/updatePosition.txt'))
end

function onCreatePost()
	if precache then -- this cleans up lag from the sprites being processed
		precacheImage('xcombo')
		precacheImage('comboNumbers')
	end
	
	setProperty('showComboNum', showComboNumbers)
end

function onSongStart() -- Create Sprites...

		-- Using Variables to make it more readable
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
		
	
		if not centerXcombo then
			makeAnimatedLuaSprite('combo', 'xcombo', strum3X + strum3Width * 0.53, strum3Y + strum3Height * 0.5)
			makeAnimatedLuaSprite('fc', 'fc', strum0X - strum0Width * 0.15, strum0Y)
		else
			makeAnimatedLuaSprite('combo', 'xcombo', screenWidth * 0.44, screenHeight * (not downscroll and 0.075 or 0.8))
			makeAnimatedLuaSprite('fc', 'fc', screenWidth * 0.485, screenHeight * (not downscroll and 0.015 or 0.74))
		end
		
		makeAnimatedLuaSprite('numbers0', 'comboNumbers', getProperty('combo.x') + getProperty('combo.width') * 0.15, getProperty('combo.y') + getProperty('combo.height') * 0.18)
		
		makeAnimatedLuaSprite('numbers1', 'comboNumbers', getProperty('numbers0.x') + getProperty('numbers0.width') * 0.4, getProperty('numbers0.y'))
		
		makeAnimatedLuaSprite('numbers2', 'comboNumbers', getProperty('numbers1.x') + getProperty('numbers1.width') * 0.4, getProperty('numbers0.y'))
		
		
		addAnimationByPrefix('combo', 'combo', 'xcombo', 24, false)
		addAnimationByPrefix('combo', 'appear', 'comboappear', 24, false)
		addAnimationByPrefix('combo', 'dissappear', 'combodissappear', 24, false)
		addOffset('combo', 'combo', 33, 17.8)
		addOffset('combo', 'appear', 63.7, 49.8)
		addOffset('combo', 'dissappear', 65.7, 42.8)
		
		addAnimationByPrefix('fc', 'fc', 'fc', 24, false)
		addAnimationByPrefix('fc', 'appear', 'Fc_appear', 24, false)
		addAnimationByPrefix('fc', 'dissappear', 'Fc_FuckingDIESHAHAHA', 24, false)
		addOffset('fc', 'fc', 33, 17.8)
		addOffset('fc', 'appear', 48.7, 53.8)
		addOffset('fc', 'dissappear', 36.7, 46.8)
		
		for i = 0, 9 do
			for ii = 0, 2 do
				addAnimationByIndices('numbers'..ii, i, 'numbres000', i, 24)
				addAnimationByPrefix('numbers'..ii, i..'appear', i..'appearing', 24, false)
				addAnimationByPrefix('numbers'..ii, i..'dissappear', i..'dissappearing', 24, false)
				addOffset('numbers'..ii, i..'appear', 15, 21)
				addOffset('numbers'..ii, i..'dissappear', 9.5, 13)
			end
		end
		
		-- Setup Sprites...
		for i,sprites in pairs({'combo', 'numbers0', 'numbers1', 'numbers2', 'fc'}) do -- layering
			scaleObject(sprites, 0.7, 0.7)
			setObjectCamera(sprites, 'camHUD')
			addLuaSprite(sprites, true)
			setProperty(sprites..'.visible', false)
		end
end

function onUpdatePost(el)
	if updatePosition then
		local strum0X = getPropertyFromGroup('playerStrums', 0, 'x')
		local strum0Y = getPropertyFromGroup('playerStrums', 0, 'y')
		local strum0Width = getPropertyFromGroup('playerStrums', 0, 'width')
		local strum0Height = getPropertyFromGroup('playerStrums', 0, 'height')
		local strum0Angle = getPropertyFromGroup('playerStrums', 0, 'angle')
		local strum1X = getPropertyFromGroup('playerStrums', 1, 'x')
		local strum1Y = getPropertyFromGroup('playerStrums', 1, 'y')
		local strum1Width = getPropertyFromGroup('playerStrums', 1, 'width')
		local strum1Height = getPropertyFromGroup('playerStrums', 1, 'height')
		local strum1Angle = getPropertyFromGroup('playerStrums', 1, 'angle')
		local strum2X = getPropertyFromGroup('playerStrums', 2, 'x')
		local strum2Y = getPropertyFromGroup('playerStrums', 2, 'y')
		local strum2Width = getPropertyFromGroup('playerStrums', 2, 'width')
		local strum2Height = getPropertyFromGroup('playerStrums', 2, 'height')
		local strum2Angle = getPropertyFromGroup('playerStrums', 2, 'angle')
		local strum3X = getPropertyFromGroup('playerStrums', 3, 'x')
		local strum3Y = getPropertyFromGroup('playerStrums', 3, 'y')
		local strum3Width = getPropertyFromGroup('playerStrums', 3, 'width')
		local strum3Height = getPropertyFromGroup('playerStrums', 3, 'height')
		local strum3Angle = getPropertyFromGroup('playerStrums', 3, 'angle')
		
		
		if not centerXcombo then
			
			setProperty('combo.x', strum3X + strum3Width * 0.53)
			setProperty('combo.y', strum3Y + strum3Height * 0.5)
			setProperty('combo.angle', strum3Angle)
			
			setProperty('fc.x', strum0X - strum0Width * 0.15)
			setProperty('fc.y', strum0Y)
			setProperty('fc.angle', strum0Angle)
			
			setProperty('numbers0.x', getProperty('combo.x') + getProperty('combo.width') * 0.3)
			setProperty('numbers0.y', getProperty('combo.y') + getProperty('combo.height') * 0.57)
			setProperty('numbers1.x', getProperty('numbers0.x') + getProperty('numbers0.width') * 0.9)
			setProperty('numbers2.x', getProperty('numbers1.x') + getProperty('numbers1.width') * 0.9)
			for i = 1, 2 do
				setProperty('numbers'..i..'.y', getProperty('numbers0.y'))
			end
			for i = 0, 2 do
				setProperty('numbers'..i..'.angle', getProperty('combo.angle'))
			end
		end
	end
end

-- local seperatedDigits = {0, 0, 0} I can't figure this out, sorry volv

-- Stack of used Variables for numbering
local firstNum = 0
local currentFirstNum = 0
local secondNum = 0
local currentSecondNum = 0
local thirdNum = 0
local currentThirdNum = 0
local lerpCombo = 0
local countedCombo = 0
local fullCombo = 0
local appearing = false
local appeared = false
local dissappearing = false
local dissappeared = false
local countingDown = false
local hasCounted = false
local hasCombo = false
local neverMissed = true
function goodNoteHit(id, dir, nt, sus)
	if not sus then -- It all culminates here
	
		fullCombo = fullCombo + 1 -- used for the Combo Going Down
		
		if getProperty('combo') == 15 then -- xCombo and Numbers appear
			dissappeared = false
			appearing = true
			hasCombo = true
			lerpCombo = 0
			firstNum = 0
			secondNum = 0
			thirdNum = 0
			countedCombo = getProperty('combo')
			
			if neverMissed then playAnim('fc', 'appear', false, false, 0) else playAnim('fc', 'dissappear', false, false, 15) end
			
			cancelTimer('countComboDown')
			runTimer('countComboUp', 0.0035, 0)
			
			playAnim('combo', 'appear', true, false)
			playAnim('numbers2', firstNum..getProperty('combo.animation.curAnim.name'), true, false, getProperty('combo.animation.curAnim.curFrame'))
			playAnim('numbers1', secondNum..getProperty('combo.animation.curAnim.name'), true, false, getProperty('combo.animation.curAnim.curFrame'))
			playAnim('numbers0', thirdNum..getProperty('combo.animation.curAnim.name'), true, false, getProperty('combo.animation.curAnim.curFrame'))
			
			runTimer('comboAnimationFinish', getProperty('combo.animation.curAnim.delay') * 16.5) -- run the timer after playing the animation
						
			for i,sprites in pairs({'fc', 'combo', 'numbers0', 'numbers1', 'numbers2'}) do -- do not delete
				setProperty(sprites..'.visible', true)
			end
			
		end
	end
	if hasCombo then
	
		if not sus then
			if hasCounted then
			
				if firstNum < 9 then
					firstNum = firstNum + 1
				else
					secondNum = secondNum + 1
					firstNum = 0
				end
				
				if secondNum > 9 then
					thirdNum = thirdNum + 1
					secondNum = 0
				end
				
				if not appearing and dissappeared then
					setProperty('combo.visible', true)
					playAnim('combo', 'appear', false, false)
					
					if neverMissed then playAnim('fc', 'appear', false, false, 0) else playAnim('fc', 'dissappear', false, false, 15) end
										
					appearing = true
					dissappeared = false
					runTimer('comboAnimationFinish', getProperty('combo.animation.curAnim.delay') * 16.5)
				end
				
				if sound and useTickSound then playSound('tick'..math.floor(math.random(0, 3)), 0.1 * volume) end
				
			end
		end
		
		local comboCurFrame = getProperty('combo.animation.curAnim.curFrame')
		
		playAnim('numbers2', firstNum..getProperty('combo.animation.curAnim.name'), true, false, ((currentFirstNum ~= firstNum and not dissappearing) and 4 or comboCurFrame))
		playAnim('numbers1', secondNum..getProperty('combo.animation.curAnim.name'), true, false, ((currentSecondNum ~= secondNum  and not dissappearing) and 4 or comboCurFrame))
		playAnim('numbers0', thirdNum..getProperty('combo.animation.curAnim.name'), true, false, ((currentThirdNum ~= thirdNum and not dissappearing) and 4 or comboCurFrame))
		
		currentFirstNum = firstNum
		currentSecondNum = secondNum
		currentThirdNum = thirdNum
		runTimer('dissappearCombo', (crochet / 1000) * 3)
	end
end


function noteMissPress() -- remove the entire combo
	if neverMissed then
		playAnim('fc', 'dissappear', true)
		neverMissed = false
	end
	if hasCombo then
		cancelTimer('dissappearCombo')
		cancelTimer('comboAnimationFinish')
		cancelTimer('countComboUp')
		if dissappeared or dissappearing then
			lerpCombo = 0
			firstNum = 0
			secondNum = 0
			thirdNum = 0
		else
			lerpCombo = fullCombo
			runTimer('countComboDown', 0.0035, 0)
		end
		hasCombo = false
		fullCombo = 0
	end
end

function noteMiss() noteMissPress() end

function onTimerCompleted(tag)
	if tag == 'comboAnimationFinish' then
		setProperty('combo.animation.paused', true)
		appeared = true
	elseif tag == 'dissappearCombo' and not dissappearing then
		setProperty('combo.animation.paused', false)
		cancelTimer('comboAnimationFinish')
		dissappearing = true
		playAnim('combo', 'dissappear', false)
		if neverMissed then playAnim('fc', 'dissappear', true) end
		playAnim('numbers2', firstNum..'dissappear', false)
		playAnim('numbers1', secondNum..'dissappear', false)
		playAnim('numbers0', thirdNum..'dissappear', false)
		runTimer('dissappeared', getProperty('combo.animation.curAnim.delay') * 18.5)
	elseif tag == 'countComboDown' then
			lerpCombo = lerpCombo - 1
			-- NUMBER CALCULATION PORTION I DONT KNOW HOW TO USE TABLES (SORRY VOLV IM FOND OF IT NOW)
			if firstNum > 0 then
				firstNum = firstNum - 1
			else
				secondNum = secondNum - 1
				firstNum = 9
			end
			
			if secondNum < 0 and thirdNum > 0 then
				thirdNum = thirdNum - 1
				secondNum = 9
			elseif thirdNum == 0 and secondNum == 0 then
				secondNum = 0
			end
			
			if sound and useTickSound then playSound('tick'..math.floor(math.random(0, 3)), 0.1 * volume) end
			
			playAnim('numbers2', firstNum..getProperty('combo.animation.curAnim.name'), true, false, getProperty('combo.animation.curAnim.curFrame'))
			playAnim('numbers1', secondNum..getProperty('combo.animation.curAnim.name'), true, false, getProperty('combo.animation.curAnim.curFrame'))
			playAnim('numbers0', thirdNum..getProperty('combo.animation.curAnim.name'), true, false, getProperty('combo.animation.curAnim.curFrame'))
			
			-- cood use an i statement but im not sure i can put numbers in variables yet :~P
			
		if lerpCombo <= 0 then
			cancelTimer('countComboDown')
			firstNum = 0
			secondNum = 0
			thirdNum = 0
			dissappearing = true
			playAnim('combo', 'dissappear', false)
			playAnim('numbers2', firstNum..'dissappear', false)
			playAnim('numbers1', secondNum..'dissappear', false)
			playAnim('numbers0', thirdNum..'dissappear', false)
			runTimer('dissappeared', getProperty('combo.animation.curAnim.delay') * 18.5)
		end
	elseif tag == 'countComboUp' then
			lerpCombo = lerpCombo + 1
			
			-- NUMBER CALCULATION PORTION
			if firstNum < 9 then
				firstNum = firstNum + 1
			else
				secondNum = secondNum + 1
				firstNum = 0
			end
			
			if secondNum > 9 then
				thirdNum = thirdNum + 1
				secondNum = 0
			end
		
			if sound and useTickSound then playSound('tick'..math.floor(math.random(0, 3)), 0.1 * volume) end
			
			playAnim('numbers2', firstNum..getProperty('combo.animation.curAnim.name'), true, false, getProperty('combo.animation.curAnim.curFrame'))
			playAnim('numbers1', secondNum..getProperty('combo.animation.curAnim.name'), true, false, getProperty('combo.animation.curAnim.curFrame'))
			playAnim('numbers0', thirdNum..getProperty('combo.animation.curAnim.name'), true, false, getProperty('combo.animation.curAnim.curFrame'))

		if lerpCombo == getProperty('combo') then
			cancelTimer('countComboUp')
			runTimer('dissappearCombo', (crochet / 1000) * 2)
			hasCounted = true
		end
	elseif tag == 'dissappeared' then
		dissappearing = false
		dissappeared = true
		setProperty('combo.visible', false)
		appearing = false
		appeared = false
	end
end
	
		
	
