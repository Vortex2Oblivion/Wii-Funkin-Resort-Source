offsetsX = {-75, 0, 0, 75}
offsetsY = {0, 75, -75, 0}
function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if not mustHitSection or not cameraTracksDirection then
		return
	end
	triggerEvent('Camera Follow Pos', getProperty('boyfriend.cameraPosition')[1] + offsetsX[noteData + 1] + getProperty('boyfriend.x') + (getProperty('boyfriend.width')/2) - 100, getProperty('boyfriend.cameraPosition')[2] + offsetsY[noteData + 1] + getProperty('boyfriend.y') + (getProperty('boyfriend.height')/2) - 100)
end
function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if mustHitSection or not cameraTracksDirection then
		return
	end
	triggerEvent('Camera Follow Pos', getProperty('dad.cameraPosition')[1] + offsetsX[noteData + 1] + getProperty('dad.x') + (getProperty('dad.width')/2) + 150, getProperty('dad.cameraPosition')[2] + offsetsY[noteData + 1] + getProperty('dad.y') + (getProperty('dad.height')/2) - 100)
end
