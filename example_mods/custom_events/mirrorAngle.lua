function onEvent(name, value1, value2)
	if name == 'mirrorAngle' then
		angle = tonumber(value1) --converts Zoom to number
		time = tonumber(value2) --converts Duration to number

		--tweenstuffs
		varNum = getShaderFloatProperty('mirror', 'angle')
		if angle == varNum then
			return
		end
		tweenShaderProperty("_mirror", "angle", angle, time, 'backOut')
	end
end

function onCreatePost()
	initShader("_mirror", "MirrorRepeatEffect")
	setShaderProperty("_mirror", "zoom", 1)
	setShaderProperty("_mirror", "angle", 0)
	setShaderProperty("_mirror", "x", 0)
	setShaderProperty("_mirror", "y", 0)

	setCameraShader('hud', "_mirror")
	setCameraShader('game', "_mirror")
end