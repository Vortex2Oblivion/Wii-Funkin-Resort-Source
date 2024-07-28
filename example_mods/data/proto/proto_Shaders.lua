--i did not write this please do not come after me -vortex
--let the world know lecharter has not heard of for loops
--lecharter the more i look at this the more i hate it you made a new haxe interp for every fucking shader
local defaultX = 0
local defaultY = 0
local defaultAngle = 0
local defaultZoom = 1

local effect = 0
local strength = 0
local contrast = 1
local brightness = 0

local scale = 1

local chromatic = 0

local pixel = 0

local intensity = 0
local gradient = 0

local xcoords = 0
local ycoords = 0
local barrel = 0
local zoom = 1
local angle = 0
local doChroma = true

local blur = 0

local iTime = 0

local size = 0

local amt = 0

local heat = 0

local hm = 0

local defaultXhud = 0
local defaultYhud = 0
local defaulthudAngle = 0
local defaulthudZoom = 1

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

    makeLuaSprite('BarrelBlurEffect', '', barrel,0)
    makeLuaSprite('BarrelBlurZoom', '', zoom,1)
    makeLuaSprite('BarrelBlurChroma', '', doChroma,true)
    makeLuaSprite('BarrelBlur', '', angle,0)
    makeLuaSprite('BarrelBlurY', '', ycoords,0)
    makeLuaSprite('BarrelBlurX', '', xcoords,0)
	
	makeLuaSprite('ChromAbEffect', '', chromatic,0)

    makeLuaSprite('greyScale', '', scale,0)

    makeLuaSprite('SobelIntensity', '', intensity,0)
    makeLuaSprite('SobelEffect', '', gradient,0)

    makeLuaSprite('dSize', '', size,0)

    makeLuaSprite('eyeFishing', '', amt,0)

    setProperty('camGame.zoom', 1.2)

    makeLuaSprite('HeatS', '', heat,0)

    makeLuaSprite('GlitchAMT', '', hm,0)

    makeLuaSprite('mirrorHUDZoom', '', defaulthudZoom,1)
    makeLuaSprite('mirrorHUDang', '', defaulthudAngle,0)
    makeLuaSprite('mirrorHUDY', '', defaultYhud,0)
    makeLuaSprite('mirrorHUDX', '', defaultXhud,0)

    setObjectOrder("opponentStrum", getObjectOrder("playerStrum") )

    runHaxeCode([[
        game.variables["mirrorRepeat"] = game.modchartSprites.get("mirror").shader;
        game.variables["bloomEffect"] = game.createRuntimeShader("bloom");
        game.variables["greyScale"] = game.createRuntimeShader("greyScale");
        game.variables["ChromAbEffect"] = game.createRuntimeShader("ChromAbEffect");
        game.variables["SobelEffect"] = game.createRuntimeShader("SobelEffect");
        game.variables["PincushNewEffect"] = game.createRuntimeShader("PincushNewEffect");
        game.variables["DistortionEffect"] = game.createRuntimeShader("DistortionEffect");
        game.variables["EyeFishEffect"] = game.createRuntimeShader("EyeFishEffect");
        game.variables["vcrshader"] = game.createRuntimeShader("vhs");
        game.variables["HeatEffect"] = game.createRuntimeShader("HeatEffect");
        game.variables["glitchChromatic"] = game.createRuntimeShader("glitchChromatic");
        game.variables["mirrorRepeatHudEffect"] = game.createRuntimeShader("mirrorRepeatHudEffect");
        game.camGame.setFilters([new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["DistortionEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["mirrorRepeat"]), new ShaderFilter(game.variables["PincushNewEffect"]), new ShaderFilter(game.variables["SobelEffect"]), new ShaderFilter(game.variables["HeatEffect"]), new ShaderFilter(game.variables["glitchChromatic"]), new ShaderFilter(game.variables["EyeFishEffect"])]);
        game.camHUD.setFilters([new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["DistortionEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["mirrorRepeatHudEffect"]), new ShaderFilter(game.variables["PincushNewEffect"]), new ShaderFilter(game.variables["SobelEffect"]), new ShaderFilter(game.variables["HeatEffect"]), new ShaderFilter(game.variables["EyeFishEffect"])]);
    ]])
end
function onUpdate(elapsed)
    iTime = iTime + elapsed
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

        game.variables["PincushNewEffect"].setFloat("barrel", ]]..(getProperty('BarrelBlurEffect.x'))..[[);
        game.variables["PincushNewEffect"].setFloat("zoom", ]]..(getProperty('BarrelBlurZoom.x'))..[[);
        game.variables["PincushNewEffect"].setBool("doChroma", ]]..(getProperty('BarrelBlurChroma.x'))..[[);
        game.variables["PincushNewEffect"].setFloat("angle", ]]..(getProperty('BarrelBlur.angle'))..[[);
        game.variables["PincushNewEffect"].setFloat("x", ]]..(getProperty('BarrelBlurX.x'))..[[);
        game.variables["PincushNewEffect"].setFloat("y", ]]..(getProperty('BarrelBlurY.y'))..[[);
        
        game.variables["ChromAbEffect"].setFloat("strength", ]]..(getProperty('ChromAbEffect.x'))..[[);

        game.variables["SobelEffect"].setFloat("strength", ]]..(getProperty('SobelEffect.x'))..[[);
        game.variables["SobelEffect"].setFloat("intensity", ]]..(getProperty('SobelIntensity.x'))..[[);

        game.variables["EyeFishEffect"].setFloat("power", ]]..(getProperty('eyeFishing.x'))..[[);

        game.variables["DistortionEffect"].setFloat("size", ]]..(getProperty('dSize.x'))..[[);

        game.variables["HeatEffect"].setFloat("iTime", ]]..iTime..[[);
        game.variables["HeatEffect"].setFloat("strength", ]]..(getProperty('HeatS.x'))..[[);

        game.variables["glitchChromatic"].setFloat("GLITCH", ]]..(getProperty('GlitchAMT.x'))..[[);
        game.variables["glitchChromatic"].setFloat("iTime", ]]..iTime..[[);

        game.variables["mirrorRepeatHudEffect"].setFloat("zoom", ]]..(getProperty('mirrorHUDZoom.x'))..[[);
        game.variables["mirrorRepeatHudEffect"].setFloat("angle", ]]..(getProperty('mirrorHUDang.angle'))..[[);
        game.variables["mirrorRepeatHudEffect"].setFloat("x", ]]..(getProperty('mirrorHUDX.x'))..[[);
        game.variables["mirrorRepeatHudEffect"].setFloat("y", ]]..(getProperty('mirrorHUDY.y'))..[[);

        game.variables["DistortionEffect"].setFloat("iTime", ']]..iTime..[[');
        game.variables["vcrshader"].setFloat("iTime", ']]..iTime..[[');
    ]])
end

function onEvent(eventName, value1, value2)
    if eventName == 'mirrorBeat' then
        setProperty('mirrorZoom.x', 0.85)
        doTweenX('mirrorZoom', 'mirrorZoom', 1, 0.4, 'cubeOut')
    end

    if eventName == 'mirror-Y' then
        doTweenY('mirror', 'mirror', value1, value2, 'cubeOut')
    end

    if eventName == 'mirror-X' then
        setProperty('mirror.X', value1)
        doTweenY('mirror', 'mirror', 0, value2, 'cubeOut')
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

    if eventName == 'distEvent' then
        doTweenX('dist', 'dSize', value1, value2, 'linear')
    end
    
    if eventName == 'BlurEffect' then
        doTweenX('blurblur', 'BlurEffect', value1, value2, 'cubeOut')
    end

    if eventName == 'BlurSnap' then
        setProperty('BlurEffect.x', 10)
        setProperty('BlurEffectY.y', 10)
        doTweenX('BlurEffect', 'BlurEffect', 0, value1, 'cubeOut')
        doTweenY('BlurEffectY', 'BlurEffectY', 0, value1, 'cubeOut')
    end

    if eventName == 'BlurBeat' then
        setProperty('BlurEffect.x', 0.85)
        setProperty('ChromAbEffect.x', -0.012)
		doTweenX('ChromAbEffect', 'ChromAbEffect', chromatic, 0.5, 'cubeOut')
        doTweenX('BlurEffect', 'BlurEffect', 0, 0.4, 'cubeOut')
        setProperty('BarrelBlurZoom.x', 0.85)
        doTweenX('BarrelBlurZoom', 'BarrelBlurZoom', 1, 0.4, 'cubeOut')
    end

    if eventName == 'BarrelBlur' then
        doTweenX('BarrelBlurEffect', 'BarrelBlurEffect', value1, value2, 'cubeOut')
        setProperty('BarrelBlurChroma.x', true)
    end

    if eventName == 'GlitchEvent' then
        doTweenX('GlitchAMT', 'GlitchAMT', value1, value2, 'cubeOut')
    end

    if eventName == 'middleScrollEvent' then
        if not middlescroll then
            if value1 == 'off' then
                noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0, 0.5, 'quartOut')
                noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1, 0.5, 'quartOut')
                noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2, 0.5, 'quartOut')
                noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3, 0.5, 'quartOut')
                noteTweenX(defaultPlayerStrumX0, 4, defaultPlayerStrumX0, 0.5, 'quartOut')
                noteTweenX(defaultPlayerStrumX1, 5, defaultPlayerStrumX1, 0.5, 'quartOut')
                noteTweenX(defaultPlayerStrumX2, 6, defaultPlayerStrumX2, 0.5, 'quartOut')
                noteTweenX(defaultPlayerStrumX3, 7, defaultPlayerStrumX3, 0.5, 'quartOut')
                for i = 0,3 do
                    noteTweenAlpha("backo"..i+5, i, 1, 0.4,"quartInOut");
                end
                setProperty('dSize.x', size)
            elseif value1 == 'on' then
                setProperty('dSize.x', 0)
                noteTweenX("backx5", 0, 410, 0.4, "quartInOut");
                noteTweenAlpha("backo5", 0, 0.1725, 0.4,"quartInOut");
                -- 2
                noteTweenX("backx6", 1, 522, 0.4, "quartInOut");
                noteTweenAlpha("backo6", 1, 0.1725, 0.4, "quartInOut");
                -- 3
                noteTweenX("backx7", 2, 633, 0.4, "quartInOut");
                noteTweenAlpha("backo7", 2, 0.1725, 0.4, "quartInOut");
                -- 4
                noteTweenX("backx8", 3, 745, 0.4, "quartInOut");
                noteTweenAlpha("backo8", 3, 0.1725, 0.4, "quartInOut");
                ----------              ----------
                noteTweenX("x5", 4, 410, 0.4, "quartInOut");
                noteTweenAlpha("o5", 4, 1, 0.4,"quartInOut");
                ---------- !your note 2 ----------
                noteTweenX("x6", 5, 522, 0.4, "quartInOut");
                noteTweenAlpha("o6", 5, 1, 0.4, "quartInOut");
                ---------- !your note 3 ----------
                noteTweenX("x7", 6, 633, 0.4, "quartInOut");
                noteTweenAlpha("o7", 6, 1, 0.4, "quartInOut");
                ---------- !your note 4 ----------
                noteTweenX("x8", 7, 745, 0.4, "quartInOut");
                noteTweenAlpha("o8", 7, 1, 0.4, "quartInOut");
            end
        end
    end

    if eventName == 'BarrelBlurzooming' then
        if value1 == 'on' then
            doTweenX('BarrelBlurEffect', 'BarrelBlurEffect', -2, 0.1, 'cubeOut')
            doTweenX('mirrorz', 'mirrorZoom', 3, 0.15, 'cubeOut')
            --
        elseif value1 == 'off' then
            doTweenX('BarrelBlurEffect', 'BarrelBlurEffect', 0, 0.1, 'cubeOut')
            doTweenX('mirrornegroZoom', 'mirrorHUDZoom', 1, 0.1, 'cubeOut')
            doTweenX('mirrorz', 'mirrorZoom', 1, 0.1, 'cubeOut')
            --
        elseif value1 == 'offback' then
            doTweenX('BarrelBlurEffect', 'BarrelBlurEffect', 0, 0.29, 'cubeIn')
            doTweenAngle('angle2', 'mirror', 25, 0.29, 'cubeIn')
            doTweenX('mirrorz', 'mirrorZoom', 1, 0.29, 'cubeIn')
            --
            function onTweenCompleted(tag)
                if tag == 'angle2' then
                    doTweenAngle('angle3', 'mirror', 0, 0.4, 'cubeOut')
                end
            end
        end
    end

    if eventName == 'mirrorSmoothBeat' then
        doTweenX('shawarmabitch', 'BarrelBlurZoom', 0.85, 0.14, 'quadIn')
        function onTweenCompleted(tag, loops, loopsLeft)
            if tag == 'shawarmabitch' then
                doTweenX('bbzoms', 'BarrelBlurZoom', 1, 0.14, 'quartIn')
                cameraShake('camGame', 0.013, 0.025)
            end
        end
    end

    if eventName == 'BarrelBlurNoChroma' then
        doTweenX('BarrelBlurEffect', 'BarrelBlurEffect', value1, value2, 'cubeOut')
        setProperty('BarrelBlurChroma.x', false)
    end

    if eventName == 'MirrorAng2' then
        if value1 == 'l 1' then
            setProperty('mirror.angle', -10)
            doTweenAngle('mirrorAng', 'mirror', 0, 0.75, 'quartOut')
            setProperty('mirror.y', -0.25)
            doTweenY('mirrorY', 'mirror', 0, 0.75, 'quartOut')
        elseif value1 == 'l 2' then
            setProperty('mirror.angle', -10)
            doTweenAngle('mirrorAng', 'mirror', 0, 0.75, 'quartOut')
            setProperty('mirror.x', 0.25)
            doTweenX('mirrorxx', 'mirror', 0, 0.75, 'quartOut')
        elseif value1 == 'r 1' then
            setProperty('mirror.angle',10)
            doTweenAngle('mirrorAng', 'mirror', 0, 0.75, 'quartOut')
            setProperty('mirror.y', 0.25)
            doTweenY('mirrorY', 'mirror', 0, 0.75, 'quartOut')
        elseif value1 == 'r 2' then
            setProperty('mirror.angle',10)
            doTweenAngle('mirrorAng', 'mirror', 0, 0.75, 'quartOut')
            setProperty('mirror.x', -0.25)
            doTweenX('mirrorxx', 'mirror', 0, 0.75, 'quartOut')
        elseif value1 == 'r' then
            setProperty('mirror.angle',10)
            doTweenAngle('mirrorAng', 'mirror', 0, 1, 'quartOut')
        elseif value1 == 'l' then
            setProperty('mirror.angle',-10)
            doTweenAngle('mirrorAng', 'mirror', 0, 1, 'quartOut')
        end
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
        if value2 == '' then
            setProperty('greyScale.x', value1)
        end
    end

    if eventName == 'bloomHigh' then
		setProperty('bloomEffect.x', 0.8)
		setProperty('bloomStrength.x', 1.6)

        doTweenX("bloomEffect", "bloomEffect", 0, value1, "linear")
        doTweenX("bloomStrength", "bloomStrength", 0, value1, "linear")
    end

    if eventName == 'bloomMed' then
        setProperty('bloomEffect.x', 0.5)
        setProperty('bloomStrength.x', 1.3)

        doTweenX("bloomEffect", "bloomEffect", 0, value1, "linear")
        doTweenX("bloomStrength", "bloomStrength", 0, value1, "linear")
    end

    if eventName == 'bloomLow' then
        setProperty('bloomEffect.x', 0.2)
        setProperty('bloomStrength.x', 1)

        doTweenX("bloomEffect", "bloomEffect", 0, value1, "linear")
        doTweenX("bloomStrength", "bloomStrength", 0, value1, "linear")
    end

    if eventName == 'pincushEvent' then
        if value1 == 0.5 then
            doTweenX('PincushAmount', 'eyeFishing', value1, value2, 'cubeIn')
        else
            doTweenX('PincushAmount', 'eyeFishing', value1, value2, 'quartOut')
        end
    end

    if eventName == 'mirrorZoom2' then
        doTweenX('mirrorZoom', 'mirrorZoom', value1, value2, 'cubeIn')
    end

    if eventName == 'crazyshader' then
        if value1 == 'y' then
            runHaxeCode([[
                game.camHUD.setFilters([new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["DistortionEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["mirrorRepeatHudEffect"]), new ShaderFilter(game.variables["PincushNewEffect"]), new ShaderFilter(game.variables["SobelEffect"]), new ShaderFilter(game.variables["HeatEffect"]), new ShaderFilter(game.variables["EyeFishEffect"]), new ShaderFilter(game.variables["vcrshader"])]);
                game.camGame.setFilters([new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["DistortionEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["mirrorRepeat"]), new ShaderFilter(game.variables["PincushNewEffect"]), new ShaderFilter(game.variables["SobelEffect"]), new ShaderFilter(game.variables["HeatEffect"]), new ShaderFilter(game.variables["glitchChromatic"]), new ShaderFilter(game.variables["EyeFishEffect"]), new ShaderFilter(game.variables["vcrshader"])]);            ]])
        elseif value1 == 'n' then
            runHaxeCode([[
                game.camHUD.setFilters([new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["DistortionEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["mirrorRepeatHudEffect"]), new ShaderFilter(game.variables["PincushNewEffect"]), new ShaderFilter(game.variables["SobelEffect"]), new ShaderFilter(game.variables["HeatEffect"]), new ShaderFilter(game.variables["EyeFishEffect"])]);
                game.camGame.setFilters([new ShaderFilter(game.variables["greyScale"]), new ShaderFilter(game.variables["ChromAbEffect"]), new ShaderFilter(game.variables["DistortionEffect"]), new ShaderFilter(game.variables["bloomEffect"]), new ShaderFilter(game.variables["mirrorRepeat"]), new ShaderFilter(game.variables["PincushNewEffect"]), new ShaderFilter(game.variables["SobelEffect"]), new ShaderFilter(game.variables["HeatEffect"]), new ShaderFilter(game.variables["glitchChromatic"]), new ShaderFilter(game.variables["EyeFishEffect"])]);
            ]])
        end
    end
end
