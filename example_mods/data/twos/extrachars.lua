local anims = {"LEFT", "DOWN", "UP", "RIGHT"}

function onCreate()
    makeLuaCharacter('beef', 565, 310, 'beefbossbasketball')
    scaleObject("beef", 0.9, 0.9)
    setScrollFactor("beef", 0.95, 0.95)
    addLuaCharacter('beef')
    makeLuaCharacter('gf', 1950, 325, 'gfbasketball', true)
    scaleObject("gf", 0.9, 0.9)
    setScrollFactor("gf", 0.95, 0.95)
    addLuaCharacter('gf')
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if noteType == "BeefBoss"  then
        playCharacterAnim('beef', 'sing'..anims[noteData+1], true)
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if noteType == "GF" then
        playCharacterAnim('gf', 'sing'..anims[noteData+1], true)
    end
end