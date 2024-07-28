--[[ 
    dont mess with this, unless you know what you are doing. -Tih
--]]

local debugMode = true
local daStep = 0
local beats = {
    {0, 20, 26, 32},
    {0, 4, 8, 12, 14, 16, 20, 24, 28, 31, 34}
}
local doSwitch = false
local perlinX = 0
local perlinY = 0
local perlinZ = 0
local perlinXRange = 0.03
local perlinYRange = 0.03
local perlinZRange = 7.5
local isDead = false

function onCreatePost() 
    if debugMode then
        luaDebugMode = true 
    end

    addHaxeLibrary('FlxMath', 'flixel.math')

    initShaders()

    setVar('perlinMult', {x = 1, y = 1, z = 1})

    set('greyScale.strength', 1)
    set('bloom.contrast', 0)
    set('barrelBlur.zoom', 2)
    set('barrelBlur.barrel', -1)
    set('blur.strength', 4)
    set('blur.strengthY', -4)
    set('scanline.strength', 1)

    daStep = stepCrochet / 1000 / playbackRate
end

function onSongStart()
    tweenShader('bloom', {contrast = 1}, daStep * 16, 'circOut')
    tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 8, 'circOut')
end

local events = { -- add rainbow effect (maybe) -Tih
    [96] = function() 
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 16, 'circOut')
    end,
    [112] = function()
        tweenShader('greyScale', {strength = 0}, daStep * 16, 'circIn')
        tweenShader('blur', {strength = 0, strengthY = 0}, daStep * 16, 'circIn')
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 16, 'circIn')
        set('barrelOffset.zoom', -0.1)
    end,
    [114] = function()
        set('barrelOffset.zoom', -0.2)
    end,
    [116] = function()
        set('barrelOffset.zoom', -0.3)
    end,
    [117] = function()
        set('barrelOffset.zoom', -0.4)
    end,
    [120] = function()
        set('barrelOffset.zoom', -0.5)
    end,
    [122] = function()
        set('barrelOffset.zoom', -0.6)
    end,
    [125] = function()
        set('barrelOffset.zoom', -0.7)
    end,
    [128] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'barrel'})
        set('barrelBlur.zoom', 0.3)
        set('barrelBlur.barrel', -10)
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 8, 'circOut')
        tweenShader('scanline', {strength = 0}, daStep * 8, 'circOut')

        bloomBurst()
    end,
    [248] = function() 
        tweenShader('barrelBlur', {zoom = 3, barrel = 0.02}, daStep * 4, 'circOut')
    end,
    [252] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [256] = function() 
        set('barrelBlur.angle', -15)
        tweenShader('barrelBlur', {angle = 0}, daStep * 8, 'circOut')

        bloomBurst()
    end,
    [314] = function() 
        set('ca.strength', -0.02)
        set('barrelBlur.zoom', 1.15)
        set('pixel.strength', 5)
    end,
    [315] = function() 
        set('ca.strength', 0.04)
        set('barrelBlur.zoom', 1.3)
        set('pixel.strength', 7.5)
    end,
    [316] = function() 
        set('ca.strength', -0.08)
        set('barrelBlur.zoom', 1.5)
        set('pixel.strength', 10)
    end,
    [317] = function() 
        set('ca.strength', 0)
        set('pixel.strength', 0)
    end,
    [318] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 2, 'circIn')
    end,
    [320] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})

        set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', 15)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'circOut')

        bloomBurst()
    end,
    [378] = function() 
        set('ca.strength', 0.02)
        set('barrelBlur.zoom', 1.15)
        set('pixel.strength', 5)
    end,
    [379] = function() 
        set('ca.strength', -0.04)
        set('barrelBlur.zoom', 1.3)
        set('pixel.strength', 7.5)
    end,
    [380] = function() 
        set('ca.strength', 0.08)
        set('barrelBlur.zoom', 1.5)
        set('pixel.strength', 10)
    end,
    [381] = function() 
        set('ca.strength', 0)
        set('pixel.strength', 0)
    end,
    [382] = function() 
        tweenShader('barrelBlur', {zoom = 0.5}, daStep * 2, 'circIn')
    end,
    [384] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShader('barrelBlur', {zoom = 1.5, angle = -15, barrel = 0.2}, daStep * 2, 'circOut')
    end,
    [388] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShader('barrelBlur', {zoom = 2, angle = 15}, daStep * 2, 'circOut')
    end,
    [392] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShader('barrelBlur', {zoom = 1, angle = 0, barrel = 0}, daStep * 4, 'circOut')

        bloomBurst()
    end,
    [404] = function() 
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 2, 'circOut')
    end,
    [410] = function() 
        tweenShader('barrelBlur', {zoom = 3, barrel = 0.02}, daStep * 2, 'circOut')
    end,
    [412] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [440] = function() 
        tweenShader('barrelBlur', {zoom = 2, angle = -15, barrel = 0.2}, daStep * 4, 'circOut')
    end,
    [444] = function() 
        tweenShader('barrelBlur', {zoom = 1, angle = 0, barrel = 0}, daStep * 4, 'circIn')
    end,
    [448] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})

        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.angle', 15)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'circOut')

        bloomBurst()
    end,
    [512] = function() 
        tweenShader('barrelBlur', {zoom = 1.5, barrel = 0.25}, daStep * 32, 'cubeInOut')

        bloomBurst()
    end,
    [568] = function() 
        tweenShader('greyScale', {strength = 1}, daStep * 16, 'circOut')
        tweenShader('scanline', {strength = 1}, daStep * 16, 'circOut')
        tweenShader('blur', {strength = -5, strengthY = 5}, daStep * 16, 'circOut')
    end, 
    [612] = function() 
        tweenShader('greyScale', {strength = 0}, daStep * 28, 'circIn')
        tweenShader('scanline', {strength = 0}, daStep * 28, 'circIn')
        tweenShader('blur', {strength = 0, strengthY = 0}, daStep * 28, 'circIn')
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 28, 'circIn')
    end,
    [640] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})

        set('barrelBlur.zoom', 0.1)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')

        bloomBurst()
    end, 
    [696] = function() 
        tweenShader('barrelBlur', {zoom = 1.5, barrel = 0.25}, daStep * 4, 'circOut')
    end,
    [700] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [704] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})

        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')

        bloomBurst()
    end,
    [760] = function() 
        tweenShader('barrelBlur', {zoom = 3, barrel = 0.02}, daStep * 4, 'circOut')
    end,
    [764] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [768] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})

        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')

        bloomBurst()
    end,
    [826] = function() 
        set('ca.strength', -0.02)
        set('barrelBlur.zoom', 1.15)
        set('pixel.strength', 5)
    end,
    [827] = function() 
        set('ca.strength', 0.04)
        set('barrelBlur.zoom', 1.3)
        set('pixel.strength', 7.5)
    end,
    [828] = function() 
        set('ca.strength', -0.08)
        set('barrelBlur.zoom', 1.5)
        set('pixel.strength', 10)
    end,
    [829] = function() 
        set('ca.strength', 0)
        set('pixel.strength', 0)
    end,
    [830] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 2, 'circIn')
    end,
    [832] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})

        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')

        bloomBurst()
    end,
    [864] = function() 
        tweenShader('greyScale', {strength = 1}, daStep * 16, 'cubeInOut')
        tweenShader('scanline', {strength = 1}, daStep * 16, 'cubeInOut')
        tweenShader('blur', {strength = -2}, daStep * 16, 'cubeInOut')
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 16, 'cubeInOut')
    end,
    [880] = function() 
        tweenShader('greyScale', {strength = 0}, daStep * 16, 'circIn')
        tweenShader('scanline', {strength = 0}, daStep * 16, 'circIn')
        tweenShader('blur', {strength = 0}, daStep * 16, 'circIn')
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 16, 'circIn')
    end,
    [890] = function() 
        set('ca.strength', 0.02)
        set('pixel.strength', 5)
    end,
    [891] = function() 
        set('ca.strength', -0.04)
        set('pixel.strength', 7.5)
    end,
    [892] = function() 
        set('ca.strength', 0.08)
        set('pixel.strength', 10)
    end,
    [893] = function() 
        set('ca.strength', 0)
        set('pixel.strength', 0)
    end,
    [896] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 8, 'circOut')

        bloomBurst()
    end,
    [1016] = function() 
        tweenShader('barrelBlur', {zoom = 3, barrel = 0.02}, daStep * 4, 'circOut')
    end,
    [1020] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1024] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', -30)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'circOut')

        bloomBurst()
    end,
    [1082] = function() 
        set('ca.strength', -0.02)
        set('barrelBlur.zoom', 1.15)
        set('pixel.strength', 5)
    end,
    [1083] = function() 
        set('ca.strength', 0.04)
        set('barrelBlur.zoom', 1.3)
        set('pixel.strength', 7.5)
    end,
    [1084] = function() 
        set('ca.strength', -0.08)
        set('barrelBlur.zoom', 1.5)
        set('pixel.strength', 10)
    end,
    [1085] = function() 
        set('ca.strength', 0)
        set('pixel.strength', 0)
    end,
    [1086] = function() 
        tweenShader('barrelBlur', {zoom = 3, barrel = 0.02}, daStep * 4, 'circOut')
    end,
    [1092] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1096] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')

        bloomBurst()
    end,
    [1146] = function() 
        set('ca.strength', 0.02)
        set('barrelBlur.zoom', 1.15)
        set('pixel.strength', 5)
    end,
    [1147] = function() 
        set('ca.strength', -0.04)
        set('barrelBlur.zoom', 1.3)
        set('pixel.strength', 7.5)
    end,
    [1148] = function() 
        set('ca.strength', 0.08)
        set('barrelBlur.zoom', 1.5)
        set('pixel.strength', 10)
    end,
    [1149] = function() 
        set('ca.strength', -0.12)
        set('pixel.strength', 12.5)
    end,
    [1150] = function() 
        set('ca.strength', 0)
        set('pixel.strength', 0)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 2, 'circIn')
    end,
    [1152] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})

        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.angle', 30)
        set('barrelBlur.barrel', -20)
        tweenShader('barrelBlur', {x = -0.5, zoom = 1, angle = 0, barrel = 0}, daStep * 4, 'circOut')

        bloomBurst()
    end,
    [1216] = function() 
        tweenShader('barrelBlur', {x = 0.5, zoom = 1.25, barrel = 0.3}, daStep * 2, 'circOut')
        bloomBurst()
    end,
    [1248] = function() 
        tweenShader('greyScale', {strength = 1}, daStep * 2, 'circOut')
        tweenShader('scanline', {strength = 1}, daStep * 2, 'circOut')
        tweenShader('blur', {strength = -4}, daStep * 2, 'circOut')
        tweenShader('barrelBlur', {x = 0, zoom = 2, barrel = 0.2}, daStep * 2, 'circOut')
    end,
    [1250] = function() 
        tweenShader('greyScale', {strength = 0}, daStep * 2, 'circIn')
        tweenShader('scanline', {strength = 0}, daStep * 2, 'circIn')
        tweenShader('blur', {strength = 0}, daStep * 2, 'circIn')
        tweenShader('barrelBlur', {zoom = 1}, daStep * 2, 'circIn')
    end,
    [1252] = function() 
        set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', -30)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'circOut')

        bloomBurst()
    end,
    [1272] = function() 
        tweenShader('barrelBlur', {zoom = 3, barrel = 0.02}, daStep * 4, 'circOut')
    end,
    [1276] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'barrel'})
        tweenShader('barrelBlur', {x = 0, zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1280] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', 30)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'circOut')

        bloomBurst()
    end,
    [1376] = function() 
        tweenShader('blur', {strength = -4, strengthY = 4}, daStep * 32, 'cubeInOut')
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 28, 'cubeInOut')
    end,
    [1404] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1408] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.barrel', -20)
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circOut')

        set('bloom.effect', 0.25)
        set('bloom.strength', 3)
        set('ca.strength', 0.007)
        tweenShader('bloom', {effect = 0, strength = 0}, daStep * 16, 'circOut')
        tweenShader('ca', {strength = 0}, daStep * 16, 'circOut')

        tweenShader('greyScale', {strength = 1}, daStep * 4, 'circOut')
        tweenShader('scanline', {strength = 1}, daStep * 4, 'circOut')
    end,
    [1600] = function() 
        tweenShader('barrelBlur', {zoom = 3, barrel = 0.02}, daStep * 64, 'cubeIn')
        tweenShader('blur', {strength = 8, strengthY = -8}, daStep * 64, 'cubeIn')
        tweenShader('bloom', {contrast = 0}, daStep * 64, 'cubeIn')
        tweenShader('pixel', {strength = 20}, daStep * 64, 'cubeIn')
    end
}
function onStepHit()
    local section = math.floor(curStep / 16) 

    if (section >= 0 and section < 7) or (section >= 8 and section < 24) or (section >= 25 and section < 32) or
       (section >= 64 and curStep < 1078) or (section >= 69 and section < 71) or (section >= 72 and curStep < 1244) or
       (section >= 79 and section < 88) then
        for i = 1, #beats[1] do
            if curStep % 32 == beats[1][i] then
                tweenShaderCancel('barrelOffset', {'zoom'})

                set('ca2.strength', 0.005)
                set('barrelOffset.zoom', -0.2)
                tweenShader('barrelOffset', {zoom = 0}, daStep * 8, 'circOut')
            end
        end
    end
    if (section >= 40 and curStep < 698) or (section >= 44 and section < 56) then
        for i = 1, #beats[2] do
            if curStep % 32 == beats[2][i] then
                tweenShaderCancel('barrelOffset', {'zoom', 'offsetAngle'})
                tweenShaderCancel('blur', {'strengthY'})

                doSwitch = not doSwitch
                set('ca2.strength', 0.0075)
                set('barrelOffset.zoom', -0.25)
                set('barrelOffset.offsetAngle', (doSwitch and -10 or 10))
                set('blur.strengthY', (doSwitch and -4 or 4))
                tweenShader('barrelOffset', {zoom = 0, offsetAngle = 0}, daStep * 8, 'circOut')
                tweenShader('blur', {strengthY = 0}, daStep * 8, 'circOut')
            end
        end
    end

    if events[curStep] then
        events[curStep]()
    end
