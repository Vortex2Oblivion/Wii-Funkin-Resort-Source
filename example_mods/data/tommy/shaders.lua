local shaderTime = 0.0

function onCreatePost()
    initShader("gray", "GreyscaleEffect")
    setCameraShader("hud", "gray")
    setCameraShader("game", "gray")
    setShaderProperty("gray", "strength", 1)
    initShader("bloom", "BloomEffect")
    setCameraShader("hud", "bloom")
    setCameraShader("game", "bloom")
    setShaderProperty("bloom", "strength", 0)
    setShaderProperty("bloom", "effect", 0)
    setShaderProperty("bloom", "brightness", 0)
    setShaderProperty("bloom", "contrast", 0)
    initShader("barrel", "BarrelBlurEffect")
    setCameraShader("hud", "barrel")
    setCameraShader("game", "barrel")
    setShaderProperty("barrel", "barrel", 0)
    setShaderProperty("barrel", "zoom", 2)
    setShaderProperty("barrel", "angle", 45)
    setShaderProperty("barrel", "x", 0)
    setShaderProperty("barrel", "y", 0)
    setShaderProperty("barrel", "doChroma", true)
    initShader("tv", "tvdist")
    initShader("vhs", "vhs")
    setCameraShader("hud", "vhs")
    setCameraShader("game", "vhs")
    initShader("ca", "ChromAbEffect")
    setCameraShader("hud", "ca")
    setCameraShader("game", "ca")
    setShaderProperty("ca", "strength", 0)
    initShader("bloom2", "BloomEffect") --im too lazy to change the other one lol :3
    setCameraShader("hud", "bloom2")
    setCameraShader("game", "bloom2")
    setShaderProperty("bloom2", "strength", 0)
    setShaderProperty("bloom2", "effect", 0)
    setShaderProperty("bloom2", "brightness", 0)
    setShaderProperty("bloom2", "contrast", 1)
end

local strength = 0
local bloom = 0

function onBeatHit()
    if curBeat % 4 == 0 then
        strength = strength + 0.011 + math.random(-0.0025, 0.0025)
    end
    if curBeat % 2 == 0 then 
        triggerEvent("Add Camera Zoom", "0.025", "0.025")
    end
end

function onSongStart()
    tweenShaderProperty("gray", "strength", 0, 4.68, "sineOut")
    tweenShaderProperty("bloom", "contrast", 1, 4.68, "sineOut")
    tweenShaderProperty("barrel", "zoom", 1, 4.68, "sineOut", 0, function()
        tweenShaderProperty("barrel", "barrel", 1, (0.58/1.5)/2, "backOut", 4.1)
        tweenShaderProperty("bloom", "effect", 5, (0.58/1.5)/2, "backOut", 4.1)
        tweenShaderProperty("bloom", "strength", 0.2, (0.58/1.5)/2, "backOut", 4.1)
        tweenShaderProperty("bloom", "contrast", 2, (0.58/1.5)/2, "backOut", 4.1)
        tweenShaderProperty("barrel", "zoom", 2.5, 0.58, "backOut", 4.1, function()
            tweenShaderProperty("barrel", "zoom", 1, 0.58/1.5, "expoOut")
            tweenShaderProperty("bloom", "effect", 0, 0.58/1.5, "expoOut")
            tweenShaderProperty("bloom", "strength", 0, 0.58/1.5, "expoOut")
            tweenShaderProperty("bloom", "contrast", 1, 0.58/1.5, "expoOut")
            tweenShaderProperty("barrel", "barrel", 0, 0.58/1.5, "expoOut", (0.58/1.5)/2)
        end)
    end)
    tweenShaderProperty("barrel", "angle", 0, 4.68, "sineOut")
end
function onUpdate(elapsed)
    strength = lerp(strength, 0, elapsed*5)
    bloom = lerp(bloom, 0, elapsed*2.5)
    shaderTime = shaderTime + elapsed
    setShaderProperty("barrel", "iTime", shaderTime)
    setShaderProperty("tv", "iTime", shaderTime)
    setShaderProperty("vhs", "iTime", shaderTime)
    setShaderProperty("ca", "strength", strength)
    setShaderProperty("bloom2", "brightness", bloom)
