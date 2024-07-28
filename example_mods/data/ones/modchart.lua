local daStep = 0
local debugMode = true
local isDead = false
local doSwitch = false
local canSwitch = false
local beats = { 
    {0, 3, 6, 10, 14}, 
    {0, 6, 14, 18, 32, 34, 36, 46, 50, 56, 60}
}
local _beats = {0, 4, 12, 16, 30, 32, 34, 44, 48, 54, 58}

function opponentNoteHit()
    health = getProperty('health')
 if getProperty('health') > 0.1 then
    setProperty('health', health- 0.005);
 end
end


function onCreatePost() 
    if debugMode then
        luaDebugMode = true 
    end

    addHaxeLibrary('FlxMath', 'flixel.math')

    initShaders()
    initCounters()

    daStep = stepCrochet / 1000 / playbackRate
end

function onSongStart()
    tweenShader('greyScale', {strength = 1}, daStep * 2, 'circInOut', 'myballs')
    tweenShader('ca', {strength = 0.0075}, daStep * 2, 'circInOut')
end

function onUpdatePost(elapsed)
    if startedCountdown and not getProperty('inCutscene') and not isDead then
        updateShaders(elapsed)
    end
end

local repeatStep = 0
local bloomEvents = {16, 80, 144, 214, 336, 470, 592, 720, 848, 912}
local events = { 
    [8] = function()
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.1}, daStep * 4, 'circOut')
    end,
    [12] = function()
        tweenShader('greyScale', {strength = 0}, daStep * 4, 'circIn')
        tweenShader('ca', {strength = 0}, daStep * 4, 'circIn')
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
        tweenShader('barrelBlur', {y = 2}, daStep * 8, 'circInOut')
    end,
    [76] = function()
        tweenShader('barrelBlur', {zoom = 1.5, barrel = 0.2}, daStep * 2, 'circOut')
    end,
    [78] = function()
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 2, 'circIn')
    end,
    [80] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.1)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')
    end,
    [200] = function()
        doCounter()
        tweenShader('blur', {strength = 2}, daStep * 2, 'circOut')
    end,
    [202] = function()
        tweenShader('blur', {strength = 3}, daStep * 2, 'circOut')
    end,
    [204] = function()
        tweenShader('blur', {strength = 4}, daStep * 2, 'circOut')
    end,
    [206] = function()
        tweenShader('blur', {strength = 6}, daStep * 2, 'circIn')
    end,
    [208] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.1}, daStep * 4, 'circOut')
        tweenShader('greyScale', {strength = 1}, daStep * 4, 'circOut')
        tweenShader('blur', {strength = 2}, daStep * 4, 'circOut')
    end,
    [212] = function()
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 2, 'circIn')
        tweenShader('greyScale', {strength = 0}, daStep * 2, 'circIn')
    end,
    [214] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.angle', 30)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'circOut')
    end,
    [332] = function()
        tweenShader('barrelBlur', {zoom = 1.5, barrel = 0.2}, daStep * 2, 'circOut')
    end,
    [334] = function()
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 2, 'circIn')
    end,
    [336] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.3)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')
    end,
    [368] = function()
        set('greyScale.strength', 1)
        set('ca.strength', 0.01)
        tweenShader('barrelBlur', {zoom = 1.15, barrel = 0.2}, daStep * 4, 'circOut')
        tweenShader('greyScale', {strength = 0}, daStep * 4, 'circInOut')
        tweenShader('ca', {strength = 0}, daStep * 4, 'circInOut')
    end,
    [374] = function()
        set('greyScale.strength', 1)
        set('ca.strength', 0.01)
        tweenShader('barrelBlur', {zoom = 1.3}, daStep * 4, 'circOut')
        tweenShader('greyScale', {strength = 0}, daStep * 4, 'circInOut')
        tweenShader('ca', {strength = 0}, daStep * 4, 'circInOut')
    end,
    [384] = function()
        set('greyScale.strength', 1)
        set('ca.strength', 0.01)
        tweenShader('barrelBlur', {zoom = 1.45}, daStep * 4, 'circOut')
        tweenShader('greyScale', {strength = 0}, daStep * 4, 'circInOut')
        tweenShader('ca', {strength = 0}, daStep * 4, 'circInOut')
    end,
    [390] = function()
        set('greyScale.strength', 1)
        set('ca.strength', 0.01)
        tweenShader('barrelBlur', {zoom = 1.6}, daStep * 4, 'circOut')
        tweenShader('greyScale', {strength = 0}, daStep * 4, 'circInOut')
        tweenShader('ca', {strength = 0}, daStep * 4, 'circInOut')
    end,
    [396] = function()
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [588] = function()
        tweenShader('barrelBlur', {zoom = 1.5}, daStep * 2, 'circOut')
    end,
    [590] = function()
        tweenShader('barrelBlur', {zoom = 1}, daStep * 2, 'circIn')
    end,
    [592] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.1)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')
        tweenShader('scanline', {strength = 1}, daStep * 4, 'circOut')
    end,
    [716] = function()
        tweenShader('barrelBlur', {zoom = 2}, daStep * 2, 'circOut')
    end,
    [718] = function()
        tweenShader('barrelBlur', {zoom = 1.5}, daStep * 2, 'circIn')
        tweenShader('scanline', {strength = 0}, daStep * 2, 'circIn')
    end,
    [720] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.3)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')
    end,
    [840] = function()
        doCounter()
        tweenShader('blur', {strength = 2}, daStep * 2, 'circOut')
    end,
    [842] = function()
        tweenShader('blur', {strength = 3}, daStep * 2, 'circOut')
    end,
    [844] = function()
        tweenShader('barrelBlur', {zoom = 2, angle = -15, barrel = 0.2}, daStep * 2, 'circOut')
        tweenShader('blur', {strength = 4}, daStep * 2, 'circOut')
    end,
    [846] = function()
        tweenShader('barrelBlur', {zoom = 1, angle = 0, barrel = 0}, daStep * 2, 'circIn')
        tweenShader('blur', {strength = 0}, daStep * 2, 'circIn')
    end,
    [848] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        set('barrelBlur.zoom', 0.3)
        tweenShader('barrelBlur', {zoom = 1, angle = 0, barrel = 0}, daStep * 4, 'circOut')
    end,
    [904] = function() 
        tweenShader('barrelBlur', {zoom = 1.5, barrel = 0.2}, daStep * 4, 'circOut')
    end,
    [908] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
        tweenShader('barrelBlur', {y = 0}, daStep * 8, 'circInOut')
    end,
    [920] = function() 
        tweenShader('barrelBlur', {zoom = 3}, daStep * 16, 'circInOut')
        tweenShader('bloom', {contrast = -1}, daStep * 16, 'circInOut')
    end
}
function onStepHit()
    local section = math.floor(curStep / 16) 

    for i = 1, #bloomEvents do
        if curStep == bloomEvents[i] then
            bloomBurst()
        end
    end

    if curStep == 16 or curStep == 44 or curStep == 48 or curStep == 848 or curStep == 912 or curStep == 915 or curStep == 918  then
        doBeatZoom(nil, -0.2)
    end
    if section >= 5 and curStep < 200 or curStep >= 214 and section < 28 or curStep >= 470 and section < 37 or section >= 45 and curStep < 840 then
        for i = 1, #beats[1] do
            if curStep % 16 == beats[1][i] then
                doBeatZoom(0.0075, -0.2)
            end
        end
    end
    if curStep >= 200 and curStep < 208 or curStep >= 840 and curStep < 848 then
        if curStep % 2 == 0 then
            doBeatZoom(0.0075, -0.2, 3)
        end
    end
    --if curStep >= 590 and curStep < 648 or section >= 41 and section < 45 then
        --for i = 1, #_beats do
            if curStep == 590 or curStep == 596 or curStep == 604 or curStep == 608 or curStep == 622 or curStep == 624 or curStep == 626 or curStep == 636 or curStep == 640 or 
            curStep == 654 or curStep == 660 or curStep == 668 or curStep == 672 or curStep == 686 or curStep == 688 or curStep == 690 or curStep == 700 or curStep == 704 or curStep == 710 or curStep == 714 then
                runHaxeCode([[ 
                    FlxTween.cancelTweensOf(getVar('barrelOffset'), ['zoom', 'barrel']);
                    getVar('barrelOffset').zoom = 0;
                    getVar('barrelOffset').barrel = 0;
                    FlxTween.tween(getVar('barrelOffset'), {zoom: -0.2, barrel: -1}, ]]..(daStep * 2)..[[, {
                        ease: FlxEase.circIn,
                        onComplete: function(twn:FlxTween) { 
                            FlxTween.cancelTweensOf(getVar('barrelOffset'), ['zoom', 'barrel']);
                            FlxTween.cancelTweensOf(getVar('blur'), ['strengthY']);
            
                            getVar('ca2').strength += 0.0075;
                            getVar('blur').strengthY = 4;
                            FlxTween.tween(getVar('barrelOffset'), {zoom: 0, barrel: 0}, ]]..(daStep * 4)..[[, {ease: FlxEase.circOut});
                            FlxTween.tween(getVar('blur'), {strengthY: 0}, ]]..(daStep * 4)..[[, {ease: FlxEase.circOut});
                        }
                    });
                ]])
            end
        --end
    --end

    if section == 25 then
        repeatStep = -64
    end
    if section == 29 then
        repeatStep = -256
    end
    if section == 30 then
        repeatStep = 0
    end

    if events[curStep + repeatStep] then
        events[curStep + repeatStep]()
    end
