function onEvent(n,v1,v2)


	if n == 'Screen Tilt' then

		setProperty('camHUD.angle',v1)
        setProperty('camGame.angle',v1)
        doTweenAngle('turn', 'camHUD', 0, v2, 'circOut')
        doTweenX('tuin', 'camHUD', 0, v2, 'linear')
		doTweenAngle('tt', 'camGame', 0, v2, 'circOut')
        doTweenX('ttrn', 'camGame', 0, v2, 'linear')
	end



end