function onEvent(name, value1, value2)
	if name == 'mirrorAngleBackIn' then
		--debugPrint("eventIsLoaded!", nil, nil, nil, nil)
		steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps
		angle = tonumber(value1) --converts Zoom to number

		--tweenstuffs
		varNum = getProperty('mirror.angle')
		if varNum > 0 then
			doTweenAngle('mirrorAngleBackIn', 'mirror', angle - 25, time, 'cubeIn')
			updateShader()
		elseif varNum <= 0 then
			doTweenAngle("mirrorAngleBackIn", "mirror", angle + 25, time, "cubeIn")
			updateShader()
		end
	end
end

---
--- @param tag string
---
function onTweenCompleted(tag)
	if tag == "mirrorAngleBackIn" then
		doTweenAngle("mirrorAngleBack", "mirror", angle, time, "cubeOut")
		updateShader()
	end
end