end

function onGameOverStart()
    isDead = true
end

function initCounters() 
    makeLuaSprite('three', 'texts/Three')
    scaleObject('three', 0.75, 0.75)
    setScrollFactor('three')
    screenCenter('three')
    set('three.x', get('three.x') - 1000)
    setObjectCamera('three', 'hud')
    setObjectOrder('three', getObjectOrder('notes'))

    makeLuaSprite('two', 'texts/Two')
    scaleObject('two', 0.75, 0.75)
    setScrollFactor('two')
    screenCenter('two')
    set('two.x', get('two.x') + 900)
    setObjectCamera('two', 'hud')
    setObjectOrder('two', getObjectOrder('notes'))

    makeLuaSprite('one', 'texts/One')
    scaleObject('one', 0.75, 0.75)
    setScrollFactor('one')
    screenCenter('one')
    set('one.x', get('one.x') - 900)
    setObjectCamera('one', 'hud')
    setObjectOrder('one', getObjectOrder('notes'))

    makeLuaSprite('go', 'texts/Go')
    scaleObject('go', 0.75, 0.75)
    setScrollFactor('go')
    screenCenter('go')
    set('go.y', get('go.y') + 475)
    setObjectCamera('go', 'hud')
    setObjectOrder('go', getObjectOrder('notes'))
