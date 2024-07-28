local defaultX = 0
local defaultY = 0
local defaultAngle = 0
local defaultZoom = 1

local effect = 0
local strength = 1
local contrast = 1
local brightness = 0

local scale = 0

local chromatic = 0

local pixel = 0

local intensity = 0
local gradient = 0

local red = 0                   -- 0 default
local green = 0                 -- 0 default
local blue = 0                  -- 0 default         

local xcoords = 0
local ycoords = 0
local barrel = 0
local zoom = 1
local angle = 0
local doChroma = 0

local bstrength = 0
local bloops = 12
local bquality = 12

local iTime = 0

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

    makeLuaSprite('BarrelBlurEffect', '', barrel,0)
    makeLuaSprite('BarrelBlurZoom', '', zoom,1)
    makeLuaSprite('BarrelBlurChroma', '', doChroma,0)
    makeLuaSprite('BarrelBlur', '', angle,0)
    makeLuaSprite('BarrelBlurY', '', ycoords,0)
    makeLuaSprite('BarrelBlurX', '', xcoords,0)
	
	makeLuaSprite('ChromAbEffect', '', chromatic,0)

    makeLuaSprite('greyScale', '', scale,0)

    runHaxeCode([[
        game.variables["mirrorRepeat"] = game.modchartSprites.get("mirror").shader;
        game.variables["bloomEffect"] = game.createRuntimeShader("bloom");
        game.variables["greyScale"] = game.createRuntimeShader("greyScale");
        game.variables["ChromAbEffect"] = game.createRuntimeShader("ChromAbEffect");
        game.variables["BarrelBlurEffect"] = game.createRuntimeShader("BarrelBlurEffect");
        game.camGame.filters = [
            new ShaderFilter(game.variables["mirrorRepeat"]), 
            new ShaderFilter(game.variables["bloomEffect"]), 
            new ShaderFilter(game.variables["greyScale"]), 
            new ShaderFilter(game.variables["ChromAbEffect"]), 
            new ShaderFilter(game.variables["BarrelBlurEffect"])
        ];
        game.camHUD.filters = [
            new ShaderFilter(game.variables["bloomEffect"]), 
            new ShaderFilter(game.variables["greyScale"]), 
            new ShaderFilter(game.variables["ChromAbEffect"]), 
        ];
    ]])
end

function updateShader()
    setShaderFloat('mirror', 'x', getProperty('mirror.x'))
    setShaderFloat('mirror', 'y', getProperty('mirror.y'))
    setShaderFloat('mirror', 'angle', getProperty('mirror.angle'))
    setShaderFloat('mirror', 'zoom', getProperty('mirrorZoom.x'))

    runHaxeCode([[
        game.variables["bloomEffect"].setFloat("effect", ]]..getProperty('bloomEffect.x')..[[);
        game.variables["bloomEffect"].setFloat("strength", ]]..getProperty('bloomStrength.x')..[[);
        game.variables["bloomEffect"].setFloat("contrast", ]]..getProperty('bloomContrast.x')..[[);
        game.variables["bloomEffect"].setFloat("brightness", ]]..getProperty('bloomBrightness.x')..[[);

        game.variables["greyScale"].setFloat("strength", ]]..getProperty('greyScale.x')..[[);

        game.variables["BarrelBlurEffect"].setFloat("barrel", ]]..getProperty('BarrelBlurEffect.x')..[[);
        game.variables["BarrelBlurEffect"].setFloat("zoom", ]]..getProperty('BarrelBlurZoom.x')..[[);
        game.variables["BarrelBlurEffect"].setBool("doChroma", ]]..getProperty('BarrelBlurChroma.x')..[[);
        game.variables["BarrelBlurEffect"].setFloat("angle", ]]..getProperty('BarrelBlur.angle')..[[);
        game.variables["BarrelBlurEffect"].setFloat("x", ]]..getProperty('BarrelBlurX.x')..[[);
        game.variables["BarrelBlurEffect"].setFloat("y", ]]..getProperty('BarrelBlurY.y')..[[);
        
        game.variables["ChromAbEffect"].setFloat("strength", ]]..getProperty('ChromAbEffect.x')..[[);

    ]])
end

function onUpdate(elapsed)
    iTime = iTime + elapsed
    updateShader()
end

function onEvent(eventName, value1, value2)
    if eventName == 'mirrorBeat' then
        setProperty('mirrorZoom.x', 0.85)
        doTweenX('mirrorZoom', 'mirrorZoom', 1, 0.4, 'cubeOut')
    end
	
	if eventName == 'ChromBeat' then
		setProperty('ChromAbEffect.x', 0.009)
		doTweenX('ChromAbEffect', 'ChromAbEffect', 0, 1, 'cubeOut')
	end
	
	if eventName == 'ChromAbEffect' then 
		doTweenX('ChromAbEffect', 'ChromAbEffect', value1, value2, 'cubeOut')
	end

    if eventName == 'BlurEffect' then
        doTweenX('BlurEffect', 'BlurEffect', value1, value2, 'cubeOut')
        doTweenY('BlurEffectY', 'BlurEffectY', value1, value2, 'cubeOut')
    end

    if eventName == 'BlurBeat' then
        setProperty('BlurEffect.x', 10)
        setProperty('BlurEffectY.y', 10)
        doTweenX('BlurEffect', 'BlurEffect', 0, 0.4, 'cubeOut')
        doTweenY('BlurEffectY', 'BlurEffectY', 0, 0.4, 'cubeOut')
    end

    if eventName == 'BarrelBlur' then
        doTweenX('BarrelBlurEffect', 'BarrelBlurEffect', value1, value2, 'cubeOut')
        doTweenX('BarrelBlurChroma', 'BarrelBlurChroma', value1, value2, 'cubeOut')
    end

    if eventName == 'BarrelBlurNoChroma' then
        doTweenX('BarrelBlurEffect', 'BarrelBlurEffect', value1, value2, 'cubeOut')
    end

    if eventName == 'BarrelBlurTransition' then
        setProperty('BarrelBlurEffect.x', -50)
        setProperty('BarrelBlurChroma.x', -30)

        doTweenX('BarrelBlurEffect', 'BarrelBlurEffect', 0, value1, 'cubeOut')
        doTweenX('BarrelBlurChroma', 'BarrelBlurChroma', 0, value1, 'cubeOut')
    end


    if eventName == 'greyScale' then
        doTweenX('greyScale', 'greyScale', value1, value2, 'linear')
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
end