end

function onUpdate(elapsed)
    if startedCountdown and not getProperty('inCutscene') and not isDead then 
        perlinX = perlinX + elapsed * math.random() * getVar('perlinMult')['x']
        perlinY = perlinY + elapsed * math.random() * getVar('perlinMult')['y']
        perlinZ = perlinZ + elapsed * math.random() * getVar('perlinMult')['z']
    
        setVar('_noise', {x = perlin:noise(perlinX, 0, 0), y = perlin:noise(0, perlinY, 0), z = perlin:noise(0, 0, perlinZ)})
    end
end
function onUpdatePost(elapsed) 
    if startedCountdown and not getProperty('inCutscene') and not isDead then
        updateShaders(elapsed)
    end
end

function onGameOverStart()
    isDead = true
end

function bloomBurst() 
    tweenShaderCancel('bloom', {'effect', 'strength'})
    tweenShaderCancel('ca', {'strength'})
    tweenShaderCancel('blur', {'strength'})

    set('bloom.effect', 0.25)
    set('bloom.strength', 3)
    set('ca.strength', 0.0075)
    set('blur.strength', 4)

    tweenShader('bloom', {effect = 0, strength = 0}, daStep * 16, 'circOut')
    tweenShader('ca', {strength = 0}, daStep * 16, 'circOut')
    tweenShader('blur', {strength = 0}, daStep * 16, 'circOut')