end
function doCounter() 
    runHaxeCode([[ 
        var three = game.getLuaObject('three', false);
        var two = game.getLuaObject('two', false);
        var one = game.getLuaObject('one', false);
        var go = game.getLuaObject('go', false);
        var daStep = ]]..daStep..[[;

        FlxTween.tween(three, {x: three.x + 1000}, daStep * 2, {
            ease: FlxEase.circOut,
            onComplete: function(twn:FlxTween) { 
                FlxTween.tween(three, {x: three.x - 1000}, daStep * 1, {ease: FlxEase.circIn});
            }
        });

        FlxTween.tween(two, {x: two.x - 900}, daStep * 2, {
            ease: FlxEase.circOut,
            startDelay: daStep * 2,
            onComplete: function(twn:FlxTween) { 
                FlxTween.tween(two, {x: two.x + 900}, daStep * 1, {ease: FlxEase.circIn});
            }
        });

        FlxTween.tween(one, {x: one.x + 900}, daStep * 2, {
            ease: FlxEase.circOut,
            startDelay: daStep * 4,
            onComplete: function(twn:FlxTween) { 
                FlxTween.tween(one, {x: one.x - 900}, daStep * 1, {ease: FlxEase.circIn});
            }
        });

        FlxTween.tween(go, {y: go.y - 475}, daStep * 2, {
            ease: FlxEase.circOut,
            startDelay: daStep * 6,
            onComplete: function(twn:FlxTween) { 
                FlxTween.tween(go, {y: go.y + 475}, daStep * 1, {ease: FlxEase.circIn});
            }
        });
    ]])
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
    tweenShader('barrelOffset', {zoom = 0}, daStep * 4, 'circOut')
    tweenShader('blur', {strengthY = 0}, daStep * 4, 'circOut')

    if switch then
        tweenShaderCancel('barrelOffset', {'angle'})
        doSwitch = not doSwitch
        set('barrelOffset.angle', (doSwitch and -10 or 10))
        tweenShader('barrelOffset', {angle = 0}, daStep * 4, 'circOut')
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

    tweenShader('bloom', {effect = 0, strength = 0}, daStep * 4, 'circOut')
    tweenShader('ca', {strength = 0}, daStep * 4, 'circOut')
    tweenShader('blur', {strength = 0}, daStep * 4, 'circOut')
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
        setVar('barrelBlur', {shader: null, barrel: 0, zoom: 1, doChroma: false, iTime: 0, angle: 0, x: 0, y: 0});
        setVar('barrelBlurHUD', {shader: null, barrel: 0, zoom: 1, doChroma: false, iTime: 0, angle: 0, x: 0, y: 0});
        setVar('blur', {shader: null, strength: 0, strengthY: 0});
        setVar('scanline', {shader: null, strength: 0, pixelsBetweenEachLine: 10, smoothVar: false});
        setVar('barrelOffset', {x: 0, y: 0, zoom: 0, angle: 0, offsetAngle: 0, barrel: 0});

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
        if (getVar('barrelBlur').shader != null) { 
            getVar('barrelBlur').shader.setFloat('barrel', getVar('barrelBlur').barrel + getVar('barrelOffset').barrel);
            getVar('barrelBlur').shader.setFloat('zoom', getVar('barrelBlur').zoom + getVar('barrelOffset').zoom);
            getVar('barrelBlur').shader.setBool('doChroma', getVar('barrelBlur').doChroma);
            getVar('barrelBlur').shader.setFloat('iTime', Conductor.songPosition / 1000);
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