end
function onStepHit()
    if curStep == 320 or curStep == 959 then
        tweenShaderProperty("gray", "strength", 1, 0.5, "sineOut")
    end
    if curStep == 348 or curStep == 975 then
        tweenShaderProperty("gray", "strength", 0, 0.5, "expoOut")
    end
    if curStep == 523 or curStep == 587 then
        tweenShaderProperty("barrel", "angle", 3, 0.5, "expoOut")
        tweenShaderProperty("barrel", "x", 0.015, 0.5, "expoOut")
    end
    if curStep == 543 or curStep == 607 then
        tweenShaderProperty("barrel", "x", 0.0, 0.1, "expoOut")
        tweenShaderProperty("barrel", "angle", -1, 0.5, "expoOut")
        tweenShaderProperty("barrel", "y", -0.05, 0.5, "expoOut")
    end
    if curStep == 559 or curStep == 623 then
        tweenShaderProperty("barrel", "angle", 1, 0.5, "expoOut")
        tweenShaderProperty("barrel", "y", 0.05, 0.5, "expoOut", 0, function()
            tweenShaderProperty("barrel", "y", 0, 0.5, "expoOut")
            tweenShaderProperty("barrel", "angle", 0, 0.5, "expoOut")
        end)
    end
    if curStep == 759 then
        tweenShaderProperty("barrel", "barrel", 1, (0.58/1.5)/2, "backOut")
        tweenShaderProperty("bloom", "effect", 5, (0.58/1.5)/2, "backOut")
        tweenShaderProperty("bloom", "strength", 0.2, (0.58/1.5)/2, "backOut")
        tweenShaderProperty("bloom", "contrast", 2, (0.58/1.5)/2, "backOut")
        tweenShaderProperty("barrel", "zoom", 2.5, 0.58, "backOut", 0, function()
            tweenShaderProperty("barrel", "zoom", 1, 0.58/1.5, "expoOut")
            tweenShaderProperty("bloom", "effect", 0, 0.58/1.5, "expoOut")
            tweenShaderProperty("bloom", "strength", 0, 0.58/1.5, "expoOut")
            tweenShaderProperty("bloom", "contrast", 1, 0.58/1.5, "expoOut")
            tweenShaderProperty("barrel", "barrel", 0, 0.58/1.5, "expoOut", (0.58/1.5)/2)
        end)
    end

    if curStep == 1279 then
        setCameraShader("hud", "tv")
        setCameraShader("game", "tv")
        setShaderProperty("tv", "vertJerkOpt", 0)
        setShaderProperty("tv", "vertMovementOpt", 0)
        setShaderProperty("tv", "bottomStaticOpt", 0)
        setShaderProperty("tv", "scalinesOpt", 0)
        setShaderProperty("tv", "rgbOffsetOpt", 0)
        setShaderProperty("tv", "horzFuzzOpt", 0)
        tweenShaderProperty("tv",  'vertJerkOpt', 1, 10.54, "sineOut")
        tweenShaderProperty("tv",  'vertMovementOpt', 1, 10.54, "sineOut")
        tweenShaderProperty("tv",  'bottomStaticOpt', 1, 10.54, "sineOut")
        tweenShaderProperty("tv",  'scalinesOpt', 1, 10.54, "sineOut")
        tweenShaderProperty("tv",  'rgbOffsetOpt', 1, 10.54, "sineOut")
        tweenShaderProperty("tv",  'horzFuzzOpt', 1, 10.54, "sineOut")
        tweenShaderProperty("bloom", "contrast", 0, 10.54, "sineOut")
        tweenShaderProperty("barrel", "angle", -45, 10.54, "sineOut")
        tweenShaderProperty("barrel", "zoom", 3, 10.54, "sineOut")
        tweenShaderProperty("gray", "strength", 1, 10.54, "sineOut")
    end
end

function onEvent(eventName, value1, value2, strumTime)
    if string.lower(eventName) == "bloom flash" then
        bloom = 0.75 + math.random(-0.005, 0.005)
    end
end