end
function initShaders() 
    runHaxeCode([[ 
        setVar('_camGame', {shaders: []});
        setVar('_camHUD', {shaders: []});
        setVar('setCameraShader', function(cam:String, shader:FlxRuntimeShader) { 
            var daCam = (cam == 'camHUD' ? game.camHUD : (cam == 'camOther' ? game.camOther : game.camGame));
            getVar('_' + cam).shaders.push(new ShaderFilter(shader));
            daCam.setFilters(getVar('_' + cam).shaders);
        });
        setVar('getFlxEaseByString', function(?ease:String = '') { 
            switch(ease.toLowerCase()) {
                case 'backin': return FlxEase.backIn;
                case 'backinout': return FlxEase.backInOut;
                case 'backout': return FlxEase.backOut;
                case 'bouncein': return FlxEase.bounceIn;
                case 'bounceinout': return FlxEase.bounceInOut;
                case 'bounceout': return FlxEase.bounceOut;
                case 'circin': return FlxEase.circIn;
                case 'circinout': return FlxEase.circInOut;
                case 'circout': return FlxEase.circOut;
                case 'cubein': return FlxEase.cubeIn;
                case 'cubeinout': return FlxEase.cubeInOut;
                case 'cubeout': return FlxEase.cubeOut;
                case 'elasticin': return FlxEase.elasticIn;
                case 'elasticinout': return FlxEase.elasticInOut;
                case 'elasticout': return FlxEase.elasticOut;
                case 'expoin': return FlxEase.expoIn;
                case 'expoinout': return FlxEase.expoInOut;
                case 'expoout': return FlxEase.expoOut;
                case 'quadin': return FlxEase.quadIn;
                case 'quadinout': return FlxEase.quadInOut;
                case 'quadout': return FlxEase.quadOut;
                case 'quartin': return FlxEase.quartIn;
                case 'quartinout': return FlxEase.quartInOut;
                case 'quartout': return FlxEase.quartOut;
                case 'quintin': return FlxEase.quintIn;
                case 'quintinout': return FlxEase.quintInOut;
                case 'quintout': return FlxEase.quintOut;
                case 'sinein': return FlxEase.sineIn;
                case 'sineinout': return FlxEase.sineInOut;
                case 'sineout': return FlxEase.sineOut;
                case 'smoothstepin': return FlxEase.smoothStepIn;
                case 'smoothstepinout': return FlxEase.smoothStepInOut;
                case 'smoothstepout': return FlxEase.smoothStepInOut;
                case 'smootherstepin': return FlxEase.smootherStepIn;
                case 'smootherstepinout': return FlxEase.smootherStepInOut;
                case 'smootherstepout': return FlxEase.smootherStepOut;
            }
            return FlxEase.linear;
        });


        setVar('greyScale', {shader: null, strength: 0});
        setVar('bloom', {shader: null, effect: 0, strength: 0, contrast: 1, brightness: 0});
        setVar('ca', {shader: null, strength: 0});
        setVar('ca2', {shader: null, strength: 0});
        setVar('pixel', {shader: null, strength: 0});
        setVar('barrelBlur', {shader: null, barrel: 0, zoom: 1, doChroma: false, iTime: 0, angle: 0, x: 0, y: 0});
        setVar('barrelBlurHUD', {shader: null, barrel: 0, zoom: 1, doChroma: false, iTime: 0, angle: 0, x: 0, y: 0});
        setVar('blur', {shader: null, strength: 0, strengthY: 0});
        setVar('scanline', {shader: null, strength: 0, pixelsBetweenEachLine: 10, smoothVar: false});
        setVar('barrelOffset', {x: 0, y: 0, zoom: 0, angle: 0, offsetAngle: 0});

        game.initLuaShader('GreyscaleEffect');
        game.initLuaShader('BloomEffect');
        game.initLuaShader('ChromAbEffect');
        game.initLuaShader('MosaicEffect');
        game.initLuaShader('BarrelBlurEffect');
        game.initLuaShader('BlurEffect');
        game.initLuaShader('ScanlineEffect');

        getVar('greyScale').shader = game.createRuntimeShader('GreyscaleEffect');
        getVar('greyScale').shader.setFloat('strength', getVar('greyScale').strength);
        getVar('setCameraShader')('camGame', getVar('greyScale').shader);
        getVar('setCameraShader')('camHUD', getVar('greyScale').shader);
    
        getVar('bloom').shader = game.createRuntimeShader('BloomEffect');
        getVar('bloom').shader.setFloat('effect', getVar('bloom').effect);
        getVar('bloom').shader.setFloat('strength', getVar('bloom').strength);
        getVar('bloom').shader.setFloat('contrast', getVar('bloom').contrast);
        getVar('bloom').shader.setFloat('brightness', getVar('bloom').brightness);
        getVar('bloom').shader.setFloatArray('iResolution', [FlxG.width, FlxG.height]);
        getVar('setCameraShader')('camGame', getVar('bloom').shader);
        getVar('setCameraShader')('camHUD', getVar('bloom').shader);

        getVar('ca2').shader = game.createRuntimeShader('ChromAbEffect');
        getVar('ca2').shader.setFloat('strength', getVar('ca2').strength);
        getVar('setCameraShader')('camGame', getVar('ca2').shader);
        getVar('setCameraShader')('camHUD', getVar('ca2').shader);
    
        getVar('ca').shader = game.createRuntimeShader('ChromAbEffect');
        getVar('ca').shader.setFloat('strength', getVar('ca').strength);
        getVar('setCameraShader')('camGame', getVar('ca').shader);
        getVar('setCameraShader')('camHUD', getVar('ca').shader);
    
        getVar('pixel').shader = game.createRuntimeShader('MosaicEffect');
        getVar('pixel').shader.setFloat('strength', getVar('pixel').strength);
        getVar('setCameraShader')('camGame', getVar('pixel').shader);
        getVar('setCameraShader')('camHUD', getVar('pixel').shader);
    
        getVar('barrelBlur').shader = game.createRuntimeShader('BarrelBlurEffect');
        getVar('barrelBlur').shader.setFloat('barrel', getVar('barrelBlur').barrel);
        getVar('barrelBlur').shader.setFloat('zoom', getVar('barrelBlur').zoom);
        getVar('barrelBlur').shader.setBool('doChroma', getVar('barrelBlur').doChroma);
        getVar('barrelBlur').shader.setFloat('iTime', getVar('barrelBlur').iTime);
        getVar('barrelBlur').shader.setFloat('angle', getVar('barrelBlur').angle);
        getVar('barrelBlur').shader.setFloat('x', getVar('barrelBlur').x);
        getVar('barrelBlur').shader.setFloat('y', getVar('barrelBlur').y);
        getVar('setCameraShader')('camGame', getVar('barrelBlur').shader);

        /*getVar('barrelBlurHUD').shader = game.createRuntimeShader('MirrorRepeatEffect');
        getVar('barrelBlurHUD').shader.setFloat('zoom', getVar('barrelBlurHUD').zoom);
        getVar('barrelBlurHUD').shader.setFloat('angle', getVar('barrelBlurHUD').angle);
        getVar('barrelBlurHUD').shader.setFloat('x', getVar('barrelBlurHUD').x);
        getVar('barrelBlurHUD').shader.setFloat('y', getVar('barrelBlurHUD').y);
        getVar('setCameraShader')('camHUD', getVar('barrelBlurHUD').shader);*/
    
        getVar('blur').shader = game.createRuntimeShader('BlurEffect');
        getVar('blur').shader.setFloat('strength', getVar('blur').strength);
        getVar('blur').shader.setFloat('strengthY', getVar('blur').strengthY);
        getVar('setCameraShader')('camGame', getVar('blur').shader);
        getVar('setCameraShader')('camHUD', getVar('blur').shader);
    
        getVar('scanline').shader = game.createRuntimeShader('ScanlineEffect');
        getVar('scanline').shader.setFloat('strength', getVar('scanline').strength);
        getVar('scanline').shader.setFloat('pixelsBetweenEachLine', getVar('scanline').pixelsBetweenEachLine);
        getVar('scanline').shader.setBool('smoothVar', getVar('scanline').smoothVar);
        getVar('setCameraShader')('camHUD', getVar('scanline').shader);
    ]])
