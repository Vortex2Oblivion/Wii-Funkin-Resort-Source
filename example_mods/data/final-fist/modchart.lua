--[[ 
    dont mess with this, unless you know what you are doing. -Tih
--]]

local daStep = 0
local perlinX = 0
local perlinY = 0
local perlinZ = 0
local perlinXRange = 0.04
local perlinYRange = 0.04
local perlinZRange = 5
local debugMode = true
local isDead = false
local doGlitchEffect = false
local beats = {
    {0, 20, 32, 44, 50, 52, 60},
    {0, 40}
}
local noteYTime = { 
    {{2, 0},{0, 8},{1, 12},{3, 16},{0, 20},{2, 24},{1, 32},{3, 40},{2, 44},{0, 48},{3, 52},{1, 56}},
    {{2, 0},{0, 8},{1, 12},{3, 16},{0, 20},{2, 24},{1, 32},{3, 40},{2, 44},{0, 48},{3, 52},{1, 56},{3, 62}},
    {{0, 0},{3, 2},{0, 4},{1, 24},{3, 26},{0, 28},{2, 30},{1, 32},{3, 48}}
}
local defaultPlayerStrumY = 0

function onCreatePost() 
    if debugMode then
        luaDebugMode = true 
    end

    addHaxeLibrary('FlxMath', 'flixel.math')

    initShaders()

    set('vignette.strength', 25)
    set('vignette.size', 1)
    set('greyScale.strength', 1)
    set('bloom.contrast', 0)
    set('barrelBlur.zoom', 3)
    set('barrelBlur.barrel', 0.025)
    set('blur.strength', -5)
    set('blur.strengthY', 5)
    set('scanline.strength', 1)

    setVar('perlinMult', {x = 1, y = 1, z = 1})

    daStep = stepCrochet / 1000 / playbackRate
end

function onCountdownStarted()
    defaultPlayerStrumY = defaultPlayerStrumY0
end

function onSongStart()
    curStep = 0
    onStepHit()
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

function opponentNoteHit(id, nD, nT, iS) 
    if doGlitchEffect then
        set('glitch.glitchMultiply', (getRandomFloat(0.5, 1.5)))
    end
end

