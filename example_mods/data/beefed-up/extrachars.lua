local anims = {"LEFT", "DOWN", "UP", "RIGHT"}

function onCreate()
    makeLuaCharacter('matt', 550, 325, 'mattbasketball')
    addLuaCharacter('matt')
    makeLuaCharacter('gf', 2100, 325, 'gfbasketball', true)
    addLuaCharacter('gf')
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if noteType == "Matt" or noteType == "BBMatt" then
        playCharacterAnim('matt', 'sing'..anims[noteData+1], true)
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if noteType == "GF" or noteType == "GFPico" then
        playCharacterAnim('gf', 'sing'..anims[noteData+1], true)
    end
end