end
function updateShaders(elapsed) 
    runHaxeCode([[ 
        var elapsed = ]]..elapsed..[[;

        getVar('barrelOffset').x = getVar('_noise').x * ]]..perlinXRange..[[;
        getVar('barrelOffset').y = getVar('_noise').y * ]]..perlinYRange..[[;
        getVar('barrelOffset').angle = (getVar('_noise').z * ]]..perlinZRange..[[) + getVar('barrelOffset').offsetAngle;

        if (getVar('greyScale').shader != null)  
            getVar('greyScale').shader.setFloat('strength', getVar('greyScale').strength);
        if (getVar('bloom').shader != null) { 
            getVar('bloom').shader.setFloat('effect', getVar('bloom').effect);
            getVar('bloom').shader.setFloat('strength', getVar('bloom').strength);
            getVar('bloom').shader.setFloat('contrast', getVar('bloom').contrast);
            getVar('bloom').shader.setFloat('brightness', getVar('bloom').brightness);
            getVar('bloom').shader.setFloatArray('iResolution', [FlxG.width, FlxG.height]);
        }
        if (getVar('ca2').shader != null) {
            getVar('ca2').strength = FlxMath.lerp(getVar('ca2').strength, 0, elapsed * 5);
            getVar('ca2').shader.setFloat('strength', getVar('ca2').strength);
        }
        if (getVar('ca').shader != null) 
            getVar('ca').shader.setFloat('strength', getVar('ca').strength);
        if (getVar('pixel').shader != null)  
            getVar('pixel').shader.setFloat('strength', getVar('pixel').strength);
        if (getVar('barrelBlur').shader != null) { 
            getVar('barrelBlur').shader.setFloat('barrel', getVar('barrelBlur').barrel);
            getVar('barrelBlur').shader.setFloat('zoom', getVar('barrelBlur').zoom + getVar('barrelOffset').zoom);
            getVar('barrelBlur').shader.setBool('doChroma', getVar('barrelBlur').doChroma);
            getVar('barrelBlur').shader.setFloat('iTime', Conductor.songPosition / 1000);
            getVar('barrelBlur').shader.setFloat('angle', getVar('barrelBlur').angle + getVar('barrelOffset').angle);
            getVar('barrelBlur').shader.setFloat('x', getVar('barrelBlur').x + getVar('barrelOffset').x);
            getVar('barrelBlur').shader.setFloat('y', getVar('barrelBlur').y + getVar('barrelOffset').y);
        }
        /*if (getVar('barrelBlurHUD').shader != null) { 
            getVar('barrelBlurHUD').shader.setFloat('zoom', getVar('barrelBlurHUD').zoom + getVar('barrelOffset').zoom);
            getVar('barrelBlurHUD').shader.setFloat('angle', getVar('barrelBlurHUD').angle + getVar('barrelOffset').angle);
            getVar('barrelBlurHUD').shader.setFloat('x', getVar('barrelBlurHUD').x + getVar('barrelOffset').x);
            getVar('barrelBlurHUD').shader.setFloat('y', getVar('barrelBlurHUD').y + getVar('barrelOffset').y);
        }*/
        if (getVar('blur').shader != null) {
            getVar('blur').shader.setFloat('strength', getVar('blur').strength);
            getVar('blur').shader.setFloat('strengthY', getVar('blur').strengthY);
        }
        if (getVar('scanline').shader != null) { 
            getVar('scanline').shader.setFloat('strength', getVar('scanline').strength);
            getVar('scanline').shader.setFloat('pixelsBetweenEachLine', getVar('scanline').pixelsBetweenEachLine);
            getVar('scanline').shader.setBool('smoothVar', getVar('scanline').smoothVar);
        }
    ]])
