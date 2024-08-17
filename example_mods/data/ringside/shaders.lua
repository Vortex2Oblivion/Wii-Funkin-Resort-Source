local iTime = 0.0

function onCreatePost()
    initShader("fog", "PerlinSmokeEffect")
    setShaderProperty("fog", "waveStrength", 0)
    setShaderProperty("fog", "smokeStrength", 2)
    setCameraShader("game", "fog")
    initShader("hue", "HSVEffect")
    setShaderProperty("hue", "hue", 0)
    setCameraShader("hud", "hue")
    setCameraShader("game", "hue")

    initShader("barrel", "BarrelBlurEffect")
    setCameraShader("game", "barrel")
    setCameraShader("hud", "barrel")
    setShaderProperty("barrel", "zoom", 3)
    setShaderProperty("barrel", "x", 0)
    setShaderProperty("barrel", "y", 0)
    setShaderProperty("barrel", "angle", -200)
    setShaderProperty("barrel", "barrel", 0)
    setShaderProperty("barrel", "doChroma", true)

    initShader("gray", "GreyScaleEffect")
    initShader("static", "static")
    initShader("sobel", "SobelEffect")
    setShaderProperty("sobel", "strength", 1)
    setShaderProperty("sobel", "intensity", 1)

    makeLuaSprite("topbarlol")
    makeGraphic("topbarlol", screenWidth, screenHeight / 2, '000000')
    addLuaSprite("topbarlol")
    setObjectCamera("topbarlol", "other")
    makeLuaSprite("bottombarlol", "", 0, screenHeight / 2)
    makeGraphic("bottombarlol", screenWidth, screenHeight / 2, '000000')
    addLuaSprite("bottombarlol")
    setObjectCamera("bottombarlol", "other")
end

function onSongStart()
    tweenShaderProperty("barrel", "zoom", 1, 3, "circOut")
    tweenShaderProperty("barrel", "angle", 0, 3, "circOut", 0, function ()
        removeCameraShader("game", "barrel")
        removeCameraShader("hud", "barrel")
    end)
    doTweenY("your", "topbarlol", -screenHeight, 20, "circOut")
    doTweenY("mom", "bottombarlol", screenHeight * 2, 20, "circOut")
end

function onUpdate(elapsed)
    iTime = iTime + elapsed
    setShaderProperty("fog", "iTime", iTime)
    setShaderProperty("static", "iTime", iTime)
    setShaderProperty("weird", "iTime", iTime)
    setShaderProperty("barrel", "iTime", iTime)

    if curStep >= 2048 and curStep < 2304 then
        setShaderProperty("barrel", "angle", math.sin(iTime) * 15)
    end
end

function onSectionHit()
    if curStep > 1024 and curStep < 1231 then
        triggerEvent("Black Flash", 0.75, nil)
        setShaderProperty("barrel", "barrel", -0.2)
        tweenShaderProperty("barrel", "barrel", -0.15, 1, "circIn")
    end
end

function onStepHit()
    if curStep == 896 then
        setCameraShader("game", "barrel")
        setCameraShader("hud", "barrel")
        tweenShaderProperty("barrel", "barrel", -0.15, 7, "circIn", 0, function()
            removeCameraShader("game", "barrel")
            removeCameraShader("hud", "barrel")
            setCameraShader("game", "static")
            setCameraShader("hud", "static")
            setCameraShader("game", "gray")
            setCameraShader("hud", "gray")
            setShaderProperty("gray", "strength", 1)
            setCameraShader("game", "barrel")
            setCameraShader("hud", "barrel")
            triggerEvent("Black Flash", 0.75, nil)
        end)
    end
    if curStep == 1248 then
        tweenShaderProperty("barrel", "zoom", 3, 0.89, "cubeIn", 0, function()
            tweenShaderProperty("barrel", "angle", 360, 0.89, "cubeIn")
            tweenShaderProperty("barrel", "zoom", 1, 0.89, "quintIn", 0, function()
                triggerEvent("Flash Camera", 1, nil)
                tweenShaderProperty("hue", "hue", 0.25, 1)
                removeCameraShader("game", "barrel")
                removeCameraShader("hud", "barrel")
                removeCameraShader("game", "gray")
                removeCameraShader("hud", "gray")
            end)
        end)
    end
    if curStep == 1696 then --nice
        setCameraShader("game", "barrel")
        setCameraShader("hud", "barrel")
        setShaderProperty("barrel", "zoom", 1)
        setShaderProperty("barrel", "angle", 0)
        tweenShaderProperty("barrel", "barrel", -0.225, 5.37, "cubeIn", 0, function()
            removeCameraShader("game", "static")
            removeCameraShader("hud", "static")
            removeCameraShader("game", "barrel")
            removeCameraShader("hud", "barrel")
            setCameraShader("game", "sobel")
            setCameraShader("hud", "sobel")
            setCameraShader("game", "static")
            setCameraShader("hud", "static")
            setCameraShader("game", "gray")
            setCameraShader("hud", "gray")
            setCameraShader("game", "barrel")
            setCameraShader("hud", "barrel")
            setShaderProperty("gray", "strength", 1)
            triggerEvent("Flash Camera", 1, nil)
        end)
    end
    if curStep == 2048 then --nice
        removeCameraShader("game", "gray")
        removeCameraShader("hud", "gray")
        removeCameraShader("game", "sobel")
        removeCameraShader("hud", "sobel")
        triggerEvent("Flash Camera", 1, nil)
        setShaderProperty("gray", "strength", 0)
    end

    if curStep == 2304 then 
        tweenShaderProperty("barrel", "angle", 0, 1)
    end

    if curStep == 2560 then
        removeCameraShader("game", "static")
        removeCameraShader("hud", "static")
        removeCameraShader("game", "barrel")
        removeCameraShader("hud", "barrel")
        setCameraShader("game", "gray")
        setCameraShader("hud", "gray")
        setCameraShader("game", "barrel")
        setCameraShader("hud", "barrel")
        tweenShaderProperty("barrel", "barrel", 0, 1, "linear", 0, function( )
            removeCameraShader("game", "barrel")
            removeCameraShader("hud", "barrel")
        end)
        tweenShaderProperty("gray", "strength", 1, 1)
    end

    if curStep == 2752 then
        tweenShaderProperty("gray", "strength", 0, 15)
        tweenShaderProperty("hue", "hue", 0, 15)

    end
end

function onBeatHit()
    if curBeat % 4 == 0 then
        triggerEvent("Add Camera Zoom", 0.1, 0.1)
    end
end