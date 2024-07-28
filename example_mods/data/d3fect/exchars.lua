local anims = {"LEFT", "DOWN", "UP", "RIGHT"}

function onCreate()
    makeLuaCharacter('defectedblue', -875, -90, 'defectedblue')
    makeLuaCharacter('picobb', 300, 200, 'picobasketball', true)
    addLuaCharacter('picobb')
end

function onCreatePost()
    addLuaCharacter('defectedblue')
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if noteType == "BF"  then
        playCharacterAnim('defectedblue', 'sing'..anims[noteData+1], true)
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if noteType == "GF" or noteType == "GFBF" then
        playCharacterAnim('picobb', 'sing'..anims[noteData+1], true)
    end
    if noteType == "GFBF" then
        playAnim("boyfriend", 'sing'..anims[noteData+1], true)
    end
end

function onUpdatePost(elapsed)
    setProperty('defectedblue.x', getProperty('defectedblue.x') + 1 * math.sin(curDecBeat / 4 * math.pi) * elapsed * 60)
	setProperty('defectedblue.y', getProperty('defectedblue.y') + 2 * math.cos(curDecBeat / 4 * math.pi) * elapsed * 60)
    setProperty("picobb.shadow.y", 575)
end