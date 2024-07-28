function onUpdate(elapsed)
	-- The Actual Code --
	setProperty('dadGroup.x', getProperty('dadGroup.x') + 1 * math.cos(curDecBeat / 4 * math.pi) * elapsed * 60)
	setProperty('dadGroup.y', getProperty('dadGroup.y') + 2 * math.sin(curDecBeat / 4 * math.pi) * elapsed * 60)

	
	-- This Fixes The Camera Bug Issue --
	-- Change the true to false if you see this appearing on BF side and not the opponent Side --
	if mustHitSection == true then
		setProperty('camFollow.x', getProperty('camFollow.x'))
		setProperty('camFollow.y', getProperty('camFollow.y'))
	else
		setProperty('camFollow.x', getProperty('camFollow.x') + 2 * math.cos(curDecBeat / 4 * math.pi) * elapsed * 60)
		setProperty('camFollow.y', getProperty('camFollow.y') + 4 * math.sin(curDecBeat / 4 * math.pi) * elapsed * 60)
	end
end