end

function onPause()
    runHaxeCode([[ 
        FlxTween.globalManager.forEach(function(twn:FlxTween) { 
            twn.active = false;
        });
    ]])
end
function onResume()
    runHaxeCode([[ 
        FlxTween.globalManager.forEach(function(twn:FlxTween) { 
            twn.active = true;
        });
    ]])
end

function get(var) 
    return getProperty(var)
end
function set(var, value) 
    setProperty(var, value)
end

--[[ 
    perlin stuff
--]]
Bit = {}
perlin = {}
perlin.p = {}

Bit.band = function(x, y)
    local p = 1
    local result = 0
    while x > 0 and y > 0 do
        local rx = x % 2
        local ry = y % 2
        if rx == 1 and ry == 1 then
            result = result + p
        end
        p = p * 2
        x = math.floor(x / 2)
        y = math.floor(y / 2)
    end
    return result
end

-- Hash lookup table as defined by Ken Perlin
-- This is a randomly arranged array of all numbers from 0-255 inclusive
local permutation = {151,160,137,91,90,15,
  131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
  190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
  88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
  77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
  102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
  135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
  5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
  223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
  129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
  251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
  49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
  138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
}

-- p is used to hash unit cube coordinates to [0, 255]
for i=0,255 do
    -- Convert to 0 based index table
    perlin.p[i] = permutation[i+1]
    -- Repeat the array to avoid buffer overflow in hash function
    perlin.p[i+256] = permutation[i+1]