local glitchEvents = {400, 416, 856, 864, 1168, 1184, 1440, 1472, 1520, 1536}
local bloomEvents = {0, 64, 128, 256, 384, 512, 640, 672, 704, 736, 768, 832, 896, 1024, 1152, 1280, 1408, 1536, 1664, 1696, 1728, 1760, 1792, 1824, 1856, 1888, 1920, 1952, 1984, 2016, 2048}
local events = {
    [0] = function() 
        set('bloom.contrast', 0.5)
        tweenShader('bloom', {contrast = 0}, daStep * 8, 'circOut')
    end,
    [16] = function() 
        set('barrelBlur.zoom', 2)
        set('barrelBlur.barrel', 0.25)
    end,
    [64] = function()
        set('bloom.contrast', 0.5)
        tweenShader('bloom', {contrast = 0}, daStep * 8, 'circOut')
    end,
    [72] = function() 

    end,
    [112] = function() 
        tweenShader('bloom', {contrast = 1}, daStep * 16, 'circIn')
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 16, 'circIn')
    end,
    [128] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'barrel'})

        set('vignette.strength', 25)
        set('vignette.size', 0.25)
        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.barrel', -10)

        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 8, 'circOut')
    end,
    [224] = function()
        tweenShader('barrelBlur', {zoom = 3, angle = 15, barrel = 0.025}, daStep * 16, 'cubeInOut')
    end,
    [240] = function() 
        tweenShader('barrelBlur', {y = 4, zoom = 1, angle = 0, barrel = 0}, daStep * 16, 'circIn')
        set('barrelOffset.zoom', -0.1)
        set('ca.strength', -0.02)
    end,
    [241] = function()
        set('barrelOffset.zoom', -0.2)
        set('bloom.contrast', 0)
    end, 
    [242] = function()
        set('greyScale.strength', 0)
        set('barrelOffset.zoom', -0.3)
        set('ca.strength', 0.04)
        set('bloom.contrast', 1)
    end, 
    [243] = function()
        set('barrelOffset.zoom', -0.4)
        set('bloom.contrast', 0)
    end, 
    [244] = function()
        set('greyScale.strength', 1)
        set('barrelOffset.zoom', -0.5)
        set('ca.strength', -0.06)
        set('bloom.contrast', 1)
    end, 
    [245] = function()
        set('barrelOffset.zoom', -0.6)
        set('bloom.contrast', 0)
    end, 
    [246] = function()
        set('greyScale.strength', 0)
        set('barrelOffset.zoom', -0.7)
        set('ca.strength', 0.08)
        set('bloom.contrast', 1)
    end, 
    [247] = function()
        set('barrelOffset.zoom', -0.8)
        set('bloom.contrast', 0)
    end,
    [248] = function()
        set('greyScale.strength', 1)
        set('barrelOffset.zoom', -1)
        set('ca.strength', -0.1)
        set('bloom.contrast', 1)
    end, 
    [249] = function()
        set('barrelOffset.zoom', -1.1)
        set('bloom.contrast', 0)
    end, 
    [250] = function()
        set('greyScale.strength', 0)
        set('barrelOffset.zoom', -1.2)
        set('ca.strength', 0.08)
        set('bloom.contrast', 1)
    end, 
    [251] = function() 
        set('bloom.contrast', 0)
    end,
    [252] = function()
        set('greyScale.strength', 1)
        set('barrelOffset.zoom', -1.3)
        set('bloom.contrast', 1)
        set('ca.strength', -0.06)
    end, 
    [253] = function() 
        set('bloom.contrast', 0)
    end,
    [254] = function()
        set('greyScale.strength', 0)
        set('barrelOffset.zoom', -1.4)
        set('ca.strength', 0.04)
        set('bloom.contrast', 1)
    end,
    [255] = function() 
        set('greyScale.strength', 1)
        set('ca.strength', 0)
        set('bloom.contrast', 0)
    end,
    [256] = function()
        tweenShaderCancel('barrelBlur', {'y', 'zoom', 'barrel', 'angle'})

        set('bloom.contrast', 1)
        set('barrelBlur.y', 0)
        set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', -15)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'circOut')
        tweenShader('greyScale', {strength = 0}, daStep * 4, 'circOut')
        tweenShader('blur', {strengthY = 0}, daStep * 4, 'circOut')
        tweenShader('scanline', {strength = 0}, daStep * 4, 'circOut')
    end,
    [376] = function()
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 4, 'circOut')
    end,
    [380] = function()
        tweenShaderCancel('barrelBlur', {'zoom', 'barrel'})
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [384] = function()
        tweenShaderCancel('barrelBlur', {'zoom', 'barrel'})
        
        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 8, 'circOut')
    end,
    [400] = function()
        tweenShader('blur', {strength = 2}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.5, barrel = 0.2}, daStep * 4, 'circOut')
        tweenShader('scanline', {strength = 1}, daStep * 4, 'circOut')
    end,
    [412] = function()
        tweenShader('blur', {strength = 0}, daStep * 4, 'circIn')
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
        tweenShader('scanline', {strength = 0}, daStep * 4, 'circIn')
    end,
    [416] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.25}, daStep * 4, 'circOut')
    end,
    [420] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.5}, daStep * 4, 'circOut')
    end,
    [424] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.75}, daStep * 4, 'circOut')
    end,
    [428] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 2}, daStep * 4, 'circOut')
    end,
    [432] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.75}, daStep * 4, 'circOut')
    end,
    [436] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.5}, daStep * 4, 'circOut')
    end,
    [440] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.25}, daStep * 4, 'circOut')
    end,
    [444] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')
    end,
    [448] = function()
        tweenShader('bloom', {contrast = 1}, daStep * 2, 'circOut')
    end,
    [504] = function()
        tweenShader('barrelBlur', {zoom = 2, angle = -15, barrel = 0.2}, daStep * 4, 'circOut')
    end,
    [508] = function()
        tweenShader('barrelBlur', {zoom = 1, angle = 0, barrel = 0}, daStep * 4, 'circIn')
    end,
    [512] = function()
        tweenShaderCancel('barrelBlur', {'zoom', 'angle'})
        
        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.angle', 15)
        tweenShader('barrelBlur', {zoom = 1.2, angle = -5, barrel = 0.2}, daStep * 4, 'circOut')
    end,
    [536] = function()
        tweenShader('barrelBlur', {zoom = 1.4, angle = 10}, daStep * 4, 'circOut')
    end,
    [540] = function()
        tweenShader('barrelBlur', {zoom = 1.2, angle = -5}, daStep * 4, 'circOut')
    end,
    [544] = function()
        tweenShader('barrelBlur', {zoom = 1.6, angle = 15}, daStep * 4, 'circOut')
    end,
    [560] = function()
        tweenShader('barrelBlur', {zoom = 1.2, angle = -5}, daStep * 4, 'circOut')
    end,
    [576] = function()
        tweenShader('barrelBlur', {zoom = 1.7, angle = 20}, daStep * 4, 'circOut')
    end,
    [588] = function()
        tweenShader('barrelBlur', {zoom = 1.4, angle = -25}, daStep * 4, 'circOut')
    end,
    [600] = function()
        tweenShader('barrelBlur', {zoom = 1.7, angle = 20}, daStep * 4, 'circOut')
    end,
    [620] = function()
        tweenShader('barrelBlur', {zoom = 1.4, angle = -25}, daStep * 4, 'circOut')
    end,
    [632] = function()
        tweenShader('barrelBlur', {zoom = 1.7, angle = 20}, daStep * 4, 'circOut')
    end,
    --[[[544] = function()
        tweenShader('barrelBlur', {zoom = 1.3}, daStep * 8, 'circOut')
    end,
    [576] = function()
        tweenShader('barrelBlur', {zoom = 1.6}, daStep * 8, 'circOut')
    end,
    [608] = function()
        tweenShader('barrelBlur', {zoom = 1.3}, daStep * 8, 'circOut')
    end,--]]
    [636] = function()
        tweenShader('barrelBlur', {x = 3, zoom = 1, angle = 0, barrel = 0}, daStep * 4, 'circIn')
    end,
    [668] = function()
        tweenShader('barrelBlur', {x = 0, y = 3, zoom = 1.75, barrel = 0.2}, daStep * 4, 'circIn')
    end,
    [672] = function() 
        set('barrelOffset.zoom', -0.25)
        tweenShader('barrelOffset', {zoom = 0}, daStep * 8, 'circOut')
    end,
    [700] = function()
        tweenShader('barrelBlur', {x = -3, y = 0, zoom = 1.5}, daStep * 4, 'circIn')
    end,
    [732] = function()
        tweenShader('barrelBlur', {x = 0, y = -3, zoom = 1.15, barrel = 0.3}, daStep * 4, 'circIn')
    end,
    [736] = function() 
        set('barrelOffset.zoom', -0.25)
        tweenShader('barrelOffset', {zoom = 0}, daStep * 8, 'circOut')
    end,
    [760] = function()
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 4, 'circOut')
    end,
    [764] = function()
        tweenShader('barrelBlur', {zoom = 1, y = 0, barrel = 0}, daStep * 4, 'circIn')
    end,
    [768] = function()
        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.angle', 30)
        set('barrelBlur.barrel', -20)
        tweenShader('barrelBlur', {zoom = 1, angle = 0, barrel = 0}, daStep * 8, 'circOut')
    end,
    [856] = function() 
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.3}, daStep * 4, 'circOut')
    end,
    [860] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [864] = function() 
        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.angle', -15)
        tweenShader('barrelBlur', {zoom = 1, angle = 0, barrel = 0}, daStep * 8, 'circOut')
    end,
    [888] = function() 
        tweenShader('barrelBlur', {zoom = 1.5, barrel = 0.2}, daStep * 4, 'circOut')
    end,
    [892] = function() 
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [896] = function() 
        tweenShaderCancel('barrelBlur', {'zoom'})

        set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', 15)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 8, 'circOut')
    end,
    [960] = function() 
        tweenShader('blur', {strength = 1}, daStep * 8, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.25, angle = -15, barrel = 0.2}, daStep * 8, 'circOut')
    end,
    [976] = function() 
        tweenShader('blur', {strength = 2}, daStep * 8, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.5, angle = 15}, daStep * 8, 'circOut')
    end,
    [992] = function() 
        tweenShader('blur', {strength = 3}, daStep * 8, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.75, angle = -15}, daStep * 8, 'circOut')
    end,
    [1008] = function() 
        tweenShader('blur', {strength = 4}, daStep * 8, 'circOut')
        tweenShader('barrelBlur', {zoom = 2, angle = 15}, daStep * 8, 'circOut')
    end,
    [1020] = function() 
        tweenShader('blur', {strength = 0}, daStep * 4, 'circIn')
        tweenShader('barrelBlur', {zoom = 1, angle = 0, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1024] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'angle'})

        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.angle', -30)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 8, 'circOut')
    end,
    [1144] = function()
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 4, 'circOut')
    end,
    [1148] = function()
        tweenShaderCancel('barrelBlur', {'zoom', 'barrel'})
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1152] = function()
        tweenShaderCancel('barrelBlur', {'zoom', 'barrel'})
        
        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 8, 'circOut')
    end,
    [1168] = function()
        tweenShader('blur', {strength = 2}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.5, barrel = 0.2}, daStep * 4, 'circOut')
        tweenShader('scanline', {strength = 1}, daStep * 4, 'circOut')
    end,
    [1180] = function()
        tweenShader('blur', {strength = 0}, daStep * 4, 'circIn')
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
        tweenShader('scanline', {strength = 0}, daStep * 4, 'circIn')
    end,
    [1184] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.25}, daStep * 4, 'circOut')
    end,
    [1188] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.5}, daStep * 4, 'circOut')
    end,
    [1192] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.75}, daStep * 4, 'circOut')
    end,
    [1196] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 2}, daStep * 4, 'circOut')
    end,
    [1200] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.75}, daStep * 4, 'circOut')
    end,
    [1204] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.5}, daStep * 4, 'circOut')
    end,
    [1208] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1.25}, daStep * 4, 'circOut')
    end,
    [1212] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        tweenShaderCancel('bloom', {'contrast'})

        set('bloom.contrast', 1)
        tweenShader('bloom', {contrast = 0}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')
    end,
    [1216] = function()
        tweenShader('bloom', {contrast = 1}, daStep * 2, 'circOut')
    end,
    [1272] = function()
        tweenShader('greyScale', {strength = 0.9}, daStep * 4, 'circOut')
        tweenShader('blur', {strength = 4}, daStep * 4, 'circOut')
        tweenShader('barrelBlur', {zoom = 2, angle = -15, barrel = 0.2}, daStep * 4, 'circOut')
    end,
    [1276] = function()
        tweenShader('greyScale', {strength = 0}, daStep * 4, 'circIn')
        tweenShader('blur', {strength = 2}, daStep * 4, 'circIn')
        tweenShader('barrelBlur', {zoom = 1, angle = 0, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1280] = function()
        tweenShaderCancel('barrelBlur', {'zoom'})
        
        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {x = 0.5, zoom = 1.25, barrel = 0.2}, daStep * 8, 'circOut')
        tweenShader('scanline', {strength = 1}, daStep * 8, 'circOut')
    end,
    [1392] = function()
        tweenShader('barrelBlur', {zoom = 2.25}, daStep * 8, 'circOut')
    end,
    [1400] = function()
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 8, 'circIn')
    end,
    [1408] = function()
        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.angle', 15)
        tweenShader('barrelBlur', {x = -0.5, zoom = 1.15, angle = 0, barrel = 0.2}, daStep * 8, 'circOut')
    end,
    [1440] = function()
        tweenShader('barrelBlur', {zoom = 1.5, barrel = 0.4}, daStep * 4, 'circOut')
    end,
    [1472] = function()
        tweenShader('barrelBlur', {zoom = 1.15, barrel = 0.2}, daStep * 4, 'circOut')
    end,
    [1504] = function()
        tweenShader('greyScale', {strength = 1}, daStep * 16, 'cubeInOut')
        tweenShader('blur', {strength = -4}, daStep * 16, 'cubeInOut')
        tweenShader('barrelBlur', {zoom = 2}, daStep * 16, 'cubeInOut')
        tweenShader('scanline', {strength = 1}, daStep * 16, 'cubeInOut')
    end,
    [1520] = function()
        tweenShader('greyScale', {strength = 0}, daStep * 16, 'circIn')
        tweenShader('blur', {strength = 0}, daStep * 16, 'circIn')
        tweenShader('barrelBlur', {zoom = 1}, daStep * 16, 'circIn')
        tweenShader('scanline', {strength = 0}, daStep * 16, 'circIn')
    end,
    [1536] = function()
        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.angle', -30)
        set('barrelBlur.barrel', -30)
        tweenShader('barrelBlur', {x = 0, zoom = 1.2, angle = 5, barrel = 0.2}, daStep * 4, 'circOut')
    end,
    [1560] = function()
        tweenShader('barrelBlur', {zoom = 1.4, angle = -10}, daStep * 4, 'circOut')
    end,
    [1564] = function()
        tweenShader('barrelBlur', {zoom = 1.2, angle = 5}, daStep * 4, 'circOut')
    end,
    [1568] = function()
        tweenShader('barrelBlur', {zoom = 1.6, angle = -15}, daStep * 4, 'circOut')
    end,
    [1584] = function()
        tweenShader('barrelBlur', {zoom = 1.2, angle = 5}, daStep * 4, 'circOut')
    end,
    [1600] = function()
        tweenShader('barrelBlur', {zoom = 1.7, angle = -20}, daStep * 4, 'circOut')
    end,
    [1612] = function()
        tweenShader('barrelBlur', {zoom = 1.4, angle = 25}, daStep * 4, 'circOut')
    end,
    [1624] = function()
        tweenShader('barrelBlur', {zoom = 1.7, angle = -20}, daStep * 4, 'circOut')
    end,
    [1644] = function()
        tweenShader('barrelBlur', {zoom = 1.4, angle = 25}, daStep * 4, 'circOut')
    end,
    [1656] = function()
        tweenShader('barrelBlur', {zoom = 1.7, angle = -20}, daStep * 4, 'circOut')
    end,
    [1660] = function()
        tweenShader('barrelBlur', {x = 3, zoom = 1, angle = 0, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1692] = function()
        tweenShader('barrelBlur', {x = 0, y = 3, zoom = 1.75, barrel = 0.2}, daStep * 4, 'circIn')
    end,
    [1696] = function() 
        set('barrelOffset.zoom', -0.25)
        tweenShader('barrelOffset', {zoom = 0}, daStep * 8, 'circOut')
    end,
    [1724] = function()
        tweenShader('barrelBlur', {x = -3, y = 0, zoom = 1.5}, daStep * 4, 'circIn')
    end,
    [1756] = function()
        tweenShader('barrelBlur', {x = 0, y = -3, zoom = 1.15, barrel = 0.3}, daStep * 4, 'circIn')
    end,
    [1760] = function() 
        set('barrelOffset.zoom', -0.25)
        tweenShader('barrelOffset', {zoom = 0}, daStep * 8, 'circOut')
    end,
    [1784] = function()
        tweenShader('barrelBlur', {zoom = 2, barrel = 0.2}, daStep * 4, 'circOut')
    end,
    [1788] = function()
        tweenShader('barrelBlur', {zoom = 1, x = -0.5, y = 0, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1792] = function()
        set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', 15)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'circOut')
    end,
    [1796] = function()
        tweenShader('barrelBlur', {x = 0.5}, daStep * 4, 'circIn')
    end,
    [1804] = function()
        tweenShader('barrelBlur', {x = 0, zoom = 1.5, barrel = 0.2}, daStep * 4, 'circIn')
    end,
    [1820] = function()
        tweenShader('barrelBlur', {x = 0.5, zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1824] = function()
        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')
    end,
    [1828] = function()
        tweenShader('barrelBlur', {x = -0.5}, daStep * 4, 'circIn')
    end,
    [1836] = function()
        tweenShader('barrelBlur', {x = 0, zoom = 2, barrel = 0.2}, daStep * 4, 'circIn')
    end,
    [1852] = function()
        tweenShader('barrelBlur', {x = -0.5, zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1856] = function()
        set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', -15)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'circOut')
    end,
    [1860] = function()
        tweenShader('barrelBlur', {x = 0.5}, daStep * 4, 'circIn')
    end,
    [1868] = function()
        tweenShader('barrelBlur', {x = 0, zoom = 1.5, barrel = 0.2}, daStep * 4, 'circIn')
    end,
    [1884] = function()
        tweenShader('barrelBlur', {x = 0.5, zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1888] = function()
        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')
    end,
    [1892] = function()
        tweenShader('barrelBlur', {x = -0.5}, daStep * 4, 'circIn')
    end,
    [1900] = function()
        tweenShader('barrelBlur', {x = 0, zoom = 2, barrel = 0.2}, daStep * 4, 'circIn')
    end,
    [1916] = function()
        tweenShader('barrelBlur', {x = -0.5, zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,

    [1792 + 128] = function()
        set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', 15)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'circOut')
    end,
    [1796 + 128] = function()
        tweenShader('barrelBlur', {x = 0.5}, daStep * 4, 'circIn')
    end,
    [1804 + 128] = function()
        tweenShader('barrelBlur', {x = 0, zoom = 1.5, barrel = 0.2}, daStep * 4, 'circIn')
    end,
    [1820 + 128] = function()
        tweenShader('barrelBlur', {x = 0.5, zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1824 + 128] = function()
        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')
    end,
    [1828 + 128] = function()
        tweenShader('barrelBlur', {x = -0.5}, daStep * 4, 'circIn')
    end,
    [1836 + 128] = function()
        tweenShader('barrelBlur', {x = 0, zoom = 2, barrel = 0.2}, daStep * 4, 'circIn')
    end,
    [1852 + 128] = function()
        tweenShader('barrelBlur', {x = -0.5, zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1856 + 128] = function()
        set('barrelBlur.zoom', 0.5)
        set('barrelBlur.angle', -15)
        tweenShader('barrelBlur', {zoom = 1, angle = 0}, daStep * 4, 'circOut')
    end,
    [1860 + 128] = function()
        tweenShader('barrelBlur', {x = 0.5}, daStep * 4, 'circIn')
    end,
    [1868 + 128] = function()
        tweenShader('barrelBlur', {x = 0, zoom = 1.5, barrel = 0.2}, daStep * 4, 'circIn')
    end,
    [1884 + 128] = function()
        tweenShader('barrelBlur', {x = 0.5, zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    [1888 + 128] = function()
        set('barrelBlur.zoom', 0.5)
        tweenShader('barrelBlur', {zoom = 1}, daStep * 4, 'circOut')
    end,
    [1892 + 128] = function()
        tweenShader('barrelBlur', {x = -0.5}, daStep * 4, 'circIn')
    end,
    [1900 + 128] = function()
        tweenShader('barrelBlur', {x = 0, zoom = 2, barrel = 0.2}, daStep * 4, 'circIn')
    end,
    [1916 + 128] = function()
        tweenShader('barrelBlur', {zoom = 1, barrel = 0}, daStep * 4, 'circIn')
    end,
    
    [2048] = function() 
        tweenShaderCancel('barrelBlur', {'zoom', 'barrel'})

        set('vignette.strength', 25)
        set('vignette.size', 1)
        set('barrelBlur.zoom', 0.1)
        set('barrelBlur.angle', 30)
        set('barrelBlur.barrel', -20)
        tweenShader('barrelBlur', {zoom = 1, angle = 0, barrel = 0}, daStep * 8, 'circOut')
        tweenShader('greyScale', {strength = 1}, daStep * 32, 'cubeInOut')
        tweenShader('scanline', {strength = 1}, daStep * 32, 'cubeInOut')
    end,
    [2288] = function() 
        tweenShaderCancel('blur', {'strengthY'})

        tweenShader('barrelBlur', {zoom = 6}, daStep * 64, 'cubeIn')
        tweenShader('blur', {strength = 8, strengthY = -8}, daStep * 64, 'cubeIn')
        tweenShader('bloom', {contrast = 0}, daStep * 64, 'cubeIn')
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

    if (section >= 16 and section < 32) or (section >= 48 and section < 64) or (section >= 88 and section < 92) then
        for i = 1, #beats[1] do
            if curStep % 64 == beats[1][i] then
                tweenShaderCancel('barrelOffset', {'zoom'})
                tweenShaderCancel('blur', {'strengthY'})

                set('ca2.strength', 0.005)
                set('barrelOffset.zoom', -0.1)
                set('blur.strengthY', 2)
                tweenShader('barrelOffset', {zoom = 0}, daStep * 8, 'circOut')
                tweenShader('blur', {strengthY = 0}, daStep * 8, 'circOut')
            end
        end
    end
    if (section >= 32 and section < 48) or (section >= 64 and section < 80) or (section >= 96 and section < 128) then
        for i = 1, #beats[2] do
            if curStep % 64 == beats[2][i] then
                tweenShaderCancel('barrelOffset', {'zoom'})
                tweenShaderCancel('blur', {'strengthY'})

                set('ca2.strength', 0.006)
                set('barrelOffset.zoom', -0.15)
                set('blur.strengthY', 3)
                tweenShader('barrelOffset', {zoom = 0}, daStep * 8, 'circOut')
                tweenShader('blur', {strengthY = 0}, daStep * 8, 'circOut')
            end
        end
    end
    if (section >= 80 and section < 88) then
        if curStep % 16 == 0 then
            tweenShaderCancel('barrelOffset', {'zoom'})
            tweenShaderCancel('blur', {'strengthY'})

            set('ca2.strength', 0.0075)
            set('barrelOffset.zoom', -0.2)
            set('blur.strengthY', 4)
            tweenShader('barrelOffset', {zoom = 0}, daStep * 8, 'circOut')
            tweenShader('blur', {strengthY = 0}, daStep * 8, 'circOut')
        end
    end

    if (section >= 0 and section < 15) or (section >= 16 and section < 32) or (section >= 48 and section < 80) then
        for i = 1, #noteYTime[1] do
            if curStep % 64 == noteYTime[1][i][2] then 
                runHaxeCode("for (strum in [game.playerStrums, game.opponentStrums]) { FlxTween.cancelTweensOf(strum.members["..(noteYTime[1][i][1]).."], ['y']); strum.members["..(noteYTime[1][i][1]).."].y -= 15; FlxTween.tween(strum.members["..(noteYTime[1][i][1]).."], {y: "..defaultPlayerStrumY.."}, "..(daStep * 6)..", {ease: FlxEase.linear}); }")
            end
        end
    end
    if (section >= 32 and section < 44) or (section >= 80 and section < 108) or (section >= 112 and section < 124) or (section >= 128 and section < 140) then
        for i = 1, #noteYTime[2] do
            if curStep % 64 == noteYTime[2][i][2] then 
                runHaxeCode("for (strum in [game.playerStrums, game.opponentStrums]) { FlxTween.cancelTweensOf(strum.members["..(noteYTime[2][i][1]).."], ['y']); strum.members["..(noteYTime[2][i][1]).."].y -= 15; FlxTween.tween(strum.members["..(noteYTime[2][i][1]).."], {y: "..defaultPlayerStrumY.."}, "..(daStep * 6)..", {ease: FlxEase.linear}); }")
            end
        end
    end
    if (section >= 44 and section < 48) or (section >= 108 and section < 112) or (section >= 124 and section < 128) or (section >= 140 and section < 144) then
        for i = 1, #noteYTime[3] do
            if curStep % 64 == noteYTime[3][i][2] then 
                runHaxeCode("for (strum in [game.playerStrums, game.opponentStrums]) { FlxTween.cancelTweensOf(strum.members["..(noteYTime[3][i][1]).."], ['y']); strum.members["..(noteYTime[3][i][1]).."].y -= 15; FlxTween.tween(strum.members["..(noteYTime[3][i][1]).."], {y: "..defaultPlayerStrumY.."}, "..(daStep * 6)..", {ease: FlxEase.linear}); }")
            end
        end
    end

    if events[curStep] then
        events[curStep]()
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

    tweenShader('bloom', {effect = 0, strength = 0}, daStep * 8, 'circOut')
    tweenShader('ca', {strength = 0}, daStep * 8, 'circOut')
    tweenShader('blur', {strength = 0}, daStep * 8, 'circOut')
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


        setVar('vignette', {shader: null, strength: 1, size: 0, red: 0, green: 0, blue: 0, lerpedStrength: 0, lerpedSize: 0, allowLerp: true});
        setVar('glitch', {shader: null, uTime: 0.0, iMouseX: 500, NUM_SAMPLES: 3, glitchMultiply: 0.0});
        setVar('greyScale', {shader: null, strength: 0});
        setVar('bloom', {shader: null, effect: 0, strength: 0, contrast: 1, brightness: 0});
        setVar('ca', {shader: null, strength: 0});
        setVar('ca2', {shader: null, strength: 0});
        setVar('barrelBlur', {shader: null, barrel: 0, zoom: 1, doChroma: false, iTime: 0, angle: 0, x: 0, y: 0});
        setVar('barrelBlurHUD', {shader: null, barrel: 0, zoom: 1, doChroma: false, iTime: 0, angle: 0, x: 0, y: 0});
        setVar('blur', {shader: null, strength: 0, strengthY: 0});
        setVar('scanline', {shader: null, strength: 0, pixelsBetweenEachLine: 10, smoothVar: false});
        setVar('barrelOffset', {x: 0, y: 0, zoom: 0, angle: 0, offsetAngle: 0});

        game.initLuaShader('VignetteEffect');
        game.initLuaShader('glitchShader');
        game.initLuaShader('GreyscaleEffect');
        game.initLuaShader('BloomEffect');
        game.initLuaShader('ChromAbEffect');
        game.initLuaShader('BarrelBlurEffect');
        game.initLuaShader('BlurEffect');
        game.initLuaShader('ScanlineEffect');

        getVar('vignette').shader = game.createRuntimeShader('VignetteEffect');
        getVar('vignette').shader.setFloat('strength', getVar('vignette').strength);
        getVar('vignette').shader.setFloat('size', getVar('vignette').size);
        getVar('vignette').shader.setFloat('red', getVar('vignette').red);
        getVar('vignette').shader.setFloat('green', getVar('vignette').green);
        getVar('vignette').shader.setFloat('blue', getVar('vignette').blue);
        getVar('setCameraShader')('camGame', getVar('vignette').shader);
        getVar('setCameraShader')('camHUD', getVar('vignette').shader);

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

        getVar('barrelOffset').x = getVar('_noise').x * ]]..perlinXRange..[[;
        getVar('barrelOffset').y = getVar('_noise').y * ]]..perlinYRange..[[;
        getVar('barrelOffset').angle = (getVar('_noise').z * ]]..perlinZRange..[[) + getVar('barrelOffset').offsetAngle;

        if (getVar('vignette').shader != null) { 
            getVar('vignette').lerpedStrength = FlxMath.lerp(getVar('vignette').lerpedStrength, getVar('vignette').strength, (elapsed * game.playbackRate) * 5);
            getVar('vignette').lerpedSize = FlxMath.lerp(getVar('vignette').lerpedSize, getVar('vignette').size, (elapsed * game.playbackRate) * 5);
            getVar('vignette').shader.setFloat('strength', getVar('vignette').lerpedStrength);
            getVar('vignette').shader.setFloat('size', getVar('vignette').lerpedSize);
            getVar('vignette').shader.setFloat('red', getVar('vignette').red);
            getVar('vignette').shader.setFloat('green', getVar('vignette').green);
            getVar('vignette').shader.setFloat('blue', getVar('vignette').blue);
        }
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