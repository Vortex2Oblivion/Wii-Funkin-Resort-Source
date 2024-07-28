function onEvent(name, value1, value2)
	if name == 'mirrorRotate' then
		steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps
		angle = tonumber(value1) --converts Zoom to number

		--tweenstuffs
		varNum = getProperty('mirror.angle')
		if angle == varNum then
			return
		else
			doTweenAngle('mirrorRotate', 'mirror', angle, time, 'cubeOut')
			updateShader()
		end
	end
end