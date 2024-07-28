---
--- @param eventName string
--- @param value1 string
--- @param value2 string
---
function onEvent(eventName, value1, value2)
    if eventName == "mirrorScreenMoveXBackIn" then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps --converts Duration to number
		move = tonumber(value1) --converts Zoom to number
        curMovePos = getProperty("mirror.x")
        if move == 0 then
            doTweenX("mirrorMoveX", "mirror", 0, time, "QuartIn")
            updateShader()
        else
            doTweenX("mirrorMoveX", "mirror", curMovePos + move, time, "QuartIn")
            updateShader()
        end
    end
end