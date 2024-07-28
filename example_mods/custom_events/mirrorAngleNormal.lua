function onEvent(name, value1, value2)
	if name == 'mirrorAngleNormal' then
		angle = tonumber(value1) --converts Zoom to number
		time = tonumber(value2) --converts Duration to number

		--tweenstuffs
		varNum = getProperty('mirror.angle')
		if angle == varNum then
			return
		else
			setProperty('mirror.angle', angle)
			doTweenAngle('mirrorAngle', 'mirror', 0, time, 'cubeOut')
			updateShader()
		end
	end
end