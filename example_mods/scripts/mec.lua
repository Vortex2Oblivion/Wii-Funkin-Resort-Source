local songHasPunches = false
local punches = {}
local punchEarlyHitTiming = 160
local punchLateHitTiming = 160
local dodging = false
local dodgeCooldown = 0
local canBeDodged = false
local punchAlpha = 0.00001
local punchAlphaLerpSpeed = 17
local punchTime = 0
local fadeOutDelay = 0
local songPos = 0
local healthToRemove = 0.45
function onCreatePost()
	for i = 0, getProperty("eventNotes.length") - 1 do
		local n = getPropertyFromGroup("eventNotes", i, "event")
		local v1 = getPropertyFromGroup("eventNotes", i, "value1")
		local v2 = getPropertyFromGroup("eventNotes", i, "value2")
		local sT = getPropertyFromGroup("eventNotes", i, "strumTime")
		if n == "punch" or n == "slash" or n == "punch2" or n == "slash2" then
			if v1 == nil or v1 == "" or (v2 == nil or v2 == "") then
				debugPrint("Value 1 or 2 of the event \"" .. n .. "\" on songPos \"" .. sT .. "\" is null. It will not be pushed/loaded.")
				return
			end
			if mechanics then
				table.insert(punches, {
					tonumber(sT),
					tonumber(v1),
					tonumber(v2),
					false,
					tonumber(v1),
					0,
					n
				})
				songHasPunches = true
			end
		end
	end
	if not songHasPunches then
		return
	end
	initMec()
end
function onUpdate(elapsed)
	if not songHasPunches then
		return
	end
	if startedCountdown then
		updateMec(elapsed)
	end
end
function goodNoteHit()
	dodgeCooldown = 0
end
function initMec()
	makeAnimatedLuaSprite("punch", "spacebar")
	addAnimationByPrefix("punch", "normal", "spacebar0", 24, true)
	addAnimationByPrefix("punch", "normal press", "spacebar press", 24, false)
	addAnimationByPrefix("punch", "punch", "spacebar glove press", 24, false)
	addAnimationByPrefix("punch", "slash", "spacebar sword press", 24, false)
	scaleObject("punch", 1.25, 1.25)
	centerOffsets("punch", true)
	addOffset("punch", "normal", -35.875, -12.625)
	addOffset("punch", "normal press", -35.875, -12.625)
	addOffset("punch", "punch", -35.875, (-12.625) + 145)
	addOffset("punch", "slash", -35.875, (-12.625) + 425)
	playAnim("punch", "normal", true)
	screenCenter("punch")
	setProperty("punch.y", getProperty("punch.y") + 125)
	setProperty("punch.alpha", 0.00001)
	setObjectCamera("punch", "hud")
	setObjectOrder("punch", getObjectOrder("strumLineNotes"))
	makeLuaText("msText", "", screenWidth / 2, 0, 0)
	setTextFont("msText", "wii.ttf")
	setTextSize("msText", 32)
	setProperty("msText.borderSize", 1)
	screenCenter("msText")
	setProperty("msText.y", getProperty("msText.y") + 175)
	setProperty("msText.alpha", 0.00001)
	setObjectOrder("msText", getObjectOrder("strumLineNotes"))
	makeLuaText("punchesLeft", "", screenWidth / 2, 0, 0)
	setTextFont("punchesLeft", "wii.ttf")
	setTextSize("punchesLeft", 64)
	setProperty("punchesLeft.borderSize", 1)
	screenCenter("punchesLeft")
	setProperty("punchesLeft.y", getProperty("punchesLeft.y") + 25)
	setObjectOrder("punchesLeft", getObjectOrder("strumLineNotes"))
end
function updateMec(elapsed)
	songPos = getSongPosition()
	canBeDodged = false
	if #punches > 0 then
		local time = punches[1][1]
		local count = punches[1][2]
		local amount = punches[1][3]
		local beatTiming = amount * (stepCrochet * 4)
		if time - 800 < songPos then
			punchAlpha = 1
		end
		if time - beatTiming < songPos then
			fadeOutDelay = 0
			punchTime = time + punches[1][6] * beatTiming
			setTextString("punchesLeft", punches[1][5])
			setTextColor("punchesLeft", "ffffff")
			if punchTime - punchEarlyHitTiming < songPos and songPos < punchTime + punchLateHitTiming then
				setTextColor("punchesLeft", "00ff00")
				canBeDodged = true
				if not punches[1][4] and punchTime - 100 <= songPos then
					punches[1][4] = true
					playAnim("punch", punches[1][7], true)
				end
				if punchTime <= songPos then
					if botPlay then
						tryDodge(true)
					end
				end
			end
			if songPos > punchTime + punchLateHitTiming then
				setHealth(getHealth() - healthToRemove)
				punchRemove()
			end
		end
	end
	if not dodging then
		if keyJustPressed("space") and (not botPlay) then
			tryDodge(false)
		end
	else
		dodgeCooldown = dodgeCooldown - 1000 * elapsed
		if dodgeCooldown <= 0 then
			dodgeCooldown = 0
			dodging = false
		end
	end
	if fadeOutDelay > 0 then
		fadeOutDelay = fadeOutDelay - 1000 * elapsed
	else
		setProperty("punch.alpha", lerp(getProperty("punch.alpha"), punchAlpha, elapsed * punchAlphaLerpSpeed))
	end
	setProperty("msText.alpha", lerp(getProperty("msText.alpha"), 0.00001, elapsed * 8))
	if getProperty("punch.animation.curAnim.name") ~= "normal" and getProperty("punch.alpha") < 0.01 then
		playAnim("punch", "normal", true)
	end
	if followNotes then
		setProperty('punch.x', defaultPlayerStrumX0 + 45)
		setProperty('msText.x', (getMidpointX('punch') / 2) + (getProperty("punch.width") / 2) - 20)
		setProperty('punchesLeft.x', (getMidpointX('punch') / 2) + (getProperty("punch.width") / 2) - 20)
	end
end
function punchRemove()
	punches[1][5] = punches[1][5] - 1
	punches[1][6] = punches[1][6] + 1
	if punches[1][5] <= 0 then
		setTextString("punchesLeft", "")
		fadeOutDelay = 500
		punchAlpha = 0.00001
		table.remove(punches, 1)
	else
		punches[1][4] = false
	end
end
function tryDodge(bot)
	dodging = true
	dodgeCooldown = 500
	if canBeDodged then
		punchRemove()
		dodging = false
		dodgeCooldown = 0
		local ms = -math.floor((punchTime - songPos))
		local text = ms .. "ms" .. (bot and " (BOT)" or "")
		setProperty("msText.alpha", 1)
		setTextString("msText", text)
		setTextColor("msText", "ffffff")
		playAnim("dad", "attack", true)
		setProperty("dad.specialAnim", true)
		playAnim("boyfriend", "dodge", true)
		setProperty("boyfriend.specialAnim", true)
	end
end
