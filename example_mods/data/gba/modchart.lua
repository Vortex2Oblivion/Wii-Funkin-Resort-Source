local daStep = 0
local debugMode = true
local isDead = false
local doSwitch = false
local canSwitch = false
local beats = { 
    {0, 6, 20, 26, 32, 38, 52, 58,  64, 70, 84, 90, 102, 116, 122},
    {0, 8, 16, 22, 28},
    {0, 6, 12}
}
local doGlitchEffect = false
local blinked = false


function onCreatePost() 
    if debugMode then
        luaDebugMode = true 
    end

    addHaxeLibrary('FlxMath', 'flixel.math')

    initShaders()

    set('bloom.contrast', -1)
    set('greyScale.strength', 1)
    set('blur.strength', 4)
    set('blur.strengthY', -4)
    set('barrelBlur.zoom', 4)
    set('barrelBlur.angle', -60)

    daStep = stepCrochet / 1000 / playbackRate
end

function onSongStart()
    tweenShader('bloom', {contrast = 1}, daStep * 16, 'circIn')
    tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 32, 'circIn')
    tweenShader('greyScale', {strength = 0}, daStep * 32, 'circIn')
    tweenShader('blur', {strength = 0, strengthY = 0}, daStep * 32, 'circIn')
end

function opponentNoteHit(id, nD, nT, iS) 
    if getProperty('health') > 0.1 then
       setProperty('health',  getProperty('health')- 0.02);
    end
    if doGlitchEffect then
        set('glitch.glitchMultiply', (getRandomFloat(0.5, 1.5)))
    end
end

function onUpdatePost(elapsed)
    if startedCountdown and not getProperty('inCutscene') and not isDead then
        updateShaders(elapsed)
    end
end

