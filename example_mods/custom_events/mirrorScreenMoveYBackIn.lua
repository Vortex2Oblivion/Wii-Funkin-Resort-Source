---
--- @param eventName string
--- @param value1 string
--- @param value2 string
---
function onEvent(eventName, value1, value2)
    if eventName == "mirrorScreenMoveYBackIn" then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps --converts Duration to number
		move = tonumber(value1) --converts Zoom to number
        curMovePos = getProperty("mirror.y")
        if move == 0 then
            doTweenY("mirrorMoveY", "mirror", 0, time, "QuartIn")
            updateShader()
        else
            doTweenY("mirrorMoveY", "mirror", curMovePos + move, time, "QuartIn")
            updateShader()
        end
    end
end