end

-- Return range: [-1, 1]
function perlin:noise(x, y, z)
    y = y or 0
    z = z or 0

    -- Calculate the "unit cube" that the point asked will be located in
    local xi = Bit.band(math.floor(x),255)
    local yi = Bit.band(math.floor(y),255)
    local zi = Bit.band(math.floor(z),255)

    -- Next we calculate the location (from 0 to 1) in that cube
    x = x - math.floor(x)
    y = y - math.floor(y)
    z = z - math.floor(z)

    -- We also fade the location to smooth the result
    local u = self.fade(x)
    local v = self.fade(y)
    local w = self.fade(z)

    -- Hash all 8 unit cube coordinates surrounding input coordinate
    local p = self.p
    local A, AA, AB, AAA, ABA, AAB, ABB, B, BA, BB, BAA, BBA, BAB, BBB
    A   = p[xi  ] + yi
    AA  = p[A   ] + zi
    AB  = p[A+1 ] + zi
    AAA = p[ AA ]
    ABA = p[ AB ]
    AAB = p[ AA+1 ]
    ABB = p[ AB+1 ]

    B   = p[xi+1] + yi
    BA  = p[B   ] + zi
    BB  = p[B+1 ] + zi
    BAA = p[ BA ]
    BBA = p[ BB ]
    BAB = p[ BA+1 ]
    BBB = p[ BB+1 ]

    -- Take the weighted average between all 8 unit cube coordinates
    return self.lerp(w,
        self.lerp(v,
            self.lerp(u,
                self:grad(AAA,x,y,z),
                self:grad(BAA,x-1,y,z)
            ),
            self.lerp(u,
                self:grad(ABA,x,y-1,z),
                self:grad(BBA,x-1,y-1,z)
            )
        ),
        self.lerp(v,
            self.lerp(u,
                self:grad(AAB,x,y,z-1), self:grad(BAB,x-1,y,z-1)
            ),
            self.lerp(u,
                self:grad(ABB,x,y-1,z-1), self:grad(BBB,x-1,y-1,z-1)
            )
        )
    )
