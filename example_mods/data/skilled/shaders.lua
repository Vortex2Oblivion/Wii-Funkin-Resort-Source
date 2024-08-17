local iTime = 0
local strength = 0

local rotCamInd = 0

function onCreatePost()
    initShader("blur", "BetterBlurEffect")
    setCameraShader("game", "blur")
    setCameraShader("hud", "blur")
    setShaderProperty("blur", "strength", 15)
    setShaderProperty("blur", "loops", 16)
    setShaderProperty("blur", "quality", 5)
    initShader("vhs", "vhs")
    initShader("ca", "ChromAbEffect")
    setCameraShader("hud", "ca")
    setCameraShader("game", "ca")
    initShader("mirror", "MirrorRepeatEffect")
    setCameraShader("game", "mirror")
    setCameraShader("hud", "mirror")
    setShaderProperty("mirror", "zoom", 1)
    setShaderProperty("mirror", "x", 0)
    setShaderProperty("mirror", "y", 0)
    setShaderProperty("mirror", "angle", 0)
    setShaderProperty("ca", "strength", 0)
    initShader("lines", "ScanlineEffect")
    setCameraShader("hud", "lines")
    setShaderProperty("lines", "strength", 0.25)
    setShaderProperty("lines", "pixelsBetweenEachLine", 5)
    setShaderProperty("lines", "smoothVar", false)
    initShader("hue", "HSVEffect")
    setShaderProperty("hue", "hue", 0)
end
function onSongStart()
    tweenShaderProperty("blur", "strength", 0, 2.67, "expoIn", 0, function( )
        triggerEvent("Flash Camera", "1", nil)
        removeCameraShader("hud", "blur")
        removeCameraShader("game", "blur")
        setCameraShader("game", "vhs")
        setCameraShader("hud", "vhs")
        removeCameraShader("hud", "mirror")
        removeCameraShader("game", "mirror")
        setCameraShader("hud", "mirror")
        setCameraShader("game", "mirror")
    end)
end

function onStepHit()
    if curStep == 26 or curStep == 672 then
        tweenShaderProperty("mirror", "angle", 360, 1, "cubeOut", 0, function( )
            setShaderProperty("mirror", "angle", 0)
        end)
        runTimer("balls", 0.5)
    end
    if curStep == 794 then
        setCameraShader("hud", "hue")
        setCameraShader("game", "hue")
        tweenShaderProperty("hue", "hue", 0.1, 1)
    end
end

function onUpdate(elapsed)
    iTime = iTime + elapsed
    strength = lerp(strength, 0, elapsed*5)
    setShaderProperty("vhs", "iTime", -iTime) --it goes in reverse in the vis
    setShaderProperty("ca", "strength", strength)
    if curStep >= 544 and curStep < 672 then
        setShaderProperty("mirror", "angle", math.sin(iTime) * 15) --https://github.com/GithubSPerez/the-shaggy-mod/blob/main/source/PlayState.hx#L2381
    else
        setShaderProperty("mirror", "angle", math.sin(iTime))
    end
    setShaderProperty("mirror", "x", math.sin(iTime  * 1.01) / 75)
    setShaderProperty("mirror", "y", math.cos(iTime) / 80)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "balls" then
        strength = strength + 0.075
    end
end

function onBeatHit()
    if curBeat % 4 == 0 then
        strength = strength + 0.0125
    end
end