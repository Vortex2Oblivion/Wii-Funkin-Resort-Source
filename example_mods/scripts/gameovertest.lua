function onCreate()
	luaDebugMode = true
	precacheImage("lose")
end

function onUpdate()
	if (getProperty("startingSong") or not getProperty("startedCountdown")) then at = -1 return end
	at = getSongPosition()
end

function formatTime(ms)
	s = math.floor(ms/1000)
	return string.format('%01d:%02d', (s/60)%60, s%60)
end

function onGameOverStart()
	makeAnimatedLuaSprite("lose", "lose", 37, 30)
	addAnimationByPrefix("lose", "lose", "lose", 24, false)
	addOffset("lose", "lose", 0, 154)
	setObjectCamera("lose", "other")
	y = 38 - 154 + getProperty("lose.height")

	makeLuaText(
		"loseText",
		getPropertyFromClass("PlayState", "instance.scoreTxt.text"),
		800,
		37, y - 8
	)
	setTextSize("loseText", 16)
	setTextAlignment("loseText", "left")
	setProperty("loseText.alpha", 0)
	setObjectCamera("loseText", "other")

	makeLuaText(
		"loseText2",
		"On " .. songName .. (at < 0 and "" or " at " .. formatTime(at)),
		800,
		37, y + 18 - 8
	)
	setTextSize("loseText2", 16)
	setTextAlignment("loseText2", "left")
	setProperty("loseText2.alpha", 0)
	setObjectCamera("loseText2", "other")

	runTimer("lose", 1)
	runTimer("loseshow1", 1.3)
	runTimer("loseshow2", 1.6)
end

function onGameOverConfirm()
	runTimer("losefade", .7)
end

local timers = {
	lose = function()
		playAnim("lose", "lose", true)
		addLuaSprite("lose")
	end,
	loseshow1 = function()
		doTweenY("loseTextY", "loseText", y, 1, "quadout")
		doTweenAlpha("loseTextA", "loseText", 1, 1, "quadout")
		addLuaText("loseText")
	end,
	loseshow2 = function()
		doTweenY("loseText2Y", "loseText2", y + 18, 1, "quadout")
		doTweenAlpha("loseText2A", "loseText2", 1, 1, "quadout")
		addLuaText("loseText2")
	end,
	losefade = function()
		doTweenAlpha("lf1", "loseText", 0, 2)
		doTweenAlpha("lf2", "loseText2", 0, 2)
		doTweenAlpha("lf3", "lose", 0, 2)
	end
}

function onTimerCompleted(tag)
	if (timers[tag]) then timers[tag]() end
end