local lastCurStep = 0
local repeatStep = 0
local glitchEvents = {204, 208, 304, 320, 714, 716, 1024, 1056, 1072, 1296, 1312, 1088, 1484, 1488, 1624, 1628, 1840, 1856, 1994, 1996}
local bloomEvents = {32, 288, 544, 800, 1056, 1312, 1568, 1824, 2080}
local events = { 
    [176] = function() 
        set('barrelBlur.angle', 30)
        tweenShader('barrelBlur', {zoom = 1.5, angle = 0}, daStep * 4, 'circOut')
    end,
    [180] = function() 
        tweenShaderCancel('barrelBlur', {'angle'})
        set('barrelBlur.angle', -30)
        tweenShader('barrelBlur', {zoom = 2, angle = 0}, daStep * 4, 'circOut')
    end,
    [184] = function() 
        tweenShaderCancel('barrelBlur', {'angle'})
        set('barrelBlur.angle', 30)
        tweenShader('barrelBlur', {zoom = 2.5, angle = 0}, daStep * 4, 'circOut')
    end,
    [188] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circIn')
    end,
    [280] = function() 
        tweenShader('barrelBlur', {zoom = 2}, daStep * 4, 'circOut')
    end,
    [284] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circIn')
    end,
    [288] = function() 
        set('barrelBlur.zoom', 0.3)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 8, 'circOut')
    end,
    [304] = function() 
        tweenShader('barrelBlur', {zoom = 1.25}, daStep * 4, 'circOut')
    end,
    [320] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circInOut')
    end,
    [536] = function() 
        tweenShader('barrelBlur', {zoom = 2, angle = -30}, daStep * 4, 'circOut')
    end,
    [540] = function() 
        tweenShader('barrelBlur', {zoom = 1, angle = 30, y = 6}, daStep * 4, 'circIn')
    end,
    [544] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'y', 'angle'})
        set('barrelBlur.zoom', 0.3)
        set('barrelBlur.y', 0)
        tweenShader('barrelBlur', {zoom = 1, angle = 0, y = 0}, daStep * 8, 'circOut')
    end,
    [768] = function() 
        tweenShader('barrelBlur', {zoom = 2}, daStep * 16, 'circInOut')
    end,
    [784] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 16, 'circIn')
    end,
    [800] = function()
        tweenShader('scanline', {strength = 1}, daStep * 8, 'circOut')
    end,
    [992] = function()
        tweenShader('barrelBlur', {zoom = 1.25}, daStep * 4, 'circOut')
    end,
    [1000] = function()
        tweenShader('barrelBlur', {zoom = 1.5}, daStep * 4, 'circOut')
    end,
    [1008] = function()
        tweenShader('barrelBlur', {zoom = 1.75}, daStep * 4, 'circOut')
    end,
    [1016] = function()
        tweenShader('barrelBlur', {zoom = 2}, daStep * 4, 'circOut')
    end,
    [1020] = function()
        tweenShader('barrelBlur', {zoom = 1.25}, daStep * 4, 'circIn')
    end,
    [1040] = function()
        tweenShader('barrelBlur', {zoom = 1.5}, daStep * 4, 'circOut')
        tweenShader('pixel', {strength = 8}, daStep * 4, 'circOut')
    end,
    [1052] = function()
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circIn')
    end,
    [1056] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('pixel.strength', 0)
        set('barrelBlur.zoom', 0.3)
        set('barrelBlur.angle', 30)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {angle = 0}, daStep * 8, 'circOut')
        tweenShader('scanline', {strength = 0}, daStep * 8, 'circOut')
    end,
    [1072] = function() 
        tweenShader('barrelBlur', {zoom = 1.25}, daStep * 4, 'circOut')
    end,
    [1088] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circInOut')
    end,
    [1296] = function() 
        tweenShader('barrelBlur', {zoom = 2, angle = 30}, daStep * 8, 'circOut')
        tweenShader('pixel', {strength = 8}, daStep * 4, 'circOut')
    end,
    [1304] = function() 
        tweenShader('barrelBlur', {zoom = 1, angle = -30}, daStep * 8, 'circIn')
    end,
    [1312] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('pixel.strength', 0)
        set('barrelBlur.zoom', 0.3)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {angle = 0}, daStep * 8, 'circOut')
    end,
    [1504] = function() 
        tweenShader('barrelBlur', {zoom = 2}, daStep * 48, 'sineIn')
        tweenShader('pixel', {strength = 40}, daStep * 64, 'sineIn')
    end,
    [1552] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 16, 'circIn')
    end,
    [1568] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.3)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 8, 'circOut')
        tweenShader('pixel', {strength = 0}, daStep * 2, 'circOut')
        tweenShader('scanline', {strength = 1}, daStep * 8, 'circOut')
    end,
    [1808] = function() 
        tweenShader('barrelBlur', {zoom = 2, angle = -30}, daStep * 8, 'circOut')
    end,
    [1816] = function() 
        tweenShader('barrelBlur', {zoom = 1, angle = 30}, daStep * 8, 'circIn')
    end,
    [1824] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.3)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 8, 'circOut')
        tweenShader('scanline', {strength = 0}, daStep * 8, 'circOut')
    end,
    [1840] = function() 
        tweenShader('barrelBlur', {zoom = 1.25}, daStep * 4, 'circOut')
    end,
    [1856] = function() 
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circInOut')
    end,
    [2064] = function() 
        tweenShader('barrelBlur', {zoom = 2}, daStep * 8, 'circOut')
    end,
    [2072] = function()
        tweenShader('barrelBlur', {zoom = 1, angle = -30, y = 4}, daStep * 8, 'circIn')
    end,
    [2080] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.3)
        set('barrelBlur.y', 0)
        tweenShader('barrelBlur', {zoom = 1, angle = 0, y = 0}, daStep * 8, 'circOut')
    end
}
function onStepHit()
    local section = math.floor(curStep / 16) 

    for i = 1, #glitchEvents do
        if curStep == glitchEvents[i] then
            doGlitchEffect = not doGlitchEffect
        end
    end
    for i = 1, #bloomEvents do
        if curStep == bloomEvents[i] then
            bloomBurst()
        end
    end

    if (section >= 2 and section < 11) or (section >= 12 and curStep < 278) or (section >= 18 and section < 50) or (section >= 66 and section < 98) then
        for i = 1, #beats[1] do
            if (curStep - 32) % 128 == beats[1][i] then
                doBeatZoom(0.0075, -0.2, 4)
            end
        end
    end
    if (section >= 50 and section < 65) then
        for i = 1, #beats[2] do
            if (curStep - 32) % 32 == beats[2][i] then
                doBeatZoom(0.0075, -0.2, 5)
            end
        end
    end
    if (section >= 98 and section < 114) then
        for i = 1, #beats[3] do
            if (curStep - 32) % 16 == beats[3][i] then
                doBeatZoom(0.0075, -0.1, 6)
            end
        end
    end
    if (section >= 114 and curStep < 2056) then
        for i = 1, #beats[1] do
            if (curStep - 32) % 32 == beats[1][i] then
                doBeatZoom(0.01, -0.2, 6)
            end
        end
    end

    if (curStep >= 19 and curStep < 32) or (curStep >= 1040 and curStep < 1056) or (curStep >= 1296 and curStep < 1312) then
        doBlink()
    end
    if curStep == 32 or curStep == 1056 or curStep == 1312 then
        set('bloom.contrast', 1)
    end

    if curStep == 808 or curStep == 840 or curStep == 852 or curStep == 976 then
        doMirrorAngle(true)
    end
    if curStep == 824 or curStep == 846 or curStep == 936 then
        doMirrorAngle(false)
    end
    if curStep == 1776 or curStep == 1784 then
        doMirrorSlider(true)
    end
    if curStep == 1780 or curStep == 1788 then
        doMirrorSlider(false)
    end

    if curStep == 1313 then
        repeatStep = -1280
    end
    if curStep == 1503 then
        repeatStep = 0
    end

    if events[curStep + repeatStep] then
        events[curStep + repeatStep]()
    end
