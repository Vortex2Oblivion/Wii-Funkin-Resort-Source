local defaultX = 0              -- 0 default
local defaultY = 0              -- 0 default
local defaultAngle = 0          -- 0 default
local defaultZoom = 1           -- 1 default

local effect = 0                -- 0 default
local strength = 1              -- 1 default 
local contrast = 1              -- 1 default
local brightness = 0            -- 0 default

local scale = 0                 -- 0 default

local chromatic = 0             -- 0 default

local pixel = 0                 -- 0 default 

local intensity = 0             -- 0 default
local gradient = 0              -- 0 default

local xcoords = 0               -- 0 default
local ycoords = 0               -- 0 default    
local barrel = 0                -- 0 default
local zoom = 1                  -- 1 default
local angle = 0                 -- 0 default
local doChroma = true           -- true default

local red = 0                   -- 0 default
local green = 0                 -- 0 default
local blue = 0                  -- 0 default         

local blur = 0                  -- 0 default
local blurY = 0                 -- 0 default
local vertical = true           -- true default

local iTime = -0.001                 -- 0 default

local smoke = 1.1                 -- 0 default
local wave = 0.005              -- 0 default

function onCreatePost()
    initLuaShader('mirrorRepeat')
    makeLuaSprite('mirror', '', defaultX,defaultY)
    setSpriteShader('mirror', 'mirrorRepeat')
    setProperty('mirror.angle', defaultAngle)
    makeLuaSprite('mirrorZoom', '', defaultZoom,0)

    makeLuaSprite('bloomEffect', '', effect,0)
    makeLuaSprite('bloomStrength', '', strength,0)
    makeLuaSprite('bloomContrast', '', contrast,0)
    makeLuaSprite('bloomBrightness', '', brightness,0)

    makeLuaSprite('BlurEffect', '', blur,0)
    makeLuaSprite('BlurEffectY', '', blurY,0)
    makeLuaSprite('BlurVertical', '', vertical,true)

    makeLuaSprite('BarrelBlurEffect', '', barrel,0)
    makeLuaSprite('BarrelBlurZoom', '', zoom,1)
    makeLuaSprite('BarrelBlurChroma', '', doChroma,true)
    makeLuaSprite('BarrelBlur', '', angle,0)
    makeLuaSprite('BarrelBlurY', '', ycoords,0)
    makeLuaSprite('BarrelBlurX', '', xcoords,0)
	
	makeLuaSprite('ChromAbEffect', '', chromatic,0)

    makeLuaSprite('MosaicEffect', '', pixel,0)

    makeLuaSprite('greyScale', '', scale,0)

    makeLuaSprite('SobelIntensity', '', intensity,0)
    makeLuaSprite('SobelEffect', '', gradient,0)

    makeLuaSprite('ColorOverrideRed', '', red,0)
    makeLuaSprite('ColorOverrideGreen', '', green,0)
    makeLuaSprite('ColorOverrideBlue', '', blue,0)

    makeLuaSprite('PerlinSmokeSmoke', '', smoke,7)
    makeLuaSprite('PerlinSmokeWave', '', wave,0.004)

    runHaxeCode([[
        game.variables["mirrorRepeat"] = game.modchartSprites.get("mirror").shader;
        game.variables["bloomEffect"] = game.createRuntimeShader("bloom");
        game.variables["greyScale"] = game.createRuntimeShader("greyScale");
        game.variables["ChromAbEffect"] = game.createRuntimeShader("ChromAbEffect");
        game.variables["MosaicEffect"] = game.createRuntimeShader("MosaicEffect");
        game.variables["SobelEffect"] = game.createRuntimeShader("SobelEffect");
        game.variables["BlurEffect"] = game.createRuntimeShader("BlurEffect");
        game.variables["ColorOverrideEffect"] = game.createRuntimeShader("ColorOverrideEffect");
        game.variables["BarrelBlurEffect"] = game.createRuntimeShader("BarrelBlurEffect");
        game.variables["PerlinSmokeEffect"] = game.createRuntimeShader("PerlinSmokeEffect");
        game.variables["weird"] = game.createRuntimeShader("weird");
        game.variables["vcrshader"] = game.createRuntimeShader("vhs");
        game.camGame.setFilters([new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["PerlinSmokeEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["MosaicEffect"]), new ShaderFilter(game.variables["ColorOverrideEffect"]), new ShaderFilter(game.variables["mirrorRepeat"]), new ShaderFilter(game.variables["BarrelBlurEffect"]), new ShaderFilter(game.variables["SobelEffect"]), new ShaderFilter(game.variables["BlurEffect"])]);
        game.camHUD.setFilters([new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["MosaicEffect"]), new ShaderFilter(game.variables["ColorOverrideEffect"]), new ShaderFilter(game.variables["BlurEffect"])]);
    ]])
    updateShader()
end

function updateShader()
    setShaderFloat('mirror', 'x', getProperty('mirror.x'))
    setShaderFloat('mirror', 'y', getProperty('mirror.y'))
    setShaderFloat('mirror', 'angle', getProperty('mirror.angle'))
    setShaderFloat('mirror', 'zoom', getProperty('mirrorZoom.x'))

    runHaxeCode([[
        game.variables["bloomEffect"].setFloat("effect", ]]..(getProperty('bloomEffect.x'))..[[);
        game.variables["bloomEffect"].setFloat("strength", ]]..(getProperty('bloomStrength.x'))..[[);
        game.variables["bloomEffect"].setFloat("contrast", ]]..(getProperty('bloomContrast.x'))..[[);
        game.variables["bloomEffect"].setFloat("brightness", ]]..(getProperty('bloomBrightness.x'))..[[);
        game.variables["greyScale"].setFloat("strength", ]]..(getProperty('greyScale.x'))..[[);
        game.variables["BarrelBlurEffect"].setFloat("barrel", ]]..(getProperty('BarrelBlurEffect.x'))..[[);
        game.variables["BarrelBlurEffect"].setFloat("zoom", ]]..(getProperty('BarrelBlurZoom.x'))..[[);
        game.variables["BarrelBlurEffect"].setBool("doChroma", ]]..(getProperty('BarrelBlurChroma.x'))..[[);
        game.variables["BarrelBlurEffect"].setFloat("angle", ]]..(getProperty('BarrelBlur.angle'))..[[);
        game.variables["BarrelBlurEffect"].setFloat("x", ]]..(getProperty('BarrelBlurX.x'))..[[);
        game.variables["BarrelBlurEffect"].setFloat("y", ]]..(getProperty('BarrelBlurY.y'))..[[);
        game.variables["ChromAbEffect"].setFloat("strength", ]]..(getProperty('ChromAbEffect.x'))..[[);
        game.variables["MosaicEffect"].setFloat("strength", ]]..(getProperty('MosaicEffect.x'))..[[);
        game.variables["SobelEffect"].setFloat("strength", ]]..(getProperty('SobelEffect.x'))..[[);
        game.variables["SobelEffect"].setFloat("intensity", ]]..(getProperty('SobelIntensity.x'))..[[);

        game.variables["ColorOverrideEffect"].setFloat("red", ]]..(getProperty('ColorOverrideRed.x'))..[[);
        game.variables["ColorOverrideEffect"].setFloat("green", ]]..(getProperty('ColorOverrideGreen.x'))..[[);
        game.variables["ColorOverrideEffect"].setFloat("blue", ]]..(getProperty('ColorOverrideBlue.x'))..[[);

        game.variables["BlurEffect"].setFloat("strength", ]]..(getProperty('BlurEffect.x'))..[[);
        game.variables["BlurEffect"].setFloat("strengthY", ]]..(getProperty('BlurEffectY.y'))..[[);
        game.variables["BlurEffect"].setBool("vertical", ]]..(getProperty('BlurVertical.x'))..[[);

        game.variables["PerlinSmokeEffect"].setFloat("waveStrength", ]]..(getProperty('PerlinSmokeWave.x'))..[[);
        game.variables["PerlinSmokeEffect"].setFloat("smokeStrength", ]]..(getProperty('PerlinSmokeSmoke.x'))..[[);
        game.variables["PerlinSmokeEffect"].setFloat("iTime", ]]..iTime..[[);
        game.variables["vcrshader"].setFloat("iTime", ]]..iTime..[[);
    ]])
end

function onUpdate(elapsed)
    iTime = iTime + elapsed
    updateShader()
end

function onEvent(eventName, value1, value2)
    if eventName == 'mirrorBeat' then
        setProperty('mirrorZoom.x', 0.65)
        doTweenX('mirrorZoom', 'mirrorZoom', 1, 0.6, 'cubeOut')
    end

    if eventName == 'BLASTOUTMirrorJump' then
        doTweenX('mirrorZoom', 'mirrorZoom', 1.4, 0.1, 'cubeOut')

            runTimer('wamBam', 0.1)
            function onTimerCompleted(tag, loops, loopsLeft)
            if tag == 'wamBam' then
                doTweenAngle('mirrorAngle', 'mirror', 20, 0.19, 'cubeIn')
                doTweenX('mirrorZoom', 'mirrorZoom', 1, 0.19, 'cubeIn')
                runTimer('schwamNam', 0.19)
            end
            if tag == 'schwamNam' then
                setProperty('mirrorZoom.x', 0.9)
                doTweenX('mirrorZoom', 'mirrorZoom', 1, 0.19, 'cubeOut')
                doTweenAngle('mirrorAngle', 'mirror', 0, 0.19, 'cubeOut')
            end
        end
    end

    if eventName == 'BLASTOUTMirrorJumpReversed' then
        doTweenX('mirrorZoom', 'mirrorZoom', 1.4, 0.1, 'cubeOut')

            runTimer('wamBam', 0.1)
            function onTimerCompleted(tag, loops, loopsLeft)
            if tag == 'wamBam' then
                doTweenAngle('mirrorAngle', 'mirror', -20, 0.19, 'cubeIn')
                doTweenX('mirrorZoom', 'mirrorZoom', 1, 0.19, 'cubeIn')
                runTimer('schwamNam', 0.19)
            end
            if tag == 'schwamNam' then
                setProperty('mirrorZoom.x', 0.9)
                doTweenX('mirrorZoom', 'mirrorZoom', 1, 0.19, 'cubeOut')
                doTweenAngle('mirrorAngle', 'mirror', 0, 0.38, 'cubeOut')
            end
        end
    end

    if eventName == 'bblurBeat' then
        setProperty('BarrelBlurEffect.x', 1)
        doTweenX('BarrelBlurEffect', 'BarrelBlurEffect', 0.15, 0.3)
    end
	
	if eventName == 'ChromBeat' then
		setProperty('ChromAbEffect.x', 0.012)
		doTweenX('ChromAbEffect', 'ChromAbEffect', 0, 0.5, 'cubeOut')
	end
	
	if eventName == 'ChromAbEffect' then 
		doTweenX('ChromAbEffect', 'ChromAbEffect', value1, value2, 'cubeOut')
	end
    
    if eventName == 'BlurEffect' then
        doTweenX('BlurEffect', 'BlurEffect', value1, value2, 'cubeOut')
        doTweenY('BlurEffectY', 'BlurEffectY', value1, value2, 'cubeOut')
    end

    if eventName == 'BlurSnap' then
        setProperty('BlurEffect.x', 0)
        setProperty('BlurEffectY.y', 0)
        setProperty('mirrorZoom.x', 1)
        setProperty('BarrelBlurEffect.x', 0)
	setProperty('ChromAbEffect.x', 0)
    end

    if eventName == 'BlurBeat' then
        setProperty('BlurEffect.x', 10)
        setProperty('BlurEffectY.y', 10)
        doTweenX('BlurEffect', 'BlurEffect', 0, 0.4, 'cubeOut')
        doTweenY('BlurEffectY', 'BlurEffectY', 0, 0.4, 'cubeOut')
        setProperty('mirrorZoom.x', 0.7)
        doTweenX('mirrorZoom', 'mirrorZoom', 1.1, 0.4, 'cubeOut')
        setProperty('BarrelBlurEffect.x', 3)
        doTweenX('BarrelBlurEffect', 'BarrelBlurEffect', -0.5, 0.3)
	setProperty('ChromAbEffect.x', 0.024)
	doTweenX('ChromAbEffect', 'ChromAbEffect', 0, 0.5, 'cubeOut')
    end

    if eventName == 'BlurBeatNoZoom' then
        setProperty('BlurEffect.x', 4.5)
        setProperty('BlurEffectY.y', 4.5)
        doTweenX('BlurEffect', 'BlurEffect', 0, 0.4, 'cubeOut')
        doTweenY('BlurEffectY', 'BlurEffectY', 0, 0.4, 'cubeOut')
    end

    if eventName == 'FadeScreenIn' then
        doTweenX('ColorOverrideGreen', 'ColorOverrideGreen', 0, value1, 'cubeOut')
        doTweenX('ColorOverrideBlue', 'ColorOverrideBlue', 0, value1, 'cubeOut')
        doTweenX('ColorOverrideRed', 'ColorOverrideRed', 0, value1, 'cubeOut')
    end

    if eventName == 'FadeScreenOut' then
        doTweenX('ColorOverrideGreen', 'ColorOverrideGreen', 1, value1, 'cubeIn')
        doTweenX('ColorOverrideBlue', 'ColorOverrideBlue', 1, value1, 'cubeIn')
        doTweenX('ColorOverrideRed', 'ColorOverrideRed', 1, value1, 'cubeIn')
    end

    if eventName == 'BarrelBlur' then
        doTweenX('BarrelBlurEffect', 'BarrelBlurEffect', value1, value2, 'cubeOut')
        setProperty('BarrelBlurChroma.x', true)
    end

    if eventName == 'BarrelBlurNoChroma' then
        doTweenX('BarrelBlurEffect', 'BarrelBlurEffect', value1, value2, 'cubeOut')
        setProperty('BarrelBlurChroma.x', false)
    end

    if eventName == 'BarrelBlurTransition' then
        setProperty('BarrelBlurEffect.x', 25)
        setProperty('BarrelBlurChroma.x', true)

        doTweenX('BarrelBlurEffect', 'BarrelBlurEffect', 0, value1, 'cubeOut')
    end
	
    if eventName == 'MosaicEffect' then
        doTweenX('MosaicEffect', 'MosaicEffect', value1, value2, 'cubeOut')
    end
    
    if eventName == 'SobelEffect' then
        doTweenX("SobelEffect", "SobelEffect", value1, value2, "cubeOut")
        doTweenX("SobelIntensity", "SobelIntensity", value1, value2, "cubeOut")
    end

    if eventName == 'SobelFlash' then
        setProperty('SobelEffect.x', 1)
        setProperty('SobelIntensity.x', 2)


        doTweenX("SobelEffect", "SobelEffect", 0, value1, "cubeOut")
        doTweenX("SobelIntensity", "SobelIntensity", 0, 1, "cubeOut")
    end

    if eventName == 'greyScale' then
        doTweenX('greyScale', 'greyScale', value1, value2, 'linear')
    end

    if eventName == 'bloomHigh' then
		setProperty('bloomEffect.x', 0.8)
		setProperty('bloomStrength.x', 1.3)

        doTweenX("bloomEffect", "bloomEffect", 0, value1, "linear")
        doTweenX("bloomStrength", "bloomStrength", 0, value1, "linear")
    end

    if eventName == 'bloomMed' then
        setProperty('bloomEffect.x', 0.5)
        setProperty('bloomStrength.x', 1)

        doTweenX("bloomEffect", "bloomEffect", 0, value1, "linear")
        doTweenX("bloomStrength", "bloomStrength", 0, value1, "linear")
    end

    if eventName == 'bloomLow' then
        setProperty('bloomEffect.x', 0.2)
        setProperty('bloomStrength.x', 0.7)

        doTweenX("bloomEffect", "bloomEffect", 0, value1, "linear")
        doTweenX("bloomStrength", "bloomStrength", 0, value1, "linear")
    end

    if eventName == 'RainbowShit' then
        doTweenX('colorR', 'ColorOverrideRed', 1.2, 0.75, 'linear') --this starts the cycle

        function onTweenCompleted(tag)
            if tag == 'colorR' then
                doTweenX('colorRG', 'ColorOverrideGreen', 1.2, 0.75, 'linear')
            end
            if tag == 'colorRG' then
                doTweenX('colorG', 'ColorOverrideRed', 0.5, 0.75, 'linear')
            end
            if tag == 'colorG' then
                doTweenX('colorGB', 'ColorOverrideBlue', 1.2, 0.75, 'linear')
            end
            if tag == 'colorGB' then
                doTweenX('colorB', 'ColorOverrideGreen', 0.5, 0.75, 'linear')
            end
            if tag == 'colorB' then
                doTweenX('colorBR', 'ColorOverrideRed', 1.2, 0.75, 'linear')
            end
            if tag == 'colorBR' then
                doTweenX('colorR', 'ColorOverrideBlue', 0.5, 0.75, 'linear')
            end
            if tag == 'colordone' then
                doTweenX('colordone1', 'ColorOverrideRed', 1, 0.2, 'linear')
                doTweenX('colorR', 'ColorOverrideRed', 1, 0.2, 'linear')
                doTweenX('colorRG', 'ColorOverrideGreen', 1, 0.2, 'linear')
                doTweenX('colorG', 'ColorOverrideRed', 1, 0.2, 'linear')
                doTweenX('colorGB', 'ColorOverrideBlue', 1, 0.2, 'linear')
                doTweenX('colorB', 'ColorOverrideGreen', 1, 0.2, 'linear')
                doTweenX('colorBR', 'ColorOverrideRed', 1, 0.2, 'linear')
            end
            if tag == 'colordone1' then
                doTweenX('colordone2', 'ColorOverrideGreen', 1, 0.2, 'linear')
                doTweenX('colorR', 'ColorOverrideRed', 1, 0.2, 'linear')
                doTweenX('colorRG', 'ColorOverrideGreen', 1, 0.2, 'linear')
                doTweenX('colorG', 'ColorOverrideRed', 1, 0.2, 'linear')
                doTweenX('colorGB', 'ColorOverrideBlue', 1, 0.2, 'linear')
                doTweenX('colorB', 'ColorOverrideGreen', 1, 0.2, 'linear')
                doTweenX('colorBR', 'ColorOverrideRed', 1, 0.2, 'linear')
            end
            if tag == 'colordone2' then
                doTweenX('colordone', 'ColorOverrideBlue', 1, 0.2, 'linear')
                doTweenX('colorR', 'ColorOverrideRed', 1, 0.2, 'linear')
                doTweenX('colorRG', 'ColorOverrideGreen', 1, 0.2, 'linear')
                doTweenX('colorG', 'ColorOverrideRed', 1, 0.2, 'linear')
                doTweenX('colorGB', 'ColorOverrideBlue', 1, 0.2, 'linear')
                doTweenX('colorB', 'ColorOverrideGreen', 1, 0.2, 'linear')
                doTweenX('colorBR', 'ColorOverrideRed', 1, 0.2, 'linear')
            end
        end
        if value1 == 'on' then
            doTweenX('colorR', 'ColorOverrideRed', 1.2, 0.2, 'linear')
        end
        if value1 == 'off' then
            doTweenX('colordone', 'ColorOverrideRed', 1, 0.2, 'linear')
            doTweenX('colordone1', 'ColorOverrideGreen', 1, 0.2, 'linear')
            doTweenX('colordone2', 'ColorOverrideBlue', 1, 0.2, 'linear')
        end
    end

    if eventName == 'crazyshader' then
        if value1 == 'cool' then
        runHaxeCode([[
            game.camGame.setFilters([new ShaderFilter(game.variables["weird"]), new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["PerlinSmokeEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["MosaicEffect"]), new ShaderFilter(game.variables["ColorOverrideEffect"]), new ShaderFilter(game.variables["mirrorRepeat"]), new ShaderFilter(game.variables["BarrelBlurEffect"]), new ShaderFilter(game.variables["SobelEffect"]), new ShaderFilter(game.variables["BlurEffect"])]);
            game.camHUD.setFilters([new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["PerlinSmokeEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["MosaicEffect"]), new ShaderFilter(game.variables["SobelEffect"]), new ShaderFilter(game.variables["BlurEffect"])]);
        ]])
        end

        if value1 == 'vcr' then
        runHaxeCode([[
            game.camGame.setFilters([new ShaderFilter(game.variables["vcrshader"]), new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["PerlinSmokeEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["MosaicEffect"]), new ShaderFilter(game.variables["ColorOverrideEffect"]), new ShaderFilter(game.variables["mirrorRepeat"]), new ShaderFilter(game.variables["BarrelBlurEffect"]), new ShaderFilter(game.variables["SobelEffect"]), new ShaderFilter(game.variables["BlurEffect"])]);
            game.camHUD.setFilters([new ShaderFilter(game.variables["vcrshader"]), new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["PerlinSmokeEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["MosaicEffect"]), new ShaderFilter(game.variables["ColorOverrideEffect"]), new ShaderFilter(game.variables["SobelEffect"]), new ShaderFilter(game.variables["BlurEffect"])]);
        ]])
        end

        if value1 == 'nomorecool' then
        runHaxeCode([[
            game.camGame.setFilters([new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["PerlinSmokeEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["MosaicEffect"]), new ShaderFilter(game.variables["ColorOverrideEffect"]), new ShaderFilter(game.variables["mirrorRepeat"]), new ShaderFilter(game.variables["BarrelBlurEffect"]), new ShaderFilter(game.variables["SobelEffect"]), new ShaderFilter(game.variables["BlurEffect"])]);
            game.camHUD.setFilters([new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["PerlinSmokeEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["MosaicEffect"]), new ShaderFilter(game.variables["ColorOverrideEffect"]), new ShaderFilter(game.variables["SobelEffect"]), new ShaderFilter(game.variables["BlurEffect"])]);
        ]])
        end
    end
end

function onStepHit()
    if curStep == 2 then
        triggerEvent('FadeScreenOut','0.01','')
    end
end