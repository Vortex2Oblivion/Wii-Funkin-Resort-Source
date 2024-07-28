function onEvent(name, value1, value2)
	if name == 'mirrorZoom' then
		steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps --converts Duration to number
		zoom = tonumber(value1) --converts Zoom to number

		--tweenstuffs
		varNum = getProperty('mirrorZoom.x')
		if zoom == varNum then
			return
		else
			if zoom == 1 then
				doTweenX('mirrorZoom', 'mirrorZoom', zoom, time, 'cubeIn')
				updateShader()
			else
				doTweenX('mirrorZoom', 'mirrorZoom', zoom, time, 'cubeOut')
				updateShader()
			end
		end
	end
end