end

function onGameOverStart()
    isDead = true
end

function doMirrorSlider(dir) 
    tweenShaderCancel('barrelOffset', {'x'})
    set('barrelOffset.x', (dir and -0.2 or 0.2))
    tweenShader('barrelOffset', {x = 0}, daStep * 4, 'circOut')
end
function doMirrorAngle(dir)
    tweenShaderCancel('barrelOffset', {'angle'})
    set('barrelOffset.angle', (dir and -30 or 30))
    tweenShader('barrelOffset', {angle = 0}, daStep * 8, 'circOut')
end
function doBlink() 
    blinked = not blinked
    set('bloom.contrast', (blinked and -1 or 1))
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


        setVar('glitch', {shader: null, uTime: 0.0, iMouseX: 500, NUM_SAMPLES: 3, glitchMultiply: 0.0});
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

        game.initLuaShader('glitchShader');
        game.initLuaShader('GreyscaleEffect');
        game.initLuaShader('BloomEffect');
        game.initLuaShader('ChromAbEffect');
        game.initLuaShader('MosaicEffect');
        game.initLuaShader('BlurEffect');
        game.initLuaShader('ScanlineEffect');

        getVar('glitch').shader = game.createRuntimeShader('glitchShader');
        getVar('glitch').shader.setFloat('uTime', getVar('glitch').uTime);
        getVar('glitch').shader.setFloat('iMouseX', getVar('glitch').iMouseX);
        getVar('glitch').shader.setInt('NUM_SAMPLES', getVar('glitch').NUM_SAMPLES);
        getVar('glitch').shader.setFloat('glitchMultiply', getVar('glitch').glitchMultiply);
        getVar('setCameraShader')('camGame', getVar('glitch').shader);
        getVar('setCameraShader')('camHUD', getVar('glitch').shader);

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

        if (getVar('glitch').shader != null) { 
            getVar('glitch').glitchMultiply = FlxMath.lerp(getVar('glitch').glitchMultiply, 0, (elapsed * game.playbackRate) * 5);
            getVar('glitch').shader.setFloat('uTime', Conductor.songPosition / 1000);
            getVar('glitch').shader.setFloat('iMouseX', getVar('glitch').iMouseX);
            getVar('glitch').shader.setInt('NUM_SAMPLES', getVar('glitch').NUM_SAMPLES);
            getVar('glitch').shader.setFloat('glitchMultiply', getVar('glitch').glitchMultiply);
        }
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