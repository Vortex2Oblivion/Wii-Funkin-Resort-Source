local daStep = 0
local debugMode = true
local isDead = false
local beats = {
    {0, 20},
    {0, 20, 32, 44, 52}
}

function onCreatePost() 
    if debugMode then
        luaDebugMode = true 
    end

    addHaxeLibrary('FlxMath', 'flixel.math')

    initShaders()

    set('greyScale.strength', 1)
    set('bloom.contrast', 0)
    set('barrelBlur.zoom', 3)
    set('barrelBlur.barrel', 0.02)
    set('blur.strength', 4)
    set('blur.strengthY', 4)
    set('scanline.strength', 1)

    daStep = stepCrochet / 1000 / playbackRate
end

function onSongStart()
    tweenShader('bloom', {contrast = 1}, daStep * 8, 'cubeOut')
    tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 8, 'cubeOut')
    tweenShader('blur', {strength = 1, strengthY = 1}, daStep * 8, 'cubeOut')
end

function onUpdatePost(elapsed)
    if startedCountdown and not getProperty('inCutscene') and not isDead then
        updateShaders(elapsed)
    end
end

local repeatStep = 0
local bloomEvents = {128, 256, 384, 512, 576, 768, 896, 1024, 1152, 1280, 1296, 1312, 1328, 1344, 1360, 1376, 1392, 1408, 1424, 1440, 1456, 1472, 1488, 1504, 1520, 1536, 1664, 1792}
local events = {
    [112] = function() 
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 8, 'cubeOut')
    end,
    [120] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 8, 'cubeIn')
    end,
    [128] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'angle', 'barrel'})

        set('barrelBlur.zoom', 0.2)
        set('barrelBlur.barrel', -20)

        tweenShader('greyScale', {strength = 0}, daStep * 4, 'cubeOut')
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'cubeOut')
        tweenShader('scanline', {strength = 0}, daStep * 4, 'cubeOut')
    end,
    [248] = function() 
        tweenShader('barrelBlur', {zoom = 2, angle = 15, barrel = 0.2}, daStep * 4, 'cubeOut')
    end,
    [252] = function() 
        tweenShader('barrelBlur', {zoom = 1, angle = 0, barrel = 0}, daStep * 4, 'cubeIn')
    end,
    [256] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'angle'})

        set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', -15)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'cubeOut')
    end,
    [376] = function() 
        tweenShader('barrelBlur', {zoom = 1.5, barrel = 0.2}, daStep * 4, 'cubeOut')
    end,
    [380] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'cubeIn')
    end,
    [384] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'angle'})

        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'cubeOut')
    end,
    [504] = function() 
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 4, 'cubeOut')
    end,
    [508] = function() 
        tweenShader('barrelBlur', {x = -1, zoom = 1, barrel = 0}, daStep * 4, 'cubeIn')
    end,
    [512] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'angle'})

        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.angle', 15)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'cubeOut')
    end,
    [540] = function() 
        tweenShader('barrelBlur', {x = 1}, daStep * 4, 'cubeIn')
    end,
    [572] = function() 
        tweenShader('barrelBlur', {x = -1, y = 1}, daStep * 4, 'cubeIn')
    end,
    [604] = function() 
        tweenShader('barrelBlur', {x = 1, y = 0}, daStep * 4, 'cubeIn')
    end,
    [632] = function() 
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 4, 'cubeOut')
    end,
    [636] = function() 
        tweenShader('barrelBlur', {x = -0.5, zoom = 1, barrel = 0}, daStep * 4, 'cubeIn')
    end,
    [640] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'angle'})

        set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', -15)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'cubeOut')
    end,
    [700] = function() 
        tweenShader('barrelBlur', {x = 0.5}, daStep * 4, 'cubeIn')
    end,
    [720] = function() 
        tweenShader('barrelBlur', {zoom = 1.5, barrel = 0.2}, daStep * 4, 'cubeOut')
    end,
    [736] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'cubeOut')
    end,
    [760] = function() 
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 4, 'cubeOut')
    end,
    [764] = function() 
        tweenShader('barrelBlur', {x = 0, zoom = 1, barrel = 0}, daStep * 4, 'cubeIn')
    end,
    [768] = function()
        tweenShaderCancel('barrelBlur', {'zoom', 'angle', 'barrel'})

        set('barrelBlur.zoom', 0.2)
        set('barrelBlur.barrel', -10)

        tweenShader('greyScale', {strength = 1}, daStep * 4, 'cubeOut')
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'cubeOut')
        tweenShader('scanline', {strength = 1}, daStep * 4, 'cubeOut')
    end,
    [1024] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'angle'})

        set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', -15)
        tweenShader('barrelBlur', {zoom = 1.5, angle = 0, barrel = 0.2}, daStep * 4, 'cubeOut')
    end,
    [1028] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'cubeIn')
    end,
    [1032] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})

        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'cubeOut')
    end,
    [1272] = function() 
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 4, 'cubeOut')
    end,
    [1276] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'cubeIn')
    end,
    [1280] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'angle'})

        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.angle', 30)
        tweenShader('barrelBlur', {zoom = 1.5, angle = 0, barrel = 0.2}, daStep * 4, 'cubeOut')
        tweenShader('barrelBlur', {x = 4}, daStep * 64, 'linear')
    end,
    [1336] = function() 
        tweenShader('barrelBlur', {zoom = 2, angle = 15}, daStep * 4, 'cubeOut')
    end,
    [1340] = function() 
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'cubeIn')
    end,
    [1344] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'angle'})

        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.angle', -30)
        tweenShader('barrelBlur', {zoom = 1.25, angle = 0}, daStep * 4, 'cubeOut')
        tweenShader('barrelBlur', {x = 0}, daStep * 64, 'linear')
    end,
    [1400] = function() 
        tweenShader('barrelBlur', {zoom = 2}, daStep * 4, 'cubeOut')
    end,
    [1404] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'cubeIn')
    end,
    [1408] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})

        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1.5, angle = -10}, daStep * 8, 'cubeOut')
        tweenShader('barrelBlur', {x = -4, y = 4}, daStep * 64, 'linear')
    end,
    [1424] = function() 
        tweenShader('barrelBlur', {zoom = 1.75, angle = 10}, daStep * 8, 'cubeOut')
    end,
    [1432] = function() 
        tweenShader('barrelBlur', {zoom = 2, angle = 0}, daStep * 8, 'cubeOut')
    end,
    [1440] = function() 
        tweenShader('barrelBlur', {zoom = 1.5, angle = -10}, daStep * 8, 'cubeOut')
    end,
    [1456] = function() 
        tweenShader('barrelBlur', {zoom = 1.75, angle = 10}, daStep * 8, 'cubeOut')
    end,
    [1464] = function() 
        tweenShader('barrelBlur', {zoom = 2, angle = 0}, daStep * 4, 'cubeOut')
    end,
    [1468] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'cubeIn')
    end,
    [1472] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})

        --set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', 15)
        tweenShader('barrelBlur', {zoom = 1.25, angle = 0}, daStep * 8, 'cubeOut')
        tweenShader('barrelBlur', {x = 0, y = 0}, daStep * 64, 'linear')
    end,
    [1520] = function() 
        tweenShader('barrelBlur', {zoom = 2}, daStep * 8, 'cubeOut')
    end,
    [1528] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 8, 'cubeIn')
    end,
    [1536] = function()
        tweenShaderCancel('barrelBlur', {'zoom', 'angle', 'barrel'})

        set('barrelBlur.zoom', 0.2)
        set('barrelBlur.barrel', -10)

        tweenShader('greyScale', {strength = 1}, daStep * 4, 'cubeOut')
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'cubeOut')
        tweenShader('scanline', {strength = 1}, daStep * 4, 'cubeOut')
    end,
    [1784] = function() 
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 4, 'cubeOut')
    end,
    [1788] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'cubeIn')
    end,
    [1792] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'barrel'})

        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.barrel', -10)

        tweenShader('greyScale', {strength = 1}, daStep * 4, 'cubeOut')
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'cubeOut')
        tweenShader('scanline', {strength = 1}, daStep * 4, 'cubeOut')
        tweenShader('blur', {strengthY = 2}, daStep * 4, 'cubeOut')
    end,
    [1808] = function() 
        tweenShader('bloom', {contrast = 0}, daStep * 16, 'cubeInOut')
        tweenShader('barrelBlur', {zoom = 5}, daStep * 16, 'cubeInOut')
        tweenShader('blur', {strength = 8, strengthY = 8}, daStep * 16, 'cubeInOut')
    end
}
function onStepHit()
    local section = math.floor(curStep / 16) 

    for i = 1, #bloomEvents do
        if curStep == bloomEvents[i] then
            bloomBurst()
        end
    end

    if (section >= 8 and section < 16) or (section >= 56 and section < 64) or (section >= 104 and section < 112) then
        for i = 1, #beats[1] do
            if curStep % 32 == beats[1][i] then
                tweenShaderCancel('barrelOffset', {'zoom'})
                tweenShaderCancel('blur', {'strengthY'})

                set('ca2.strength', 0.005)
                set('barrelOffset.zoom', -0.1)
                set('blur.strengthY', 2)
                tweenShader('barrelOffset', {zoom = 0}, daStep * 8, 'cubeOut')
                tweenShader('blur', {strengthY = 0}, daStep * 8, 'cubeOut')
            end
        end
    end
    if (section >= 16 and section < 32) or (section >= 65 and section < 80) then
        for i = 1, #beats[2] do
            if curStep % 64 == beats[2][i] then
                tweenShaderCancel('barrelOffset', {'zoom'})
                tweenShaderCancel('blur', {'strengthY'})

                set('ca2.strength', 0.006)
                set('barrelOffset.zoom', -0.15)
                set('blur.strengthY', 3)
                tweenShader('barrelOffset', {zoom = 0}, daStep * 8, 'cubeOut')
                tweenShader('blur', {strengthY = 0}, daStep * 8, 'cubeOut')
            end
        end
    end
    if (section >= 32 and section < 48) then
        if curStep % 4 == 0 then
            tweenShaderCancel('barrelOffset', {'zoom'})
            tweenShaderCancel('blur', {'strengthY'})

            set('ca2.strength', 0.0055)
            set('barrelOffset.zoom', -0.125)
            set('blur.strengthY', 2.5)
            tweenShader('barrelOffset', {zoom = 0}, daStep * 8, 'cubeOut')
            tweenShader('blur', {strengthY = 0}, daStep * 8, 'cubeOut')
        end
    end
    if (section >= 80 and section < 96) then
        if curStep % 16 == 0 then
            tweenShaderCancel('barrelOffset', {'zoom'})
            tweenShaderCancel('blur', {'strengthY'})

            set('ca2.strength', 0.0075)
            set('barrelOffset.zoom', -0.4)
            set('blur.strengthY', 4)
            tweenShader('barrelOffset', {zoom = 0}, daStep * 8, 'cubeOut')
            tweenShader('blur', {strengthY = 0}, daStep * 8, 'cubeOut')
        end
    end

    if section == 49 or section == 65 then
        repeatStep = -768
    end
    if curStep == 1024 or section == 79 or section == 110 then
        repeatStep = 0
    end
    if curStep == 1540 then
        repeatStep = -1536
    end

    if events[curStep + repeatStep] then
        events[curStep + repeatStep]()
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

    tweenShader('bloom', {effect = 0, strength = 0}, daStep * 8, 'cubeOut')
    tweenShader('ca', {strength = 0}, daStep * 8, 'cubeOut')
    tweenShader('blur', {strength = 0}, daStep * 8, 'cubeOut')
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
        setVar('barrelBlur', {shader: null, barrel: 0, zoom: 1, doChroma: false, iTime: 0, angle: 0, x: 0, y: 0});
        setVar('barrelBlurHUD', {shader: null, barrel: 0, zoom: 1, doChroma: false, iTime: 0, angle: 0, x: 0, y: 0});
        setVar('blur', {shader: null, strength: 0, strengthY: 0});
        setVar('scanline', {shader: null, strength: 0, pixelsBetweenEachLine: 10, smoothVar: false});
        setVar('barrelOffset', {x: 0, y: 0, zoom: 0, angle: 0, offsetAngle: 0});

        game.initLuaShader('GreyscaleEffect');
        game.initLuaShader('BloomEffect');
        game.initLuaShader('ChromAbEffect');
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
    
        getVar('barrelBlur').shader = game.createRuntimeShader('BarrelBlurEffect');
        getVar('barrelBlur').shader.setFloat('barrel', getVar('barrelBlur').barrel);
        getVar('barrelBlur').shader.setFloat('zoom', getVar('barrelBlur').zoom);
        getVar('barrelBlur').shader.setBool('doChroma', getVar('barrelBlur').doChroma);
        getVar('barrelBlur').shader.setFloat('iTime', getVar('barrelBlur').iTime);
        getVar('barrelBlur').shader.setFloat('angle', getVar('barrelBlur').angle);
        getVar('barrelBlur').shader.setFloat('x', getVar('barrelBlur').x);
        getVar('barrelBlur').shader.setFloat('y', getVar('barrelBlur').y);
        getVar('setCameraShader')('camGame', getVar('barrelBlur').shader);

        getVar('barrelBlurHUD').shader = game.createRuntimeShader('MirrorRepeatEffect');
        getVar('barrelBlurHUD').shader.setFloat('zoom', getVar('barrelBlurHUD').zoom);
        getVar('barrelBlurHUD').shader.setFloat('angle', getVar('barrelBlurHUD').angle);
        getVar('barrelBlurHUD').shader.setFloat('x', getVar('barrelBlurHUD').x);
        getVar('barrelBlurHUD').shader.setFloat('y', getVar('barrelBlurHUD').y);
        getVar('setCameraShader')('camHUD', getVar('barrelBlurHUD').shader);

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
            getVar('ca2').strength = FlxMath.lerp(getVar('ca2').strength, 0, (elapsed * game.playbackRate) * 5);
            getVar('ca2').shader.setFloat('strength', getVar('ca2').strength);
        }
        if (getVar('ca').shader != null) 
            getVar('ca').shader.setFloat('strength', getVar('ca').strength);
        if (getVar('barrelBlur').shader != null) { 
            getVar('barrelBlur').shader.setFloat('barrel', getVar('barrelBlur').barrel);
            getVar('barrelBlur').shader.setFloat('zoom', getVar('barrelBlur').zoom + getVar('barrelOffset').zoom);
            getVar('barrelBlur').shader.setBool('doChroma', getVar('barrelBlur').doChroma);
            getVar('barrelBlur').shader.setFloat('iTime', Conductor.songPosition / 1000);
            getVar('barrelBlur').shader.setFloat('angle', getVar('barrelBlur').angle + getVar('barrelOffset').angle);
            getVar('barrelBlur').shader.setFloat('x', getVar('barrelBlur').x + getVar('barrelOffset').x);
            getVar('barrelBlur').shader.setFloat('y', getVar('barrelBlur').y + getVar('barrelOffset').y);
        }
        if (getVar('barrelBlurHUD').shader != null) { 
            getVar('barrelBlurHUD').shader.setFloat('zoom', getVar('barrelBlur').zoom + getVar('barrelOffset').zoom);
            getVar('barrelBlurHUD').shader.setFloat('angle', getVar('barrelBlur').angle + getVar('barrelOffset').angle);
            getVar('barrelBlurHUD').shader.setFloat('x', getVar('barrelBlurHUD').x + getVar('barrelOffset').x);
            getVar('barrelBlurHUD').shader.setFloat('y', getVar('barrelBlurHUD').y + getVar('barrelOffset').y);
        }
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