local daStep = 0
local debugMode = true
local isDead = false
local doSwitch = false
local canSwitch = false
local beats = { 
    {0, 10, 12, 14, 20, 32, 38, 44, 52}
}

function onCreatePost() 
    if debugMode then
        luaDebugMode = true 
    end

    addHaxeLibrary('FlxMath', 'flixel.math')

    initShaders()

    daStep = stepCrochet / 1000 / playbackRate
end

function onSongStart() 
    
end

function onUpdatePost(elapsed) 
    if startedCountdown and not getProperty('inCutscene') and not isDead then
        updateShaders(elapsed)
    end
end

local repeatStep = 0
local mirrorEvents = { 
    {1040, false, false}, {1044, true, false}, {1048, false, true}, {1052, true, true},
    {1056, false, false}, {1060, true, false}, {1064, false, true}, {1068, true, false},
    {1104, false, false}, {1108, true, false}, {1112, false, true}, {1116, true, true},
    {1120, false, true}, {1124, true, true}, {1128, true, false}, {1132, false, true}
}
local bloomEvents = {16, 80, 144, 272, 400, 528, 656, 784, 848, 912, 1168, 1296, 1424}
local events = { 
    [4] = function() 
        tweenShader('barrelBlur', {zoom = 3}, daStep * 4, 'circOut')
        tweenShader('greyScale', {strength = 0.95}, daStep * 4, 'circOut')
        tweenShader('ca', {strength = 0.01}, daStep * 4, 'circOut')
    end,
    [8] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 8, 'circIn')
        tweenShader('barrelBlur', {angle = 360}, daStep * 16, 'circInOut')
        tweenShader('greyScale', {strength = 0}, daStep * 8, 'circIn')
    end,
    [128] = function() 
        tweenShader('barrelBlur', {zoom = 2}, daStep * 8, 'circOut')
        tweenShader('greyScale', {strength = 0.95}, daStep * 8, 'circOut')
        tweenShader('ca', {strength = 0.01}, daStep * 8, 'circOut')
    end,
    [136] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 8, 'circIn')
        tweenShader('greyScale', {strength = 0}, daStep * 8, 'circIn')
    end,
    [144] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.4)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 8, 'circOut')
    end,
    [264] = function()
        set('barrelBlur.angle', 0)
        tweenShader('barrelBlur', {zoom = 2, angle = 15}, daStep * 4, 'circOut')
    end,
    [268] = function()
        tweenShader('barrelBlur', {zoom = 1, angle = -15}, daStep * 4, 'circIn')
    end,
    [272] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'angle'})
        set('barrelBlur.zoom', 0.4)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 8, 'circOut')
    end,
    [392] = function() 
        tweenShader('barrelBlur', {zoom = 1.5}, daStep * 4, 'circOut')
    end,
    [396] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circIn')
    end,
    [400] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.4)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 8, 'circOut')
    end,
    [520] = function() 
        tweenShader('barrelBlur', {zoom = 1.5, angle = -15}, daStep * 4, 'circOut')
    end,
    [524] = function() 
        tweenShader('barrelBlur', {zoom = 1, angle = 15}, daStep * 4, 'circIn')
    end,
    [528] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'angle'})
        set('barrelBlur.zoom', 0.4)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 8, 'circOut')
    end,
    [640] = function() 
        tweenShader('barrelBlur', {zoom = 2}, daStep * 8, 'circOut')
    end,
    [648] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 8, 'circIn')
    end,
    [656] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.4)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 8, 'circOut')
    end,
    [768] = function() 
        tweenShader('barrelBlur', {zoom = 2}, daStep * 8, 'circOut')
        tweenShader('greyScale', {strength = 0.95}, daStep * 8, 'circOut')
        tweenShader('ca', {strength = 0.01}, daStep * 8, 'circOut')
    end,
    [776] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 8, 'circIn')
        tweenShader('barrelBlur', {angle = -360}, daStep * 16, 'circInOut')
        tweenShader('greyScale', {strength = 0}, daStep * 8, 'circIn')
    end,
    [1032] = function() 
        tweenShader('barrelBlur', {zoom = 2}, daStep * 4, 'circOut')
    end,
    [1036] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circIn')
    end,
    [1040] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.4)
        tweenShader('barrelBlur', {zoom = 1.5}, daStep * 8, 'circOut')
    end,
    [1068] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circIn')
    end,
    [1104] = function() 
        tweenShader('barrelBlur', {zoom = 1.5, y = -3}, daStep * 4, 'circOut')
    end,
    [1132] = function() 
        tweenShader('barrelBlur', {zoom = 1, y = 0}, daStep * 4, 'circIn')
    end,
    [1424] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.4)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 8, 'circOut')
        tweenShader('greyScale', {strength = 0.9}, daStep * 8, 'circOut')
    end
}
function onStepHit()
    local section = math.floor(curStep / 16) 

    if section == 49 then
        repeatStep = -768
    end
    if section == 73 then
        repeatStep = -1024
    end
    if curStep == 914 or curStep == 1424 then
        repeatStep = 0
    end

    if events[curStep + repeatStep] then
        events[curStep + repeatStep]()
    end

    for i = 1, #bloomEvents do
        if curStep == bloomEvents[i] then
            bloomBurst()
            table.remove(bloomEvents, i)
        end
    end
    for i = 1, #mirrorEvents do
        if curStep == mirrorEvents[i][1] then
            doMirrorSlider(mirrorEvents[i][2], mirrorEvents[i][3])
        end
    end

    if (section > 4 and section < 25) or (section > 40 and section < 49) or (section > 52 and curStep < 1426) then
        for i = 1, #beats[1] do
            if (curStep - 16) % 64 == beats[1][i] then
                doBeatZoom(0.005, -0.2, -4)
            end
        end
    end
    if (section > 24 and curStep < 642) then
        if curStep % 4 == 0 then
            doBeatZoom(0.005, -0.2, -4, ((curStep >= 528 and curStep < 640) and true or false))
        end
    end
