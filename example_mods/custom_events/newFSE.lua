function onCreate()
    makeLuaSprite('Fadeblackscreen', '', -1000, -1000)
    setScrollFactor('Fadeblackscreen', 0, 0)
    makeGraphic('Fadeblackscreen', 5000, 5000, '000000')
    addLuaSprite('Fadeblackscreen', false)
    setObjectCamera('Fadeblackscreen', 'other')
    setProperty('Fadeblackscreen.alpha', 1)
end

function onEvent(eventName, value1, value2)
    if eventName == 'newFSE' then
        doTweenAlpha('fse', 'Fadeblackscreen', value1, value2, 'linear')
    end
end