local anims = {"LEFT", "DOWN", "UP", "RIGHT"}

function onCreate()
    makeLuaCharacter('tommy', 590, 400, 'tommy')
    setScrollFactor("tommy", 0.95, 0.95)
    scaleObject("tommy", 0.83, 0.83)
    addLuaCharacter('tommy')
    makeLuaCharacter('beef', 270, 350, 'beefbossbasketball')
    addLuaCharacter('beef')

    makeLuaCharacter('bf', 2000, 670, 'bfbasketball', true)
    setScrollFactor("bf", 0.95, 0.95)
    scaleObject("bf", 0.83, 0.83)
    addLuaCharacter('bf')
    makeLuaCharacter('gf', 2325, 400, 'gfbasketball', true)
    addLuaCharacter('gf')
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if noteType == "BeefBoss" or noteType == "BeefBossMatt" then
        playCharacterAnim('beef', 'sing'..anims[noteData+1], true)
    end
    if noteType == "Tommy" or noteType == "TommyMatt" then
        playCharacterAnim('tommy', 'sing'..anims[noteData+1], true)
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if noteType == "GF" or noteType == "GFPico" or noteType == "GFBF" then
        playCharacterAnim('gf', 'sing'..anims[noteData+1], true)
    end
    if noteType == "BF" or noteType == "BFPico" or noteType == "GFBF" then
        playCharacterAnim('bf', 'sing'..anims[noteData+1], true)
    end
end