end

function doMirrorSlider(dir, isRL) 
    local daDir = (isRL and 'x' or 'y')
    tweenShaderCancel('barrelOffset', {daDir})
    set('barrelOffset.'..daDir, (dir and -0.2 or 0.2))
    if isRL then tweenShader('barrelOffset', {x = 0}, daStep * 4, 'circOut')
    else tweenShader('barrelOffset', {y = 0}, daStep * 4, 'circOut')
    end
end
function doBeatZoom(c, z, b, switch) 
    c = c or 0.005
    z = z or -0.1
    b = b or 2
    switch = switch or false
    tweenShaderCancel('barrelOffset', {'zoom'})
    tweenShaderCancel('blur', {'strengthY'})

    set('ca2.strength', get('ca2.strength') + c)
    set('barrelOffset.zoom', z)
    set('blur.strengthY', b)
    tweenShader('barrelOffset', {zoom = 0}, daStep * 8, 'circOut')
    tweenShader('blur', {strengthY = 0}, daStep * 8, 'circOut')

    if switch then
        tweenShaderCancel('barrelOffset', {'angle'})
        doSwitch = not doSwitch
        set('barrelOffset.angle', (doSwitch and -10 or 10))
        tweenShader('barrelOffset', {angle = 0}, daStep * 8, 'circOut')
    end
end

function bloomBurst() 
    tweenShaderCancel('bloom', {'effect', 'strength'})
    tweenShaderCancel('ca', {'strength'})
    tweenShaderCancel('blur', {'strength'})

    set('bloom.effect', 0.25)
    set('bloom.strength', 3)
    set('ca.strength', 0.0075)
    set('blur.strength', 4)

    tweenShader('bloom', {effect = 0, strength = 0}, daStep * 8, 'circOut')
    tweenShader('ca', {strength = 0}, daStep * 8, 'circOut')
    tweenShader('blur', {strength = 0}, daStep * 8, 'circOut')
end
function initShaders() 
    runHaxeCode([[ 
        setVar('_camGame', {shaders: []});
        setVar('_camHUD', {shaders: []});
        setVar('_camOther', {shaders: []});
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
        setVar('barrelOffset', {x: 0, y: 0, zoom: 0, angle: 0, offsetAngle: 0, barrel: 0});

        game.initLuaShader('GreyscaleEffect');
        game.initLuaShader('BloomEffect');
        game.initLuaShader('ChromAbEffect');
        game.initLuaShader('MosaicEffect');
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
    
        getVar('barrelBlur').shader = game.createRuntimeShader('MirrorRepeatEffect');
        getVar('barrelBlur').shader.setFloat('zoom', getVar('barrelBlur').zoom);
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
        if (getVar('pixel').shader != null)  
            getVar('pixel').shader.setFloat('strength', getVar('pixel').strength);
        if (getVar('barrelBlur').shader != null) { 
            getVar('barrelBlur').shader.setFloat('zoom', getVar('barrelBlur').zoom + getVar('barrelOffset').zoom);
            getVar('barrelBlur').shader.setFloat('angle', getVar('barrelBlur').angle + getVar('barrelOffset').angle);
            getVar('barrelBlur').shader.setFloat('x', getVar('barrelBlur').x + getVar('barrelOffset').x);
            getVar('barrelBlur').shader.setFloat('y', getVar('barrelBlur').y + getVar('barrelOffset').y);
        }
        /*if (getVar('barrelBlurHUD').shader != null) { 
            getVar('barrelBlurHUD').shader.setFloat('zoom', getVar('barrelBlur').zoom + getVar('barrelOffset').zoom);
            getVar('barrelBlurHUD').shader.setFloat('angle', getVar('barrelBlur').angle + getVar('barrelOffset').angle);
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