end

-- Gradient function finds dot product between pseudorandom gradient vector
-- and the vector from input coordinate to a unit cube vertex
perlin.dot_product = {
    [0x0]=function(x,y,z) return  x + y end,
    [0x1]=function(x,y,z) return -x + y end,
    [0x2]=function(x,y,z) return  x - y end,
    [0x3]=function(x,y,z) return -x - y end,
    [0x4]=function(x,y,z) return  x + z end,
    [0x5]=function(x,y,z) return -x + z end,
    [0x6]=function(x,y,z) return  x - z end,
    [0x7]=function(x,y,z) return -x - z end,
    [0x8]=function(x,y,z) return  y + z end,
    [0x9]=function(x,y,z) return -y + z end,
    [0xA]=function(x,y,z) return  y - z end,
    [0xB]=function(x,y,z) return -y - z end,
    [0xC]=function(x,y,z) return  y + x end,
    [0xD]=function(x,y,z) return -y + z end,
    [0xE]=function(x,y,z) return  y - x end,
    [0xF]=function(x,y,z) return -y - z end
}
function perlin:grad(hash, x, y, z)
    return self.dot_product[Bit.band(hash,0xF)](x,y,z)
end

-- Fade function is used to smooth final output
function perlin.fade(t)
    return t * t * t * (t * (t * 6 - 15) + 10)
end

function perlin.lerp(t, a, b)
    return a + t * (b - a)
end